#!/bin/sh

main() {

    . ../p6common/lib/_bootstrap.sh
    p6_bootstrap "../p6common"

    . ../p6test/lib/_bootstrap.sh
    p6_p6test_bootstrap "../p6test"

    . lib/p6_return.sh
    . lib/_store.sh
    . lib/_store/string.sh

    p6_test_setup "22"

    p6_test_start "p6_store_string_create"
    (
	local s=$(p6_store_create "s")
	p6_test_run "p6_store_string_create"
	p6_test_assert_run_ok "no args"

	p6_test_run "p6_store_string_create" "$s"
	p6_test_assert_run_ok "store only"

	p6_test_run "p6_store_string_create" "$s" "string_name"
	p6_test_assert_run_ok "store, string_string_name"
	p6_test_assert_dir_exists "$s/string_name" "string string_named/inited: $s/string_name"

	p6_store_destroy "$s"
	p6_test_assert_dir_not_exists "$s/string_name" "$s/string_name: cleaned up"
    )
    p6_test_finish

    p6_test_start "p6_store_string_set"
    (
	local s=$(p6_store_create "s")
	p6_store_string_create "$s" "string_name"
	p6_test_run "p6_store_string_set" "$s" "string_name" "philip"
	p6_test_assert_run_ok "string<-philip"

	local val=$(p6_store_string_get "$s" "string_name")
	p6_test_assert_eq "philip" "$val" "val retreived"

	p6_test_run "p6_store_string_set" "$s" "string_name" "gollucci"
	p6_test_assert_blank "$(p6_test_run_stderr)" "s string_name no stderr"
	p6_test_assert_contains "philip" "$(p6_test_run_stdout)" "previous val returned when set"

	val=$(p6_store_string_get "$s" "string_name")
	p6_test_assert_eq "gollucci" "$val" "new val retreived"

	p6_store_destroy "$s"
	p6_test_assert_dir_not_exists "$s/string_name" "$s/string_name: cleaned up"
    )
    p6_test_finish

    p6_test_start "p6_store_string_get"
    (
	local s=$(p6_store_create "s")
	p6_store_string_create "$s" "string_name"
	local junk=$(p6_store_string_set "$s" "string_name" "matthew")

	p6_test_run "p6_store_string_get" "$s" "string_name"
	p6_test_assert_blank "$(p6_test_run_stderr)" "s string_name: no stderr"
	p6_test_assert_contains "matthew" "$(p6_test_run_stdout)" "val retreived"

	p6_store_destroy "$s"
	p6_test_assert_dir_not_exists "$s/string_name" "$s/string_name: cleaned up"
    )
    p6_test_teardown
}

main "$@"
