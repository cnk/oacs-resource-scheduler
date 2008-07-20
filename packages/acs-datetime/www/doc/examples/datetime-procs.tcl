# /packages/acs-datetime/www/doc/examples/datetime-procs.tcl

ad_page_contract {

    Examples of the basic dt_ procs

    @author  ron@arsdigita.com
    @creation-date 2000/12/01
    @cvs-id  $Id: datetime-procs.tcl,v 1.2 2002-09-10 22:22:08 jeffd Exp $
} -properties {
    dt_examples:multirow
}

set title "ACS DateTime Examples"

set example_list {
    "dt_systime"
    "dt_systime -gmt t"
    "dt_systime -format \"%Y-%m-%d %H:%M:%S %Z\""
    "dt_sysdate"
    "dt_sysdate -format \"%b %d, %Y\""
    "dt_sysdate -format \"%b %e, %Y\""
    "dt_ansi_to_pretty"
    "dt_ansi_to_list"
    "dt_julian_to_ansi 2451915"
    "dt_month_names"
    "dt_month_abbrev"
    "dt_valid_time_p \"bad date\""
    "dt_valid_time_p \"2001-01-05\""
    "dt_valid_time_p \"2001-01-05 12:00 pm\""
    "dt_interval_check \"2001-01-01\" \"2001-02-01\""
    "dt_interval_check \"2001-02-01\" \"2001-02-01\""
    "dt_interval_check \"2001-02-01\" \"2001-01-01\""
}

# Generate a multirow datasource to transmit the examples to the
# template.  Then we just loop over the examples list to generate all
# of the display information.

multirow create dt_examples "procedure" "result"

foreach example $example_list {
    multirow append dt_examples $example [eval $example]
}

ad_return_template


