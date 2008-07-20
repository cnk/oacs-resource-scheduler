# /packages/acs-datetime/www/doc/examples/datetime-widgets.tcl

ad_page_contract {

    Examples of the basic dt_ widgets

    @author  ron@arsdigita.com
    @creation-date 2000/12/01
    @cvs-id  $Id: datetime-widgets.tcl,v 1.2 2002-09-10 22:22:08 jeffd Exp $
} -properties {
    dt_examples:multirow
}

set title "ACS DateTime Examples"

set example_list {
    "dt_widget_datetime -default now name"
    "dt_widget_datetime -show_date 0 -use_am_pm 1 name halves"
    "dt_widget_datetime -show_date 0 -default now name halves"
    ""
    "dt_widget_datetime -show_date 0 name seconds"
    "dt_widget_datetime -show_date 0 name minutes"
    "dt_widget_datetime -show_date 0 name fives"
    "dt_widget_datetime -show_date 0 name quarters"
    "dt_widget_datetime -show_date 0 name halves"
    "dt_widget_datetime -show_date 0 name hours"
    "dt_widget_datetime -show_date 0 -use_am_pm 1 name hours"
    ""
    "dt_widget_datetime name days"
    "dt_widget_datetime name months"
    
}

# Generate a multirow datasource to transmit the examples to the
# template.  Then we just loop over the examples list to generate all
# of the display information.

multirow create dt_examples "procedure" "result"

foreach example $example_list {
    multirow append dt_examples $example [eval $example]
}

ad_return_template
