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
    And create package instance categories
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
		-description "Address Type Categories" \
		-context_id $package_id]

    set address_type_list [list "Home" "Office" "Labaratory" "Building"]

    foreach name $address_type_list {
        ctrl::address::category::new \
	    -parent_category_id $address_type_root_id \
	    -name $name \
	    -plural $name \
	    -description $name \
	    -context_id $package_id
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
		-description "Buildings"\
		-context_id $package_id]

    set building_list [list "200 Medical Plaza" "300 Medical Plaza" "CHS" "CHS Library" "Crump Institute" "Factor Building" \
			   "Jules Stein Eye Institute" "MacDonald Research Laboratory" "Reed" "Neuropsychiatric Institute (NPI)" \
			   "MDCC"]

    foreach name $building_list {
        ctrl::address::category::new \
                -parent_category_id $building_root_id \
                -name $name \
                -plural $name \
                -description $name \
	        -context_id $package_id
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # BUILDING CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
}

ad_proc -private ctrl::address::install::before_uninstantiate {
    {-package_id:required}
} {
    Delete package instance categories
} {
    ns_log notice "ctrl::address::install::before_uninstantiate - $package_id"
    ctrl::category::before_uninstantiate -package_id $package_id
}

ad_proc -private ctrl::address::install::before_uninstall {
} {
    Delete the "CTRL Address" category
} {
    set address_category_id [ctrl::category::find -path "CTRL Address"]
    ns_log notice "ADDRESS_CATEGORY_ID: $address_category_id"
    ctrl::category::remove -category_id $address_category_id
}