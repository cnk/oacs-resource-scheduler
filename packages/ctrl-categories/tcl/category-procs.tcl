# -*- tab-width: 4 -*-
ad_library {
	Category Procs
}

namespace eval ctrl::category {}

ad_proc -public ctrl::category::new {
	{-parent_category_id	""}
	{-name:required}
	{-plural				"$name"}
	{-description			""}
	{-enabled_p				"t"}
	{-profiling_weight		1}
	{-context_id			"[ad_conn package_id]"}
} {
	Adds a new category to the database
} {
	set context_id [subst $context_id]
	set error_p 0
	db_transaction {
		# CHECK IF CATEGORY ALREADY EXISTS
		if {[empty_string_p [string trim $parent_category_id]]} {
			set parent_category_constraint " and parent_category_id is null "
		} else {
			set parent_category_constraint " and parent_category_id = :parent_category_id "
		}

		set category_id [db_string category_exists_p {} -default 0]

		if {!$category_id} {
			set category_id [db_exec_plsql new_category {}]			
		}
	} on_error {
		set error_p 1
		db_abort_transaction
	}

	if {$error_p} {
		return 0
	}

	return $category_id
}

ad_proc -public ctrl::category::edit {
	{-category_id:required}
	{-parent_category_id:required}
	{-name:required}
	{-description:required}
	{-enabled_p:required}
	{-profiling_weight:required}
} {
	Edit a category in the database
} {
	db_transaction {
		db_dml category_edit {}
	}
}

ad_proc -public ctrl::category::remove {
	{-category_id:required}
} {
	Removes a category along with all it's children
} {
	db_transaction {
		db_exec_plsql delete_category {}
	}
}

ad_proc -public ctrl::category::subcategories_list {
	{-category_id:required}
} {
	<p>Get a list of all the sub-categories of a given category.</p>

	@return	subcategories
	@author	helsleya@cs.ucr.edu
} {
	return [db_list direct_subcategories_of {}]
}

ad_proc -public ctrl::category::name_from_id {
	{-category_id:required}
} {
	<p>Get the name of a category from its category_id.</p>

	@return	category_name
	@author	helsleya@cs.ucr.edu
} {
	return [db_string name {}]
}

ad_proc -public ctrl::category::find {
	{-path:required}
} {
	<p>Find a category given a <q>path</q> to the category.  This
	behavior is much like inverse of <code>name_from_id</code>
	in that, given a <q>name</q> (the <q>path</q>), it will return
	the corresponding ID.</p>

	<p><code><pre>Example:
		//Certification Type//Education//Medical Degree//MD
	</pre></code>
	</p>

	<p>This function can create categories along the way if they don't exist.
	In such a case, <code>description</code>, <code>enabled_p</code> and
	<code>profiling_weight</code> will only be set for the last category
	created.  All of the other created categories will have the defaults
	for those attributes.  The <code>plural</code> attributes for the other
	categories will be set to the name, and will probably need updates to
	correct this.</p>

	@return	category_id
	@author	helsleya@cs.ucr.edu
} {
	set path "//[join $path //]"
	return [db_string lookup {}]
}

ad_proc -public ctrl::category::option_list {
	{-path:required}
	{-top_label}
	{-top_value}
	{-disable_spacing 0}
	{-level_limit ""}
	{-constraint ""}
} {
	Return an optionlist of all categories underneath the path given

	<p><code><pre>Example:
		//Certification Type//Education//Medical Degree//MD
	</pre></code>
	</p>

	@return optionlist of all subcategories (recursive)
	@author avni@ctrl.ucla.edu (AK)
	@creation-date 10/25/2005
} {
	set query_constraint " where 1=1 "

	if {![empty_string_p $constraint]} {
		append query_constraint " $constraint"
	}

	if {![empty_string_p $level_limit]} {
		append query_constraint " and level <= :level_limit "
	} 

	set spacing_statement ""
        switch $disable_spacing {
	   0 { set spacing_statement "lpad(' ', (level-1)*4*6 + 1,  '&nbsp;') || " }
	   2 { set spacing_statement "lpad(' ', (level),' ') || " }
        }

	if {[info exists top_label] && [info exists top_value]} {
		set return_list [db_list_of_lists get_subcategories {}] 
		set return_list [linsert $return_list 0 [list $top_label $top_value]]
		return $return_list
	} else {
		 return [db_list_of_lists get_subcategories {}]
	}
}

ad_proc -public ctrl::category::option_id_list {
        {-path:required}
        {-top_value}
} {
        Return an option ID list of all categories underneath the path given

        <p><code><pre>Example:
                //Certification Type//Education//Medical Degree//MD
        </pre></code>
        </p>

        @return optionlist of all subcategories (recursive)
        @author shhong@mednet.ucla.edu (SH)
        @creation-date 03/07/2006
} {
   set result ""
   db_foreach get_subcategories "" {
      lappend result $category_id
   }
   if {[info exists top_value]} {
      set result [linsert $result 0 $top_value]
   }
   return $result
}

ad_proc -public ctrl::category::before_uninstantiate {
	{-package_id:required}
} {
	Removes data belonging to an instance of ctrl::categories from the database.
	
	@param	package_id	The ID of that ctrl::categories instance to remove.
	
	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-05-09 15:28 PDT
} {
	db_transaction {
		db_exec_plsql remove_package_categories {}
	}
}
