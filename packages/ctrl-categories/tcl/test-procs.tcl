# -*- tab-width: 4 -*-
ad_library {
	ACS Automated testcases for the Categories

	@author Jeff Wang
	@cvs-id $Id: test-procs.tcl,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
	@creation-date 2003-12-04
}

aa_register_init_class aa_category_init {
	Make a new category
} {
	aa_export_vars [list aa_category_id aa_parent_category_id aa_name aa_description aa_enabled_p aa_profiling_weight]

	set aa_parent_category_id ""
	set aa_name "Cartoon Characters"
	set aa_description "A list of cartoon characters"
	set aa_enabled_p "t"
	set aa_profiling_weight 1

	set aa_category_id [ctrl::category::new -parent_category_id $aa_parent_category_id \
				-name $aa_name \
				-description $aa_description \
				-enabled_p $aa_enabled_p \
				-plural "blah" \
				-profiling_weight $aa_profiling_weight]

} {
	ctrl::category::remove -category_id $aa_category_id
}


aa_register_case -cats {
	db
	script
} -init_classes {
	aa_category_init
} "category-test-01" {
	test the category_remove and delete function
} {
	#get the newly created entry in the physicians table
	db_1row get_cat_info "select name, description, enabled_p, profiling_weight from categories where category_id=:aa_category_id"

	aa_equals "name equals"	 $name $aa_name
	aa_equals "description equals"	$description $aa_description
	aa_equals "enabled equals"	$enabled_p $aa_enabled_p
	aa_equals "profiling weight equals" $profiling_weight $aa_profiling_weight
}


aa_register_case -cats {
	db
	script
} -init_classes {
	aa_category_init
} "category-test-02" {
	test the category_edit
} {

	set edit_name "Something different"

	ctrl::category::edit -category_id $aa_category_id \
	-parent_category_id $aa_parent_category_id \
	-name $edit_name \
	-description $aa_description \
	-enabled_p $aa_enabled_p \
	-profiling_weight $aa_profiling_weight

	#get the newly created entry in the physicians table
	db_1row get_cat_info "select name, description, enabled_p, profiling_weight from categories where category_id=:aa_category_id"

	aa_equals "name equals"	 $name $edit_name
	aa_equals "description equals"	$description $aa_description
	aa_equals "enabled equals"	$enabled_p $aa_enabled_p
	aa_equals "profiling weight equals" $profiling_weight $aa_profiling_weight
}
