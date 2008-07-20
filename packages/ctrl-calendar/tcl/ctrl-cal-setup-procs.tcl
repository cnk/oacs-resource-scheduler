ad_library {
    Set of procs to setup the calendar per user

    @author KH
    @cvs-id $Id$
    @creation-date 2005-02-13
}

namespace eval crs::cal::setup {}

ad_proc -public crs::cal::setup::personal_initialize {
    -user_id 
} {
    Creates a personalized calendar for the user if it does not exist
    @param user_id 
} {
    # ------------------------------------------
    # Check if user has an account already created 
    # -------------------------------------------
    set user_calendar_id [db_string user_calendar {**SQL**} -default 0]

    if {$user_calendar_id == 0}  {
	set var_list [list\
			  [list cal_name "My Calendar"]\
			  [list description "Personal Calendar"]\
			  [list owner_id $user_id]\
			  [list object_id $user_id]]
	set user_calendar_id [ctrl::cal::new -var_list $var_list]
    }
    return $user_calendar_id 
}
