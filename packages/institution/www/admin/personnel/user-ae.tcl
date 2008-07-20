ad_page_contract {
    @author    nick@ucla.edu
    @creation-date    2004/02/23
    @cvs-id    $Id: user-ae.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
    {personnel_id:integer,optional}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node::get_url_from_object_id -object_id [ad_conn subsite_id]] ; #_closest_ancestor_package_url]

set email ""
if {[exists_and_not_null personnel_id] && [personnel::personnel_exists_p -personnel_id $personnel_id]} {
    set new_user_p 0
    
    set person_check [db_0or1row person_exist {
	select first_names, last_name
	from persons
	where person_id = :personnel_id
    }]

    if {!$person_check} {
	set heading ""
	ad_return_error "Error" "The Personnel ID is invalid"
	return
    }


    set heading "Converting $first_names $last_name to a user."
    set button_title "Edit"
    #require 'write' to edit exisiting personnel
    permission::require_permission -object_id $package_id -privilege "admin"

    set email [db_string login_email_address {
	select	email
	from	inst_party_emails
	where	party_id	= :personnel_id
	and	email_type_id	= category.lookup('//Contact Information//Email//Email Address')
	and	rownum		= 1
    } -default ""]

} else {
    set new_user_p 1
    set heading "Adding New User."
    set first_names ""
    set last_name ""
    set button_title "Add"

    # require 'create' to create new personnel
    permission::require_permission -object_id $package_id -privilege "admin"
}

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
	[list [ad_conn package_url] "Faculty Editor"] \
	[list [set subsite_url]institution/personnel/ "Personnel Index"] \
	"User $button_title"]]

#set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node::get_url -node_id [ad_conn subsite_id]]

set title "User $button_title"
set user_error 0

set new_user_id ""

ad_form -name user_ae -html {enctype "multipart/form-data"} -form {
    personnel_id:key
    {first_names:text,optional                  {label "<font color=f40219>*</font> First Name"} {value $first_names}}
    {last_name:text,optional                    {label "<font color=f40219>*</font> Last Name"} {value $last_name}}
    {priv_email:text	            	        {label "<font color=f40219>*</font> Email"} {value $email}}
    {password:text(password)			{label "<font color=f40219>*</font> Enter your Password"}}
    {password_repeat:text(password)             {label "<font color=f40219>*</font> Password Confirmation"}}
    {submit:text(submit)                        {label "User $button_title"}}
} -on_submit {
    # verifying password
    if {[string compare $password $password_repeat] != 0} {
	ad_return_error "Error" "Your passwords do not match. Please back up and double check that they are exactly the same."
	ad_script_abort
    }
    
    # verifying email form
    if {![util_email_valid_p $priv_email]} {
	ad_return_error "Error" "The email does not seem to be of the correct form. Please back up and correct that."
	ad_script_abort
    }
} -new_data {
    #validating uniquness of employee number
    set unique_email [db_string get_id_count "select count(*) from parties where email = :priv_email"]
    if $unique_email {
	ad_return_error "Error" "The email/login entered is already taken"
	return
    }
    
    # user must also create a person
    if {$new_user_p} {
	set user_error 0
	db_transaction {
	    set new_user_id [personnel::user_add -priv_email $priv_email \
		    -first_names $first_names \
		    -last_name $last_name \
		    -password $password]
	} on_error {
	    set user_error 1
	    db_abort_transaction
	}
	if {$user_error} {
	    ad_return_error "Error" "NEW PERSON/USER NOT ADDED PROPERLY - $errmsg"
	    return
	}
    }

    #giving the new user admin permission on themselves.
    permission::grant -party_id $new_user_id -object_id $new_user_id -privilege "admin"

} -edit_data {
    set new_user_id $personnel_id
    set user_error 0

    set unique_email [db_string get_id_count "select count(*) from parties where email = :priv_email"]
    if $unique_email {
	ad_return_error "Error" "The email/login entered is already taken"
	return
    }
    
    db_transaction {
	personnel::personnel_to_user -personnel_id $personnel_id \
			-priv_email $priv_email \
			-first_names $first_names \
			-last_name $last_name \
			-password $password
    } on_error {
	set user_error 1
	db_abort_transaction
    }
    if {$user_error} {
	ad_return_error "Error" "USER NOT ADDED PROPERLY - $errmsg"
	return
    }

    #giving the new user admin permission on themselves.
    permission::grant -party_id $personnel_id -object_id $personnel_id -privilege "admin"
} -after_submit {
    set personnel_id $new_user_id
    if {!$new_user_p} {
	ad_returnredirect "../personnel/detail?[export_vars personnel_id]"
    } else {
	ad_returnredirect "../personnel/user-list"
    }
} -export {} -select_query {
    select 1 from dual
}
