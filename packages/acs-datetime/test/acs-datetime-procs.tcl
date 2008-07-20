ad_library {
    Automated tests.

    @author Simon Carstensen
    @creation-date 16 Nov 2003
    @cvs-id $Id: acs-datetime-procs.tcl,v 1.1 2003-12-10 16:03:29 simonc Exp $
}

aa_register_case dt_valid_time_p {
    Test dt_valid_time_p proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set valid_time_p [dt_valid_time_p "13:00"]
            aa_true "Time is valid" $valid_time_p

            set valid_time_p [dt_valid_time_p ":"]
            aa_true "Time is not valid" !$valid_time_p
        }
}

aa_register_case dt_ansi_to_julian_single_arg {
    Test dt_ansi_to_julian_single_arg proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set date [dt_ansi_to_julian_single_arg "2003-01-01 01:01:01"]
            aa_equals "Returns correct julian date" $date "2452641"

        }
}

aa_register_case dt_ansi_to_julian {
    Test dt_ansi_to_julian proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set date [dt_ansi_to_julian "2003" "01" "01"]
            aa_equals "Returns correct julian date" $date "2452641"

        }
}

aa_register_case dt_julian_to_ansi {
    Test dt_julian_to_ansi proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set date [dt_julian_to_ansi "2452641"]
            aa_equals "Returns correct ansi date" $date "2003-01-01"

        }
}

aa_register_case dt_ansi_to_list {
    Test dt_ansi_to_list proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set list [dt_ansi_to_list "2003-01-01 01:01:01"]
            aa_equals "Returns correct ansi date" $list {2003 1 1 1 1 1}

        }
}

aa_register_case dt_num_days_in_month {
    Test dt_num_days_in_month proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set num_days [dt_num_days_in_month 2003 2]
            aa_equals "Number of days in February is 28" $num_days 28

            set num_days [dt_num_days_in_month 2003 12]
            aa_equals "Number of days in November is 30" $num_days 31

        }
}
