
ad_page_contract {


} {
    {date ""}
} -validate {
    valid_date -requires { date } {
        if {![string equal $date ""]} {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "The date format was invalid. It has to be in the form YYYYMMDD."
            }
        }
    }
}

