# -*- tab-width: 4 -*-
#ad_page_contract {
#	Return a single image.
#
#	@author				helsleya@cs.ucr.edu (AH)
#	@creation-date		2004-05-18
#	@cvs-id				$Id: view-template.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
#
#	@param	image_id	image to retrieve
#	@param	height
#	@param	width
#	@param	max_height
#	@param	max_width
#	@param	border
#
#} {
#	{image_id:integer,optional}
#	{party_id:integer,optional}
#	{description:optional}
#}

# get dimensions from DB

# get reference to the location of party-image templates in the current subsite
set parent_url "[ad_conn package_url]party-image/"

set selection [db_0or1row image_metadata {
	select	width  as actual_width,
			height as actual_height
	  from	inst_party_images
	 where	image_id = :image_id
}]

# if there was a image, use it
if {![empty_string_p $actual_width] && ![empty_string_p $actual_height]} {
	# make sure we have width and height
	if {![exists_and_not_null width] && [exists_and_not_null actual_width]} {
		set width $actual_width
	}


	if {![exists_and_not_null height] && [exists_and_not_null actual_height]} {
		set height $actual_height
	}

	# Scale image according to maximum sizes
	if {[exists_and_not_null max_width] && ($width > $max_width)} {
		set height [expr ($height * $max_width) / $width]
		set width $max_width
	}

	if {[exists_and_not_null max_height] && ($height > $max_height)} {
		set width [expr ($width * $max_height) /  $height]
		set height $max_height
	}

	# format HTML attributes for inclusion in the page
	if {[exists_and_not_null width]} {
		set width " width=\"$width\""
	} else {
		set width ""
	}

	if {[exists_and_not_null height]} {
		set height " height=\"$height\""
	} else {
		set height ""
	}

	if {[exists_and_not_null border]} {
		set border " border=\"$border\""
	} else {
		set border ""
	}

	if {[exists_and_not_null style]} {
		set style " style=\"$style\""
	} else {
		set style ""
	}

	# format HTML attributes
	set dimensions "$width$height"

	# Don't put anything around the <img> tag, it will make it difficult to control the
	#	formating of the image
	set img_url "[ad_conn package_url]party-image-view?[export_vars image_id]"
	set image "<img $dimensions src=\"$img_url\"$border$style/>"
} else {
	#	set image_unavailable_path "/packages/images/www/image-not-available.gif"
	#   set dimensions		[ns_gifsize [template::util::url_to_file $image_unavailable_path]]
	#   set actual_width	[lindex $dimensions 0]
	#	set actual_height	[lindex $dimensions 1]

	if {[exists_and_not_null border]} {
		set border " border=\"$border\""
	} else {
		set border ""
	}

	if {[exists_and_not_null style]} {
		set style " style=\"$style\""
	} else {
		set style ""
	}

	# Don't put anything around the <img> tag, it will make it difficult to control the
	#	formating of the image
	set img_url "[ad_conn package_url]party-image-view?[export_vars image_id]"
	set image "<img src=\"$img_url\"$border$style/>"
}
