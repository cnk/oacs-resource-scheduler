# -*- tab-width: 4 -*-
#ad_page_contract {
#	Return the photo for a single person.
#
#	@author				helsleya@cs.ucr.edu (AH)
#	@creation-date		2003-08-14
#	@cvs-id				$Id: photo-template.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
#
#	@param	personnel_id	person to retrieve the photo for
#} {
#	{personnel_id:integer}
#}

# get dimensions from DB
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
set selection [db_0or1row personal_photo_metadata {
	select	photo_width  as actual_width,
			photo_height as actual_height
	  from	inst_personnel
	 where	personnel_id = :personnel_id
}]

# if there was a photo, use it
if {![empty_string_p $actual_width] && ![empty_string_p $actual_height]} {
	# We are very specific here even though the file is in the same directory
	#	since photos are somewhat likely to be referenced from many other places
	set img_url "[ad_conn package_url]/admin/personnel/photo?[export_vars personnel_id]"
	
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

	# format HTML attributes
	set dimensions "$width$height"
	
	set image "<nobr><img $dimensions src=\"$img_url\" $border/>&nbsp;&nbsp;</nobr>"

} else {
	#	set image_unavailable_path "/packages@subsite_url@images/www/photo-not-available.gif"
	#   set dimensions [ns_gifsize [template::util::url_to_file $image_unavailable_path]]
	#    set actual_width [lindex $dimensions 0]
	#	set actual_height [lindex $dimensions 1]
	#	set img_url ""
	set image ""

}

