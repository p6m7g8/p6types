#!/bin/sh

main() {

    . ../p6common/lib/_bootstrap.sh
    p6_bootstrap "../p6common"

    . ../p6test/lib/_bootstrap.sh
    p6_p6test_bootstrap "../p6test"

    . lib/p6_return.sh
    . lib/_store.sh
    . lib/_store/hash.sh
    . lib/api.sh

    p6_test_setup "62"

    p6_test_start "p6_obj_create"
    (
	p6_test_run "p6_obj_create"
	p6_test_assert_run_ok "no args" "" "*p6/transients/objs/obj/*"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)" "obj: exists -> $(p6_test_run_stdout)"
	p6_test_assert_contains "objs/obj" "$(p6_test_run_stdout)" "correct class in ref"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/meta" "meta exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/data" "data exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/iterators" "iterators exists"
	local obj=$(p6_test_run_stdout)
	p6_test_assert_eq "$(p6_obj_length "$obj")" "0" "length is 0"
	p6_test_assert_eq "$(p6_obj_class "$obj")" "obj" "class is obj"

	p6_test_run "p6_obj_create" "dne"
	p6_test_assert_run_ok "dne" "" "*p6/transients/objs/dne/*"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)" "dne: exists -> $(p6_test_run_stdout)"
	p6_test_assert_contains "objs/dne" "$(p6_test_run_stdout)" "correct class in ref"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/meta" "meta exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/data" "data exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/iterators" "iterators exists"
	local obj=$(p6_test_run_stdout)
	p6_test_assert_eq "$(p6_obj_length "$obj")" "0" "length is 0"
	p6_test_assert_eq "$(p6_obj_class "$obj")" "dne" "class is dne"

	p6_test_run "p6_obj_create" "hash"
	p6_test_assert_run_ok "hash" "" "*p6/transients/objs/hash/*"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)" "hash: exists -> $(p6_test_run_stdout)"
	p6_test_assert_contains "objs/hash" "$(p6_test_run_stdout)" "correct class in ref"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/meta" "meta exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/data" "data exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/iterators" "iterators exists"
	local obj=$(p6_test_run_stdout)
	p6_test_assert_eq "$(p6_obj_length "$obj")" "0" "length is 0"
	p6_test_assert_eq "$(p6_obj_class "$obj")" "hash" "class is hash"

	p6_test_run "p6_obj_create" "list"
	p6_test_assert_run_ok "list" "" "*p6/transients/objs/list/*"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)" "list: exists -> $(p6_test_run_stdout)"
	p6_test_assert_contains "objs/list" "$(p6_test_run_stdout)" "correct class in ref"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/meta" "meta exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/data" "data exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/iterators" "iterators exists"
	local obj=$(p6_test_run_stdout)
	p6_test_assert_eq "$(p6_obj_length "$obj")" "0" "length is 0"
	p6_test_assert_eq "$(p6_obj_class "$obj")" "list" "class is list"

	p6_test_run "p6_obj_create" "string"
	p6_test_assert_run_ok "string" "" "*p6/transients/objs/string/*"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)" "string: exists -> $(p6_test_run_stdout)"
	p6_test_assert_contains "objs/string" "$(p6_test_run_stdout)" "correct class in ref"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/meta" "meta exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/data" "data exists"
	p6_test_assert_dir_exists "$(p6_test_run_stdout)/iterators" "iterators exists"
	local obj=$(p6_test_run_stdout)
	p6_test_assert_eq "$(p6_obj_length "$obj")" "0" "length is 0"
	p6_test_assert_eq "$(p6_obj_class "$obj")" "string" "class is string"

	p6_test_run "p6_obj_create obj" "-1"
	p6_test_assert_run_ok "-1" "" "*p6/transients/objs/obj/*"

	p6_test_run "p6_obj_create obj" "0"
	p6_test_assert_run_ok "0" "" "*p6/transients/objs/obj/*"

	p6_test_run "p6_obj_create obj" "1"
	p6_test_assert_run_ok "1" "" "*p6/transients/objs/obj/*"

	p6_test_run "p6_obj_create obj" "31" # max?
	p6_test_assert_run_ok "31" "" "*p6/transients/objs/obj/*"
    )
    p6_test_finish

    p6_test_start "p6_obj_copy"
    (
	true
    )
    p6_test_finish

    p6_test_start "p6_obj_destroy"
    (
	true
    )
    p6_test_finish

    p6_test_start "p6_obj_compare"
    (
	true
    )
    p6_test_finish

    p6_test_start "p6_obj_assign"
    (
	true
    )
    p6_test_finish

    p6_test_start "p6_obj_display"
    (
	true
    )
    p6_test_finish

    p6_test_teardown
}

main "$@"
