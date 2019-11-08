#!/bin/sh

main() {

    . ../p6common/lib/_bootstrap.sh
    p6_bootstrap "../p6common"

    . ../p6test/lib/_bootstrap.sh
    p6_p6test_bootstrap "../p6test"

    . lib/p6_return.sh
    . lib/_store.sh
    . lib/api.sh

    p6_test_setup "0"

    p6_test_start "p6_obj_create"
    (
	true
    )
    p6_test_finish

    p6_test_teardown
}

main "$@"
