# /packages/ctrl-resources/www/manage/room-ae.tcl

ad_page_contract {

    Add / Edit Room

    @author H, Khy
    @creation-date 2005-12-13
    @cvs-id $Id$

    @param room_id primary key
} {
    room_id:naturalnum,optional
} 

set user_id [ad_conn user_id]

set package_id [ad_conn package_id]
set context_id $package_id

if ![info exists subsite_id] {
   set subsite_id [ad_conn subsite_id]
}

# --------------
# Initialize the list option list for selects and radios    
# ---------------
set approval_required_p__options [list {Yes t} {No f}]
set address_id__options [list {{**COMPLETE ME**} ""}]
set department_id__options [list {{**COMPLETE ME**} ""}]

set path1 "//Room Types"
set resource_category_id__options [crs::ctrl::category::option_list -path $path1 -package_id $package_id]
set resource_list [concat [list [list {Select One ...} ""]] $resource_category_id__options]

set address_id__options [crs::resource::get_ctrl_addresses]
set address_list [concat [list [list {Select One ...} ""]] $address_id__options]

set path3 "//Departments"
set department_id__options [crs::ctrl::category::option_list -path $path3 -package_id $package_id]
set department_list [concat [list [list {Select One ...} ""]] $department_id__options]

set enabled_p__options [list {Yes t} {No f}]
set reservable_p__options [list {Yes t} {No f}]

