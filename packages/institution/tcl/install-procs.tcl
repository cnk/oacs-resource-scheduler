ad_library {
    Personnel install procs

    Procedures that deal with installing, instantiating, mounting.
    
    @creation-date 2004-01-28
    @author nick@ucla.edu
}

namespace eval personnel::install {}
#set package_id [ad_conn package_id]


ad_proc -private personnel::install::package_mount {
    {-package_id:required}
    {-node_id:required}
} {
    Package installation callback proc
} {
#    patient_notes::create_exam_systems -package_id $package_id
#    patient_notes::create_ros -package_id $package_id
}

ad_proc -private personnel::install::package_uninstantiate {
    {-package_id:required}
} {
    Package un-instantiate callback proc
} {
   
    #first remove all the permissions associated with all the objects within this package
 #   patient_notes::install::remove_permissions -object_type "pn_daily_note"
 #   patient_notes::install::remove_permissions -object_type "pn_visit_record"
 #   patient_notes::install::remove_permissions -object_type "pn_patient_visit"
#    patient_notes::install::remove_permissions -object_type "pn_note_data_set"
    
#    db_dml delete_access_log "delete from pn_division_access_logs"
    
    #db_dml delete_notes "delete from pn_daily_notes"
    #db_dml delete_records "delete from pn_visit_records"
    #db_dml delete_visits "delete from pn_patient_visits"
    
 #   db_exec_plsql delete_data_sets {}
 #   db_exec_plsql delete_notes {}
 #   db_exec_plsql delete_records {}
 #   db_exec_plsql delete_visits {}


    #remove all the rels for this particular patient
  #  db_multirow remove_rels remove_rels {
  #  } {
#	relation_remove $rel_id
#    }
    
    #Remove all the patients from the the db
 #   db_multirow get_patient_ids get_patient_ids {
 #   } { 
#	db_exec_plsql delete_patient {}
#    }

    #remove all the team acs_rels and then delete the corresponding entry in groups
 #   db_multirow get_ids get_team_ids {
 #   } {
#	group::delete $team_id
#    }
    
    #remove all the division acs_rels then delete the corresponding entry in groups
 #   db_multirow get_ids get_div_ids {
 #   } {
#	group::delete $division_id
#    }
    
    #remove all the department acs_rels then delete the corresponding entry in groups
 #   db_multirow get_ids get_dep_ids {
 #   } {
#	group::delete $department_id
#    }

    #Delete all the categories relating to this package
 #   category::remove_all -package_id $package_id
}


ad_proc -private personnel::install::package_uninstall {
} {
    Package un-install callback proc
} {
       
}

ad_proc -private personnel::install::remove_permissions {
    {-object_type:required}
} {
    Remove all the permissions associated with the object_Type
} {
    
 #   db_multirow get_perm get_perm  {
 #   } {
#	permission::revoke -party_id $grantee_id -object_id $object_id -privilege $privilege
#    }
}

ad_proc -private personnel::install::after_install {
} {
} {
    # -----------------------------------------------------------------------------------------------------------------------------         
    # ROOT CATEGORY                                                                                         
    # -----------------------------------------------------------------------------------------------------------------------------          
    set root_id [category::new -parent_category_id "" \
		     -name "SPH" \
		     -plural "SPH" \
		     -description "SPH - School of Public Health" \
		     -enabled_p t \
		     -profiling_weight 1 \
		     -context_id ""]
    # -----------------------------------------------------------------------------------------------------------------------------         
    # END ROOT CATEGORY                                                                                         
    # -----------------------------------------------------------------------------------------------------------------------------          

    # -----------------------------------------------------------------------------------------------------------------------------         
    # RESEARCH AREAS CATEGORY                                                                                         
    # -----------------------------------------------------------------------------------------------------------------------------          
    category::new -parent_category_id $root_id \
	-name "Research Areas" \
	-plural "Research Areas" \
        -description "Research Areas" \
	-enabled_p t \
	-profiling_weight 1 \
	-context_id ""
    # -----------------------------------------------------------------------------------------------------------------------------         
    # END RESEARCH AREAS CATEGORY                                                                                         
    # -----------------------------------------------------------------------------------------------------------------------------          

    # -----------------------------------------------------------------------------------------------------------------------------         
    # METHODOLOGICAL CATEGORY                                                                                         
    # -----------------------------------------------------------------------------------------------------------------------------          
    category::new -parent_category_id $root_id \
	-name "Methodological Skills" \
	-plural "Methodological Skills" \
        -description "Methodological Skills" \
	-enabled_p t \
	-profiling_weight 1 \
	-context_id ""
    # -----------------------------------------------------------------------------------------------------------------------------         
    # END METHODOLOGICAL CATEGORY                                                                                         
    # -----------------------------------------------------------------------------------------------------------------------------          
}
