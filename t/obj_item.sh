#!/bin/sh

main() {

    . ../p6common/lib/_bootstrap.sh
    p6_bootstrap "../p6common"

    . ../p6test/lib/_bootstrap.sh
    p6_p6test_bootstrap "../p6test"

    . lib/p6_return.sh
    . lib/_store.sh
    . lib/_store/hash.sh
    . lib/_store/list.sh
    . lib/_store/string.sh
    . lib/api.sh

    p6_test_setup "0"

    p6_test_start "p6_obj_item_set"
    (
	p6_test_run "p6_obj_item_set"
	p6_test_assert_run_ok "no args"

	p6_test_run "p6_obj_item_set" ""
	p6_test_assert_run_ok "\"\""

	p6_test_run "p6_obj_item_set" "dne"
	p6_test_assert_run_ok "dne"

	local obj
	obj=$(p6_obj_create "hash")
	p6_test_run "p6_obj_item_set" "$obj"
	p6_test_assert_run_ok "$obj"

	obj=$(p6_obj_create "hash")
	p6_test_run "p6_obj_item_set" "$obj" "key"
	p6_test_assert_run_ok "obj key"

	obj=$(p6_obj_create "hash")
	p6_test_run "p6_obj_item_set" "$obj" "key" "val"
	p6_test_assert_run_ok "obj key val"

	p6_test_run "p6_obj_item_get" "$obj" "key"
	p6_test_assert_run_ok "obj value of key is correct" "" "val"

	obj=$(p6_obj_create "list")
	p6_test_run "p6_obj_item_set" "$obj"
	p6_test_assert_run_ok "$obj"

	obj=$(p6_obj_create "list")
	p6_test_run "p6_obj_item_set" "$obj" "2"
	p6_test_assert_run_ok "obj 2"

	obj=$(p6_obj_create "list")
	p6_test_run "p6_obj_item_set" "$obj" "2" "val"
	p6_test_assert_run_ok "obj 2 val"

	p6_test_run "p6_obj_item_get" "$obj" "2"
	p6_test_assert_run_ok "obj value of idx 2 is correct" "" "val"

	obj=$(p6_obj_create "string")o
	p6_test_run "p6_obj_item_set" "$obj"
	p6_test_assert_run_ok "$obj"

	obj=$(p6_obj_create "string")
	p6_test_run "p6_obj_item_set" "$obj" "2"
	p6_test_assert_run_ok "obj 2"

	obj=$(p6_obj_create "string")
	p6_test_run "p6_obj_item_set" "$obj" "val"
	p6_test_assert_run_ok "obj val" "" ""

	p6_test_run "p6_obj_item_get" "$obj"
	p6_test_assert_run_ok "obj value is correct" "" "val"
    )
    p6_test_finish

    p6_test_start "p6_obj_item_get"
    (
	p6_test_todo "$P6_TRUE" "$P6_TRUE" "todo" "lazy"
    )
    p6_test_finish

    p6_test_start "p6_obj_item_add"
    (
	p6_test_todo "$P6_TRUE" "$P6_TRUE" "todo" "lazy"
    )
    p6_test_finish

    p6_test_start "p6_obj_item_delete"
    (
	p6_test_todo "$P6_TRUE" "$P6_TRUE" "todo" "lazy"
    )
    p6_test_finish

    p6_test_teardown
}

main "$@"