# --------------
# Define the form
# --------------
ad_form -name form_ae -form {
    {room_id:key {label room_id_label}} 
    {name:text(text) {label {name}} {html {size 50 maxlength 1000}}} 
    {description:text(textarea),optional {label {description}} {html {rows 4 cols 50}}} 
    {resource_category_id:naturalnum(select),optional {label {Resource Type}} {options $resource_list}} 
    {enabled_p:text(radio) {label {Enabled?}} {options $enabled_p__options}} 
    {services:text(text),optional {label {services}} {html {size 50 maxlength 4000}}} 
    {property_tag:text(text),optional {label {Property Tag}} {html {size 50 maxlength 1000}}} 
    {how_to_reserve:text(text),optional {label {How To Reserve}} {html {size 50 maxlength 4000}}}
    {approval_required_p:text(radio) {label {Is Approval Required}} {options $approval_required_p__options}} 
    {address_id:naturalnum(select),optional {label {Address}} {options $address_list}} 
    {department_id:naturalnum(select),optional {label {Department}} {options $department_list}} 
    {room:text(text) {label {room} {html {size 50 maxlength 100}}}}
    {floor:text(text) {label {floor}} {html {size 5 maxlength 100}}} 
    {capacity:integer(text),optional {label {capacity}} {html {size 5 maxlength 22}}} 
    {dimensions_width:integer(text),optional {label {width}} {html {size 5 maxlength 22}}} 
    {dimensions_length:integer(text),optional {label {length}} {html {size 5 maxlength 22}}} 
    {dimensions_height:integer(text),optional {label {height}} {html {size 5 maxlength 22}}} 
    {dimensions_unit:text(text),optional {label {unit }} {html {size 5 maxlength 22}}}
    {color:text(text),optional {label {color}} {html {size 6 maxlength 6}}}
    {reservable_p:text(radio) {label {Allow Reservation}} {options $reservable_p__options} {html {onClick "displayResvNote();"}}}
    {reservable_p_note:text(text),optional {label Note} {html {size 50 maxlength 300}}}
    {special_request_p:text(radio) {label {Special Request Only}} {options $reservable_p__options}}
    {new_email_notify_list:text(text),optional {label {New Notify Email}} {html {size 50 maxlength 4000}}}
    {update_email_notify_list:text(text),optional {label {Update Notify Email}} {html {size 50 maxlength 4000}}}
    {note_display:text(hidden)}
    {submit_button:text(submit) }
} -validate {
    {new_email_notify_list
        {[empty_string_p $new_email_notify_list] || [util_email_valid_p_v2 [string trim $new_email_notify_list]]}
        "<li>The email address that you typed doesn't look right to us.  Examples of valid email addresses are:                             
         <ul>                                                                                                                               
         <li>Alice1234@aol.com            
         <li>joe_smith@hp.com                                                                 
         <li>pierre@inria.fr     
         </ul>"
    }
    {update_email_notify_list
        {[empty_string_p $update_email_notify_list] || [util_email_valid_p_v2 [string trim $update_email_notify_list]]}
        "<li>The email address that you typed doesn't look right to us.  Examples of valid email addresses are:                             
         <ul>                                                                                                                               
         <li>Alice1234@aol.com            
         <li>joe_smith@hp.com
         <li>pierre@inria.fr     
         </ul>"
    }
    {reservable_p_note
	{(![empty_string_p $reservable_p_note] && !$reservable_p) || $reservable_p}
        "This is a required field."
    }
} -new_request {
    
# --------------------------------------------------------
# Place code here to populate form variables if adding a new
# record in a single column primary key table
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $context_id -privilege create
    #Set the initial values for allow reservation, by default
    #doing reservations is allowed.
    set reservable_p t
    set special_request_p f
    set note_display "none"
    set reservable_p_note "To make a reservation for this room please contact <a href=\"mailto:nlin@cnsi.ucla.edu\">Nikki Lin</a>"
} -edit_request {
# --------------------------------------------------------
# Place code here to populate form variables if editing a
# record in a single column primary key table
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $room_id -privilege write
    
    crs::room::get -room_id $room_id -column_array room_info

    set form_var_list [list name description resource_category_id enabled_p services property_tag how_to_reserve \
			  approval_required_p address_id department_id floor room capacity dimensions_width \
			  dimensions_height dimensions_length dimensions_unit new_email_notify_list update_email_notify_list \
                          color reservable_p reservable_p_note special_request_p]

    foreach var $form_var_list {
	set $var [set room_info($var)]
    }

    #If reservations is allowed dont show the reservable_p_note, 
    #otherwise show it.
    if { $room_info(reservable_p) } {
       set note_display "none"
    } else {
       set note_display "inline"
    }

    if {[empty_string_p $reservable_p_note]} {
       set reservable_p_note "To make a reservation for this room please contact <a href=\"mailto:nlin@cnsi.ucla.edu\">Nikki Lin</a>"
    }

} -on_submit {
    # --------------------------------------------------------
    # Place code here to
    # 1. Work with tables that have composite keys 
    # 2. Massage data before processing occurrs in the -new_data or edit_data section
    # 3. validate form elements and throw validations errors
    # (i.e. template::form::set_error add_edit_form form_widget "widget error unable to process"
    #	break test
    # )
    # ---------------------------------------------------------
    set failed_p 0
    if { !$reservable_p } { set note_diplay "inline"}
    #Clear the note is reservation is allowed.
    if { $reservable_p } { set reservable_p_note "" }
} -new_data {
    # --------------------------------------------------------
    # Place code here to to add a record in a table with non-composite primary key
    # ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $context_id -privilege create

    db_transaction {
	set room_id [crs::room::new -name $name -resource_category_id $resource_category_id \
			 -description $description -enabled_p $enabled_p -services $services -property_tag $property_tag \
			 -how_to_reserve $how_to_reserve -approval_required_p $approval_required_p \
			 -address_id $address_id -department_id $department_id -floor $floor -room $room \
			 -capacity $capacity -dimensions_width $dimensions_width -dimensions_length $dimensions_length \
			 -context_id $package_id \
			 -dimensions_height $dimensions_height -dimensions_unit $dimensions_unit \
			 -new_email_notify_list $new_email_notify_list -update_email_notify_list $update_email_notify_list \
			 -color $color \
                         -reservable_p $reservable_p \
                         -reservable_p_note "$reservable_p_note" \
                         -special_request_p $special_request_p] 
        
        crs::resource::rel_add -subsite_id $subsite_id -object_id $room_id

	permission::grant -party_id $user_id -object_id $room_id -privilege admin	

	# create corresponding calendar
	set var_list [list\
			  [list cal_name $name]\
			  [list description "Calendar for $name"]\
			  [list owner_id [ad_conn user_id]] \
			  [list context_id $room_id] \
			  [list object_id $room_id]]
	ctrl::cal::new -var_list $var_list
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	ad_return_error "System failed to update resource" "A system error ocurred while attempting to add new room. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }

} -edit_data {
    # --------------------------------------------------------
    # Place code here to edit a record in a table with non-composite primary key
    # ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $room_id -privilege write
    
    db_transaction {
	crs::room::update -room_id $room_id -name $name -resource_category_id $resource_category_id \
			 -description $description -enabled_p $enabled_p -services $services -property_tag $property_tag \
			 -how_to_reserve $how_to_reserve -approval_required_p $approval_required_p \
			 -address_id $address_id -department_id $department_id -floor $floor -room $room \
			 -capacity $capacity -dimensions_width $dimensions_width -dimensions_length $dimensions_length \
			 -dimensions_height $dimensions_height -dimensions_unit $dimensions_unit \
	                 -new_email_notify_list $new_email_notify_list -update_email_notify_list $update_email_notify_list \
		         -color $color \
                         -reservable_p $reservable_p \
                         -reservable_p_note "$reservable_p_note" \
                         -special_request_p $special_request_p
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	ad_return_error "System failed to update resource" "A system error ocurred while attempting to edit the room. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }
} -after_submit {
    # --------------------------------------------------------
    # Most common case is to have code that redirects to appropriate page
    # ---------------------------------------------------------
    ad_returnredirect [export_vars -base room room_id]
}  

if [ad_form_new_p -key room_id] {
    set page_title "Add a Room"
    set context [list [list index Administration] $page_title]
    set submit_btn "Add Room"
} else {
    set page_title "Edit a Room"
    set context [list [list index Administration] [list [export_vars -base room room_id] "Room Detail"] \
		     "Edit"]
    set submit_btn "Edit Room"
}   

set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title -manage_p 1]
#This is used in the display attribute on the reservation_p_note on the adp.
set note_display_val [template::element::get_value form_ae note_display]
ad_return_template 
  

