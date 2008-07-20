#############################
#
#  Use this script to generate tcl libraries
#
#  @date 4/20/2005
#  @author jeff@ctrl
#############################


##backup old files?
set backup_p 1

#####Editable Params that are used in all the procs
set file_path "/web/acs46-dev/packages/ctrl-procs/tcl/test-procs"
set namespace "concierge::audit"
set table_name "cncrg_report_audit"

##### Which procs do you want to generate?


#######
#Params for generating a get proc
#######
set generate_get 1
set get_complete_proc_name "${namespace}::get"
set get_cols_to_select [list "name" [list "start_date" "to_char(:start_date, 'mm-dd-yyyy')"] ]
set get_id_name "audit_id"
set get_where_clause "audit_id=:audit_id"
set get_overwrite_p 1 

#######
#Params for generating an insert/new
#######
set generate_insert 1
set insert_complete_proc_name "${namespace}::insert"
#the name of the sequence used for the primary key, empty string if none.
set insert_key_sequence_name  "cncrg_audit_seq"
#the name of the primary key column on this table, empty string if none exists.
set primary_key_col_name "audit_it"
set insert_return_error_msg "There was a problem inserting the audit information."

# The following parameter specifies the arguments and default values for the procedure. It should
# be a list of sub-lists where each sub-list is the column_name, followed by the default value.
# There are 4 special types of default values:
#  (1) user_id - the default value for the parameter will be the user_id
#  (2) sysdate - the default value for the param will be the sysdate
#  (3) sequence - the default value will be the nextval of the sequence specified by insert_key_sequence_name (above)
#  (4) none - There is no default value
set insert_values [list \
	[list "audit_id" "sequence"] \
	[list "published_by" "user_id"] \
	[list "publish_date" "sysdate"] \
	[list "start_date" "to_date"] \
	[list "patient_id" "none"] ]



set generate_new    0
set new_complete_proc_name "${namespace}::new"
set new_return_error_msg ""
set new_overwrite_p 1

#######
#Params for generating a delete/remove
#######
set generate_delete 1
set delete_complete_proc_name "${namespace}::delete"
set delete_id_name "audit_id"
set delete_where_clause "audit_id=:audit_id"
set delete_error_msg ""
set delete_overwrite_p 1

set generate_remove 1
set remove_complete_proc_name "${namespace}::remove"
set remove_package_function "cncrg_patient.del"
set remove_id_name "patient_id"
set remove_error_msg ""
set remove_overwrite_p 1

#######
#Params for generating an update
#######
set generate_update 1
set update_complete_proc_name "${namespace}::update"
set update_return_err_msg "There was a problem updating the audit table."
set update_column_names [list "publish_by" "send_date" [list "publish_date" "to_date"] "patient_id"]
set update_where_clause "apt_id=:apt_id"
set update_primary_key_name "apt_id"
#is this an acs_object?
set update_object_p 1
set update_overwrite_p 1

############ 
# Calls to the generation procs. You probably don't want to edit anything below this.
#############
set return_msg ""
if {$backup_p} {
    set error_p [catch { ctrl_procs::prototype::backup \
	    -file_path $file_path} result]
}


if {$generate_get} {
    #generate a get
    set error_p  [catch {ctrl_procs::prototype::generate_get \
	    -file_path $file_path \
	    -complete_proc_name $get_complete_proc_name  \
	    -table $table_name \
	    -cols_to_select $get_cols_to_select \
	    -id_name $get_id_name \
	    -where_clause $get_where_clause \
	    -overwrite_p $get_overwrite_p} result]
    
    if {$error_p} {
	append return_msg "Problem generating $get_complete_proc_name -- $result <br>"
    } else {
	append return_msg "<b> $get_complete_proc_name </b> generated in  <i>$file_path</i>  <br>"
    }
}

if {$generate_delete} {
    #generate a delete
     set error_p  [catch {ctrl_procs::prototype::generate_delete \
	    -file_path $file_path \
	    -complete_proc_name $delete_complete_proc_name  \
	    -table $table_name \
	    -id_name $delete_id_name  \
	    -where_clause $delete_where_clause \
	    -return_error_msg $delete_error_msg \
	    -overwrite_p $delete_overwrite_p} result]
    
    if {$error_p} {
	append return_msg "Problem generating $delete_complete_proc_name -- $result <br>"
    } else {
	append return_msg "<b> $delete_complete_proc_name </b> generated in  <i>$file_path</i>  <br>"
    }
}

if {$generate_insert} {
    #generate an insert
     set error_p [catch {ctrl_procs::prototype::generate_insert \
	    -file_path $file_path \
	    -complete_proc_name $insert_complete_proc_name \
	    -table $table_name \
	    -key_sequence_name $insert_key_sequence_name \
	    -primary_key_col_name $primary_key_col_name \
	    -return_error_msg  $insert_return_error_msg \
	    -values $insert_values \
	    -overwrite_p 1} result]

    if {$error_p} {
	append return_msg "Problem generating $insert_complete_proc_name -- $result <br>"
    } else {
	append return_msg "<b> $insert_complete_proc_name </b> generated in  <i>$file_path</i>  <br>"
    }
    
}

if {$generate_update } {
    #generate an update
    ctrl_procs::prototype::generate_update \
	    -file_path $file_path \
	    -complete_proc_name $update_complete_proc_name \
	    -table $table_name \
	    -return_error_msg $update_return_err_msg \
	    -values $update_column_names \
	    -where_clause $update_where_clause \
	    -id_name $update_primary_key_name \
	    -object_p $update_object_p \
	    -overwrite_p $update_overwrite_p 

    if {$error_p} {
	append return_msg "Problem generating $update_complete_proc_name -- $result <br>"
    } else {
	append return_msg "<b> $update_complete_proc_name </b> generated in  <i>$file_path</i>  <br>"
    }
}

if {$generate_remove} {
    #generate an remove
    set error_p [catch {ctrl_procs::prototype::generate_remove \
	    -file_path $file_path \
	    -package_function $remove_package_function \
	    -complete_proc_name $remove_complete_proc_name  \
	    -id_name $remove_id_name \
	    -return_error_msg $remove_error_msg \
	    -overwrite_p $remove_overwrite_p} result]


    if {$error_p} {
	append return_msg "Problem generating $remove_complete_proc_name -- $result <br>"
    } else {
	append return_msg "<b> $remove_complete_proc_name </b> generated in  <i>$file_path</i>  <br>"
    }
}

if {$generate_new} {
    #generate a new function
    set error_p [catch {ctrl_procs::prototype::generate_new \
	    -file_path $file_path \
	    -complete_proc_name $new_complete_proc_name \
	    -return_error_msg $new_return_error_msg \
	    -overwrite_p $new_overwrite_p  } result]
    
    if {$error_p} {
	append return_msg "Problem generating $new_complete_proc_name -- $result <br>"
    } else {
	append return_msg "<b> $new_complete_proc_name </b> generated in  <i>$file_path</i>  <br>"
    }
}
