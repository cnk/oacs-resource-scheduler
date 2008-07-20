ad_library {
    
    CTRL Resource Install Procedures
    @creation-date 2005-12-14
    @author avni@ctrl.ucla.edu (AK)
} 

namespace eval crs::install {}

ad_proc -private crs::install::after_instantiate {
    {-package_id:required}
} {
    Create categories
} {
    # -----------------------------------------------------------------------------------------------------------------------------
    # ROOT CATEGORY AND PACKAGE ROOT
    # -----------------------------------------------------------------------------------------------------------------------------
    set root_id [crs::ctrl::category::create_root]
    set package_root_id [crs::ctrl::category::create_for_package -package_id $package_id]
    # -----------------------------------------------------------------------------------------------------------------------------
    # END ROOT CATEGORY
    # -----------------------------------------------------------------------------------------------------------------------------
    
    # -----------------------------------------------------------------------------------------------------------------------------
    # ROOM TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
    set room_type_root_id [crs::ctrl::category::new \
            -parent_category_id $package_root_id \
            -name "Room Types" \
            -plural "Room Types" \
	    -description "Room Types"]

    set room_type_list [list Classroom  Classroom Classroom "Conference Room" "Conference Room" "Conference Room" \
			    "Laboratory" "Laboratory" "Laboratory" "Lecture Hall" "Lecture Hall" "Lecture Hall"]

    foreach [list name plural description] $room_type_list {
        crs::ctrl::category::new \
                -parent_category_id $room_type_root_id \
                -name $name \
                -plural $plural \
                -description $description
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # END ROOM TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------


    # -----------------------------------------------------------------------------------------------------------------------------
    # EQUIPMENT TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
    set equipment_type_root_id [crs::ctrl::category::new \
            -parent_category_id $package_root_id \
            -name "Equipment Types" \
            -plural "Equipment Types" \
	    -description "Equipment Types"]

    set equipment_type_list [list "AV Booth" "AV Booth" "AV Booth" "Chair" "Chair" "Chair" "Chalkboard" "Chalkboard" "Chalkboard" \
			    "Computer" "Computer" "Computer" "Desk" "Desk" "Desk" "Dry-Erase Board" "Dry-Erase Board" "Dry-Erase Board" \
			    "DVD Player" "DVD Player" "DVD Player" "Folding Chair" "Folding Chair" "Folding Chair" "Internet Access" \
			    "Internet Access" "Internet Access" "Laptop" "Laptop" "Laptop" "Microphone" "Microphone" "Microphone" \
			    "Microphone Outlet" "Microphone Outlet" "Microphone Outlet" "Multiscope"  "Multiscope"  "Multiscope" \
			    "Podium" "Podium" "Podium" "Projector" "Projector" "Projector" "Projector Screen" "Table" "Table" "Table" \
				 "TV" "TV" "TV" "VCR" "VCR" "VCR" "X-ray Viewer" "X-ray Viewer" "X-ray Viewer"]
 
    foreach [list name plural description] $equipment_type_list {
        crs::ctrl::category::new \
                -parent_category_id $equipment_type_root_id \
                -name $name \
                -plural $plural \
                -description $description
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # END EQUIPMENT TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------
    # PROJECTOR TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
    set projector_type_id [crs::ctrl::category::find -path "Equipment Types//Projector" -package_id $package_id]

    set projector_type_list [list "LCD Projector"  "LCD Projector" "LCD Projector" "Overhead Projector" "Overhead Projector" "Overhead Projector" \
				 "Slide Projector" "Slide Projector" "Slide Projector"]

    foreach [list name plural description] $projector_type_list {
        crs::ctrl::category::new \
                -parent_category_id $projector_type_id \
                -name $name \
                -plural $plural \
                -description $description
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # END PROJECTOR TYPE CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------
    # DEPARTMENT CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
    set department_root_id [crs::ctrl::category::new \
		-parent_category_id $package_root_id \
		-name "Departments" \
		-plural "Departments" \
		-description "Departments"]

    set department_list [list "Hospital" "Hospital Administration" "Anesthesiology" \
			     "Biological Chemistry" "Biomathematics" "Biomedical Library" "History of Medicine" \
			     "Cardiology" "Crump Institute" "David Geffen School of Medicine" \
			     "Dentistry" "Jonsson Comprehensive Cancer Center" "Jules Stein Eye Institute" \
			     "MacDonald Research (MRL)" "Microbiology and Immunology" "Neurobiology" \
			     "Neurology" "Neuropsychiatric Institute (NPI)" "Nursing" "Nursing Research and Education" \
			     "OB/GYN" "Pathology" "Pediatrics" "Pharmacology" "Physiology" "Psychology" "Public Health" "Radiological Sciences" \
			     "Women's Health Initiative" "Surgery" "Surgery (Head and Neck)" "Urology"]

    foreach name $department_list {
        crs::ctrl::category::new \
                -parent_category_id $department_root_id \
                -name $name \
                -plural $name \
                -description $name
    }
    # -----------------------------------------------------------------------------------------------------------------------------
    # END DEPARTMENT CATEGORIES
    # -----------------------------------------------------------------------------------------------------------------------------
}


ad_proc -private crs::install::before_uninstantiate {
    {-package_id:required}
} {
    Delete categories belonging to this package
} {
    ns_log notice "CRS::INSTALL::BEFORE_UNINSTANTIATE start"
    db_transaction {
	db_exec_plsql remove_package_categories {}
    }
    ns_log notice "CRS::INSTALL::BEFORE_UNINSTANTIATE end"
}
