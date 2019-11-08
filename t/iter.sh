#!/bin/sh

main() {

    . ../p6common/lib/_bootstrap.sh
    p6_bootstrap "../p6common"

    . ../p6test/lib/_bootstrap.sh
    p6_p6test_bootstrap "../p6test"

    . lib/p6_return.sh
    . lib/_store.sh
    . lib/_store/iter.sh

    p6_test_setup "0"

    p6_test_start "p6_store_iter_create"
    (
	local s=$(p6_store_create "s")

	p6_test_run "p6_store_iter_create"
	p6_test_assert_run_ok "no args"

	p6_test_run "p6_store_iter_create" "$s"
	p6_test_assert_run_ok "store only"

	p6_store_iter_create "$s" "iter_name"
	p6_test_assert_run_ok "store, iter_name"

	p6_store_destroy "$s"
	p6_test_assert_dir_not_exists "$s/iter_name" "$s/iter_name: cleaned up"
    )
    p6_test_finish

    p6_test_teardown
}

main "$@"
