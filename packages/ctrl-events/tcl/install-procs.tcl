# /packages/ctrl-events/tcl/install-procs.tcl

ad_library {

    CTRL EVENT Install Procedures
    @creation-date 2006/4/27
    @update-date 2008/08/30 (ported to postgres)

    @author avni@ctrl.ucla.edu (AK)
} 

namespace eval ctrl_event::install {}

ad_proc -private ctrl_event::install::after_instantiate {
    {-package_id:required}
} {
    Check to see if an instance is already mounted at this subsite
} {
    # -----------------------------------------------------------------------------------------------------------------------------
    # ROOT CATEGORY AND PACKAGE ROOT
    # -----------------------------------------------------------------------------------------------------------------------------
    set root_id [ctrl_event::category::create_root]
    set package_root_id [ctrl_event::category::create_for_package -package_id $package_id]
    # -----------------------------------------------------------------------------------------------------------------------------
    # END ROOT CATEGORY
    # -----------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------
    # Add default event categories
    # -----------------------------------------------------------------------------------------------------------------------------
    set ctrl_event_category_list [list Class Conference Meeting Seminar]

    foreach name $ctrl_event_category_list {
        ctrl_event::category::new \
                -parent_category_id $package_root_id \
                -name $name \
                -plural $name \
                -description $name \
	        -context_id $package_id
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # END Add default event categories
    # -----------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------
    # Add default event object categories
    # -----------------------------------------------------------------------------------------------------------------------------
    set ctrl_event_category_root_id [ctrl_event::category::new \
					 -parent_category_id $package_root_id \
					 -name "CTRL Events Objects" \
					 -plural "CTRL Events Objects" \
					 -description "CTRL Events Objects" \
					 -context_id $package_id]

    set ctrl_event_category_list [list "Speaker Name" "Speaker Image" "Speaker Affiliation"]

    foreach name $ctrl_event_category_list {
        ctrl_event::category::new \
                -parent_category_id $ctrl_event_category_root_id \
                -name $name \
                -plural $name \
                -description $name \
	        -context_id $package_id
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # END Add default event object categories
    # -----------------------------------------------------------------------------------------------------------------------------
}

ad_proc -private ctrl_event::install::before_uninstantiate {
    {-package_id:required}
} {
    Delete package instance categories
} {
    ns_log notice "ctrl_event::install::before_uninstantiate - $package_id"
    
    # Delete event data; There is "on delete cascade" on event_id fks
    db_foreach delete_event_data {} {}

    ctrl::category::before_uninstantiate -package_id $package_id
}

ad_proc -private ctrl_event::install::before_uninstall {
} {
    Delete the "CTRL Events" category
} {
    set event_category_id [ctrl::category::find -path "CTRL Events"]
    ns_log notice "EVENT_CATEGORY_ID: $event_category_id"
    ctrl::category::remove -category_id $event_category_id
}