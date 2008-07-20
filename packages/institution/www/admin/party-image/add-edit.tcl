# -*- tab-width: 4 -*-
# /packages/party-image/www/add-edit.tcl
ad_page_contract {
	Interface for creating new and editting existing party_images.  When creating a
	party_image, <code>image_id</code> must not be passed.

	@param			image_id	(optional) the id of the party_image you wish to edit
	@param			party_id	(optional) the id of the party you wish to create a party_image for

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/05/18
	@cvs-id			$Id: add-edit.tcl,v 1.2 2007/02/21 20:25:40 andy Exp $
} {
	{image_id:naturalnum,optional}
	{party_id:naturalnum,optional}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"an"			;# Note this is placed next to 'object_type'
set object_type_key		"party-image"
set object_type			"Image"
set object_type_pl		"Images"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_url			[site_node_closest_ancestor_package_url]

set reqd			{<b style="color: red">*</b>}

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null image_id]} {
	if {![exists_and_not_null party_id] &&
		[db_0or1row get_party_id {
			select	party_id
			  from	inst_party_images
			 where	image_id = :image_id
		}] != 1} {
		ad_return_complaint 1 "The $object_type you requested does not exist."
		return
	}
	set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $image_id -privilege "delete"]} {
		set party_image_delete_url	"delete?[export_vars {image_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $image_id -privilege "admin"]} {
		set subsite_url				[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set party_image_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $image_id}}]"
	}

	# This will be set if the page was submitted from an 'add' but did not pass
	#	validation and hence came back _with_ and image_id but no row in the
	#	table yet.
	if {[ns_queryget __new_p 0] == 0} {
		set image_view_url			"[ad_conn package_url]party-image-view?[export_vars {image_id}]"
		set image_view_html			"<img src=\"$image_view_url\"/><br>"
	} else {
		set image_view_url			""
		set image_view_html			""
	}

	set action					"Edit"
	set	user_execute_action		"Save Changes"
	set reqd_for_add			""
	set reqd_for_edit			$reqd
	set can_delete_or_permit_p	[expr [exists_and_not_null party_image_delete_url] || [exists_and_not_null party_image_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.  In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action				[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action			"to $old_action $indefinite_article $object_type"
	}
	set title					"$action Your Request $old_action"
} elseif {[exists_and_not_null party_id]} {
	# make sure the id corresponds to party (and not simply a person)
	set party_p [db_string party_p {
		select 1
		  from parties
		 where party_id = :party_id
	} -default 0]

	if {!$party_p} {
		ad_return_complaint 1 {
			You attempted to supply a non-party as an input to this form.
			Only parties may have party_images.
		}
		ad_script_abort
	}

	# check for permission to create a party_image for this party
	permission::require_permission -object_id $party_id -privilege "create"

	set image_view_url			""
	set image_view_html			""
	set action					"Add"
	set	user_execute_action		"Save"
	set reqd_for_add			$reqd
	set reqd_for_edit			""
	set can_delete_or_permit_p	0
} else {
	ad_return_complaint 1 {
		You must supply a valid party_image when attempting to edit a party_image.
		Alternatively, you may indicate a party for which you wish to create
		a party_image.
	}
	ad_script_abort
}

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
	append user_execute_action	" & Return to Step $step"
}

set context			[list [list "../$object_type_key/" $object_type_pl] $action]

# BUILD FORM ###################################################################
set party_image_types			[db_list_of_lists party_image_types {}]
set party_image_type_cat_id		[category::find -path "//Image"]
if {[permission::permission_p -object_id "$party_image_type_cat_id" -privilege "admin"]} {
	set party_image_type_create_url	"/categories/add-edit?[export_vars -override {{parent_category_id $party_image_type_cat_id}}]"
	set party_image_type_create_html "
		<small>
			<a	title=\"Click here to create a new Image Type.\"
				href=\"$party_image_type_create_url\">(Create a new Image Type)
			</a>
		</small>
	"
} else {set party_image_type_create_html ""}

ad_form -name add_edit -export {action return_url step} -html {
	enctype "multipart/form-data"
} -form {
	{image_id:key													}
	{party_id:integer(hidden)										}
	{image_file:text(file),optional		{label "Image:$reqd_for_add"}	{before_html $image_view_html}}
	{description:text					{label "NAME:$reqd"}		}
	{image_type_id:integer(select)		{label "Type:$reqd"}		{options {$party_image_types}}
		{after_html "$party_image_type_create_html"}
	}
	{submit:text(submit)				{label $user_execute_action}}
	{required:text(inform)				{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
} -select_query_name "party_image" \
  -validate {
} -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above.
	# When the data is submitted using the 'Add' form, it returns to this page
	# as an 'Edit' before the insert is performed and the user is finally
	# returned to where they linked here from initially.
	if {$action == "Edit"} {
		permission::require_permission -object_id $image_id -privilege "write"
		db_1row party_image {}
		if {$user_id == $party_id} {
			set title		"$action Your $object_type \"$description\""
		} else {
			set title		"$action the $object_type \"$description\" owned by \"$owner_name\""
		}
	} else {
		# The user requested an 'Add' page
		# setup some default values

		# this goes in the page title
		set owner_name [db_string party_name {select acs_object.name(:party_id) from dual}]
		if {$user_id == $party_id} {
			set title		"$action a $object_type For Yourself"
		} else {
			set title		"$action a $object_type owned by \"$owner_name\""
		}
	}

	set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]
} -on_submit {
	if {[exists_and_not_null image_file]} {
		set extension		[string tolower [file extension $image_file]]
		regsub "\." $extension "" extension
		set format			[ns_guesstype $image_file]
		set image_file		[ns_queryget image_file.tmpfile]
		set file_bytes		[file size $image_file]

		# get the dimensions if they exist
		if {$extension == "jpeg" || $extension == "jpg" } {
			catch { set dimensions [ns_jpegsize $image_file] }
		} elseif {$extension == "gif"} {
			catch { set dimensions [ns_gifsize $image_file] }
		}

		if {[exists_and_not_null dimensions]} {
			set width [lindex $dimensions 0]
			set height [lindex $dimensions 1]
		} else {
			set width ""
			set height ""
		}
	}
} -new_data {
	# When an image is created, it must be uploaded.  This is left out of the
	# -edit_date section so that you can change the name of an image without
	# having to upload it all over again.
	if {![exists_and_not_null image_file]} {
		ad_return_complaint 1 "You must submit an image."
		return
	}

	db_transaction {
		# create a new party_image
		set image_id [db_exec_plsql party_image_new {}]

		# update the image
		if {[exists_and_not_null image_file]} {
			db_dml party_image_update_blob {} -blob_files [list $image_file]
		}
	}
} -edit_data {
	permission::require_permission -object_id $image_id -privilege "write"

	db_transaction {
		db_dml party_image_edit {}

		# update the image
		if {[exists_and_not_null image_file]} {
			db_dml party_image_update_blob {} -blob_files [list $image_file]
		}

		db_dml modified {}
	}
} -after_submit {
	template::forward $return_url
}
