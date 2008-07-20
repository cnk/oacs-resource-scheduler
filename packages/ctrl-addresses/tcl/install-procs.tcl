ad_library {

    CTRL Address Install Procedures
    @creation-date 2005-12-14
    @author avni@ctrl.ucla.edu (AK)
}

namespace eval ctrl::address::install {}

ad_proc -private ctrl::address::install::after_instantiate {
    {-package_id:required}
} {
    Check to see if an instance is already mounted at this subsite
} {
    # -----------------------------------------------------------------------------------------------------------------------------
    # ROOT CATEGORY AND PACKAGE ROOT
    # -----------------------------------------------------------------------------------------------------------------------------
    set root_id [ctrl::address::category::create_root]
    set package_root_id [ctrl::address::category::create_for_package -package_id $package_id]
    # -----------------------------------------------------------------------------------------------------------------------------
    # END ROOT CATEGORY
    # -----------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------
    # ADDRESS TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
    set address_type_root_id [ctrl::address::category::new \
		-parent_category_id $package_root_id \
		-name "Address Type"\
		-plural "Address Types"\
		-description "Address Type Categories"]

    set address_type_list [list "Home" "Office" "Labaratory" "Building"]

    foreach name $address_type_list {
        ctrl::address::category::new \
	    -parent_category_id $address_type_root_id \
	    -name $name \
	    -plural $name \
	    -description $name
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # END ADDRESS TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------
    # BUILDING CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
    set building_root_id [ctrl::address::category::new \
		-parent_category_id $package_root_id \
		-name "Buildings"\
		-plural "Buildings"\
		-description "Buildings"]

    set building_list [list "200 Medical Plaza" "300 Medical Plaza" "CHS" "CHS Library" "Crump Institute" "Factor Building" \
			   "Jules Stein Eye Institute" "MacDonald Research Laboratory" "Reed" "Neuropsychiatric Institute (NPI)" \
			   "MDCC"]

    foreach name $building_list {
        ctrl::address::category::new \
                -parent_category_id $building_root_id \
                -name $name \
                -plural $name \
                -description $name
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # BUILDING CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
}
