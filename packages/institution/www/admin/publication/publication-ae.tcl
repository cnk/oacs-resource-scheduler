# -*- tab-width: 4 -*-
ad_page_contract {
	@author			nick@ucla.edu
	@creation-date	2004/02/01
	@cvs-id			$Id: publication-ae.tcl,v 1.2 2007/01/26 02:02:30 andy Exp $
} {
	{publication_id:integer,optional}
	{personnel_id:integer		    ""}
	{return_url						[get_referrer]}
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

if {[exists_and_not_null publication_id] &&
	[publication::publication_exist -publication_id $publication_id]} {

	set button_title "Edit"

	#require 'write' to edit exisiting publication
	permission::require_permission -object_id $publication_id -privilege "write"

	if {[db_string publication_metadata {
		select	1
		  from	inst_publications
		 where	publication_id = :publication_id
		   and	dbms_lob.getlength(publication) > 0
		   and	publication_type is not null
		} -default 0] < 1} {

		set pub_exist "No Publication Has Been Uploaded"
	} else {
		set pub_exist "A Publication Has Been Uploaded"
	}
} else {
	set button_title "Add"

	# require 'create' to create new publications
	if {[exists_and_not_null personnel_id]} {
		if {[db_string personnel_exists_p {
				select	1
				  from	inst_personnel
				 where	personnel_id = :personnel_id
			} -default 0]} {
			permission::require_permission -object_id $personnel_id -privilege "create"
		} else {
			ad_return_complaint 1 "The person you are trying to create a publication for does not exist."
			return
		}
	} else {
		permission::require_permission -object_id $package_id -privilege "create"
	}
	set pub_exist "No Publication Has Been Uploaded"
}


set page_title "$button_title Publication"

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/publication/ "Publication Index"] "Publication $button_title"]]

set publication_error 0

ad_form -name publication_ae -html {enctype "multipart/form-data"} -form {
	publication_id:key
	{title:text							{label "<font color=f40219>*</font> Title"} {html {size 52}}}
	{publication_name:text,optional		{label "Publication Name"} {html {size 52}}}
	{url:text,optional					{label "URL"} {html {size 52}}}
	{authors:text(textarea),optional	{label "Authors"} {html {rows 10 cols 50}}}
	{volume:text,optional				{label "Volume"} {html {size 52}}}
	{issue:text,optional				{label "Issue"} {html {size 52}}}
	{page_ranges:text,optional			{label "Page Range(s)"} {html {size 52}}}
	{year:integer,optional				{label "Year"} {html {size 52}}}
	{publish_date:date,optional			{label "Publish Date"}	{format "Mon DD YYYY"}}
	{publisher:text,optional			{label "Publisher"} {html {size 52}}}
	{publication:text(file),optional	{label "Publication"}}
	{priority_number:integer,optional	{label "Priority"}}
	{pub_current:text(inform)			{label "Current Publication"} {html {size 52}} {value $pub_exist}}
	{submit:text(submit)				{label $button_title}}
} -on_submit {
	# formating all dates so they can be inserted
	if {![empty_string_p $publish_date]} {
		set publish_date "[lindex $publish_date 0]-[lindex $publish_date 1]-[lindex $publish_date 2]"
	} else {
		set publish_date ""
	}
} -new_data {
	if {[exists_and_not_null personnel_id] &&
		[db_string personnel_exists_p {
			select	1
			  from	inst_personnel
			 where	personnel_id = :personnel_id
		} -default 0]} {
		set context_id		$personnel_id
	} else {
		set context_id		$package_id
	}
	set publication_id [publication::publication_add				\
							-title				"$title"			\
							-publication_name	"$publication_name"	\
							-url				"$url"				\
							-authors			"$authors"			\
							-volume				"$volume"			\
							-issue				"$issue"			\
							-page_ranges		"$page_ranges"		\
							-year				"$year"				\
							-publisher			"$publisher"		\
							-publish_date		"$publish_date"		\
							-publication		"$publication"		\
							-priority_number	"$priority_number"	\
							-personnel_id		"$personnel_id"		\
							-context_id			"$context_id"]
} -on_request {
	# When the user submits values for an 'Add' that don't this section will be
	#	called with a value for publication_id which doesn't correspond to an
	#	object in the database yet.  To produce a useful error messagem it's
	#	important not to return the complaint below.
	if {![exists_and_not_null __new_p]
		&& [exists_and_not_null publication_id]
		&& ![publication::publication_exist -publication_id $publication_id]} {
		ad_return_complaint "Error" "The publication you selected does not exist in our database."
		ad_script_abort
		return
	}
} -edit_data {
	publication::publication_edit -publication_id "$publication_id"	\
		-title				"$title"								\
		-publication_name	"$publication_name"						\
		-url				"$url"									\
		-authors			"$authors"								\
		-volume				"$volume"								\
		-issue				"$issue"								\
		-page_ranges		"$page_ranges"							\
		-year				"$year"									\
		-publisher			"$publisher"							\
		-publish_date		"$publish_date"							\
		-publication		"$publication"							\
		-priority_number	"$priority_number"
} -select_query {
	select	title,
			publication_name,
			url,
			authors,
			volume,
			issue,
			page_ranges,
			year,
			to_char(publish_date, 'YYYY MM DD') as publish_date,
			priority_number
	  from	inst_publications
	 where	publication_id = :publication_id
} -after_submit {
	if {[exists_and_not_null return_url]} {
		template::forward $return_url
	} elseif {[empty_string_p $personnel_id]} {
		template::forward [export_vars -base "[ad_conn package_url]admin/publication/detail" {publication_id return_url}]
	} else {
		template::forward [export_vars -base "[ad_conn package_url]admin/personnel/detail" {personnel_id}]
	}
} -export {personnel_id return_url}

#Query to select departments once they are available
#AH: changed this query to use the proper lookup PL/SQL function
#select group_id, short_name from inst_groups where group_type_id = category.lookup('//Group Type//Department')
