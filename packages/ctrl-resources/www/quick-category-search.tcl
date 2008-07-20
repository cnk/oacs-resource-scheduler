ad_page_contract {
    grouping of categories

    @param group_name 
} {
    group_name:notnull
}

set eq_list ""
switch $group_name {
    video {
	set eq_list [list "AV Booth" "DVD Player" "VCR" TV]
    }
    data_projector {
	set eq_list [list "LCD Projector"]
    }
    slide_projector {
	set eq_list [list "Slide Projector" "Overhead Projector"]
    }
    sound {
	set eq_list [list "Microphone" "Microphone Outlet"]
    }
}

set eq_option_list [crs::ctrl::category::option_list -path "//Equipment Types"]

set req_param_list [list]
foreach req_option $eq_list {
    foreach option_info $eq_option_list {
	set label [lindex $option_info 0]
	if [string equal -nocase $label $req_option] {
	    set eq_id [lindex $option_info 1]
	    lappend req_param_list "eq=$eq_id"
	}
    }
}

ad_returnredirect "room-search-results?[join $req_param_list "&"]"
ad_script_abort

