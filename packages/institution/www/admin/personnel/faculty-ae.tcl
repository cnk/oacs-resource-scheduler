# -*- tab-width: 4 -*-
# /packages/institution/www/personnel/faculty-ae.tcl
ad_page_contract {
	Add / Edit Faculty

	@author			nick@ucla.edu
	@creation-date	2004/03/24
	@cvs-id			$Id: faculty-ae.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

	@param			personnel_id
} {
	{personnel_id:integer,optional	}
	{faculty_id:integer,optional	}
	{return_url						[get_referrer]}
} -validate {
	personnel_or_faculty_id -requires {
			faculty_id:integer
			personnel_id:integer
		} {
			if {![info exists personnel_id] && ![info exists faculty_id]} {
				ad_complain "Either a personnel_id or faculty_id must be passed to this page."
			}
	}
}

if {[info exists personnel_id]} {
	set faculty_id $personnel_id
} else {
	set personnel_id $faculty_id
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

# checking permissions in here
if {[db_0or1row faculty_details {
		select	faculty_id,
				f_key
		  from	inst_faculty
		 where	faculty_id = :faculty_id
	}] != 0} {

	set page_action "Edit"

	# require 'write' to edit exisiting personnel
	permission::require_permission -object_id $personnel_id -privilege "write"
} else {
	set page_action "Add"

	# verify current personnel.
	if {![personnel::personnel_exists_p -personnel_id $personnel_id]} {
		ad_return_complaint 1 "Error" "There is no personnel with this Id."
		return
	}

	set f_key ""

	# require 'create' to create new personnel
	permission::require_permission -object_id $package_id -privilege "create"
}

set context [list "Faculty $page_action" "personnel/faculty-ae"]

set title "$page_action Faculty"
set personnel_error 0

ad_form -name faculty_ae -form {
	{faculty_id:integer(hidden)	{value $personnel_id}	}
	{f_key:integer,optional		{value $f_key}			}
	{submit:text(submit)		{label $page_action}	}
} -export {
	personnel_id
} -on_submit {
	# edit all currently displayed information
	set personnel_error 0
	db_transaction {
		if {[personnel::faculty_exists_p -personnel_id $personnel_id]} {
			db_dml faculty_edit {
				update	inst_faculty
				   set	f_key		= :f_key
				 where	faculty_id	= :faculty_id
			}
		} else {
			db_dml faculty_create {
				insert into inst_faculty (
						faculty_id,
						f_key
					) values (
						:faculty_id,
						:f_key
				)
			}
		}
	} on_error {
		set personnel_error 1
		db_abort_transaction
	}

	if {$personnel_error} {
		ad_return_error "Error" "FACULTY NOT UPDATED PROPERLY - $errmsg"
		return
	}
} -after_submit {
	if {![exists_and_not_null return_url]} {
		set return_url "detail?[export_vars {personnel_id}]"
	}
	template::forward $return_url
}

