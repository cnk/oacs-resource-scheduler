ad_library {
    
    CTRL Calendar Install Procedures
    @creation-date 2005-12-14
    @author avni@ctrl.ucla.edu (AK)
} 

namespace eval ctrl::cal::install {}

ad_proc -private ctrl::cal::install::after_instantiate {
    {-package_id:required}
} {
    Create categories
} {
    # -----------------------------------------------------------------------------------------------------------------------------
    # ROOT CATEGORY AND PACKAGE ROOT
    # -----------------------------------------------------------------------------------------------------------------------------
    set root_id [ctrl::cal::category::create_root]
    set package_root_id [ctrl::cal::category::create_for_package -package_id $package_id]
    # -----------------------------------------------------------------------------------------------------------------------------
    # END ROOT CATEGORY
    # -----------------------------------------------------------------------------------------------------------------------------
    
    # -----------------------------------------------------------------------------------------------------------------------------
    # EVENT TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
    set event_type_root_id [ctrl::cal::category::new \
				-parent_category_id $package_root_id \
				-name "Event Categories" \
				-plural "Event Categories" \
				-description "Event Categories"]

    set event_type_list [list "Cancer research" "Chemistry" "General" "Medicine" "Nano Technology" "Radiology"]

    foreach name $event_type_list {
        set ctrl_cal_sub_cat_id [ctrl::cal::category::new \
				     -parent_category_id $event_type_root_id \
				     -name $name \
				     -plural $name \
				     -description $name]

	switch $name {
	    "Cancer research" {
		set ctrl_cal_sub_cat_list [list "Bladder Cancer" "Non-Hodgkin's Lymphoma" "Breast Cancer" "Colon & Rectal Cancer" "Endometrial Cancer" "Kidney Cancer" "Leukemia Cancer" "Lung Cancer" "Melanoma" "Ovarian Cancer" "Pancreatic Cancer" "Prostate Cancer" "Skin Cancer"]
	    }
	    "Chemistry" {
		set ctrl_cal_sub_cat_list [list "Biochemistry" "Inorganic Chemistry" "Organic Chemistry" "Physical Chemistry"]
	    }
	    default {
		set ctrl_cal_sub_cat_list ""
	    }
	}

	foreach sub_cat_name $ctrl_cal_sub_cat_list {
	    ctrl::cal::category::new \
                -parent_category_id $ctrl_cal_sub_cat_id \
                -name $sub_cat_name \
                -plural $sub_cat_name \
                -description $sub_cat_name
	}
    }

    # -----------------------------------------------------------------------------------------------------------------------------
    # END EVENT TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
}

ad_proc -private ctrl::cal::install::before_uninstantiate {
    {-package_id:required}
} {
    Delete categories belonging to this package
} {
    ns_log notice "CTRL::CAL::INSTALL::BEFORE_UNINSTANTIATE start"
    db_transaction {
	db_exec_plsql remove_package_categories {}
    }
    ns_log notice "CTRL::CAL::INSTALL::BEFORE_UNINSTANTIATE end"
}
