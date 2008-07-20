# /packages/institution/tcl/party-image-procs.tcl

ad_library {
	Helpers for dealing with party images.

    @author			helsleya@cs.ucr.edu
    @creation-date	2004/05/19
    @cvs-id $Id: party-image-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $


	@party_image::get_html
	@party_image::subst
}

namespace eval party_image {}

ad_proc -public party_image::get_id_for {
	{-party_id}
	{-description}
} {
	Get the <code>image_id</code> for an image associated with a specific party
	using the description of the image.
} {
	return [db_string get_image_id_by_name {
		select	image_id
		  from	inst_party_images
		 where	party_id	= :party_id
		   and	description	= :name
	} -default ""]
}

ad_proc -public party_image::get_html {
	{-party_id}
	{-description}
	{-image_id}
	{-height		""}
	{-width			""}
	{-max_height	""}
	{-max_width		""}
	args
} {
	Get the HTML needed to embed the image of a party.
} {
	# //TODO// perhaps 'alt' should default to 'description' when no alt is specified

	set selection 0

	# find image and retrieve image metadata
	if {[exists_and_not_null party_id] && [exists_and_not_null description]} {
		db_0or1row get_image_metadata {
			select	image_id,
					width	as actual_width,
					height	as actual_height
			  from inst_party_images
			 where party_id		= :party_id
			   and description	= :description
		}

		if {![exists_and_not_null image_id]} {
			return ""
		}
	} elseif {[exists_and_not_null image_id]} {
		set selection [db_0or1row get_image_metadata {
			select	image_id,
					width  as actual_width,
					height as actual_height
			  from	inst_party_images
			 where	image_id = :image_id
		}]
	}

	set parent_url "[ad_conn package_url]/"

	# process other attributes for passing-through without modification
	set others ""
	foreach {k v} $args {
		append others $k {="} $v {" }
	}

	# //TODO// detect when non-pixel units are used for these dimensions
	# and skip over processing
	# if there was image dimension metadata, use it
	if {[exists_and_not_null actual_width] || [exists_and_not_null actual_height]} {
		set img_url "${parent_url}party-image-view?[export_vars image_id]"

		# make sure we have width and height
		if {![exists_and_not_null width] && \
			[exists_and_not_null actual_width]} {
			set width $actual_width
		}

		if {![exists_and_not_null height] && \
			[exists_and_not_null actual_height]} {
			set height $actual_height
		}

		# Scale image according to maximum sizes
		if {[exists_and_not_null max_width] && ($width > $max_width)} {
			if {[exists_and_not_null height]} {
				set height [expr ($height * $max_width) / $width]
			}
			set width $max_width
		}

		if {[exists_and_not_null max_height] && ($height > $max_height)} {
			if {[exists_and_not_null width]} {
				set width [expr ($width * $max_height) /  $height]
			}
			set height $max_height
		}

		# wrap formating around attributes for inclusion in the HTML
		if {[exists_and_not_null width]} {
			set width " width=\"$width\""
		}

		if {[exists_and_not_null height]} {
			set height " height=\"$height\""
		}

		# format HTML attributes
		set dimensions "$width$height"

		set image "<img src=\"$img_url\" $dimensions $others/>"
	} else {
		set img_url "${parent_url}party-image-view?[export_vars image_id]"
		set image "<img src=\"$img_url\" $others/>"
	}
	return $image
}

ad_proc -public party_image::subst {
	{-party_id:required}
	str
} {
	Given a string, substitutes all references to party-images in the string with
	the HTML required to embed the image.
} {
	while {[regexp -indices "(<image.*?/>)" $str tag indices]} {
		set tag [string range $str [lindex $tag 0] [lindex $tag 1]]

		# parse the tag, translating it to a TCL call
		regsub "^<image(.*)/>$" $tag {party_image::get_html -party_id $party_id \1} tag
		regsub -- {(name|description)=(".*?"|[a-zA-Z0-9_+-]+)} $tag {-description \2} tag

		# handle specifically named/computed attributes
		while {[regsub -all {(width|height|max_width|max_height)\s*=\s*(".*?"|[a-zA-Z0-9_+-]+)} $tag {-\1 \2} tag]} {
			#lappend args $img_widget_arg_name $img_widget_arg_value
		}

		# handle any unrecognized attributes
		while {[regsub {([a-zA-Z0-9_:+-]+)\s*=\s*(".*?"|[a-zA-Z0-9_+-]+)} $tag {\1 \2} tag]} {
			#lappend args $html_attr_name $html_attr_value
		}

		# if there is no image_id and no party-id in the tag, use the value of the
		# argument passed to this proc
		#//TODO//

		# evaluate the TCL call
		#//TODO// redo so that malicious code cannot be injected by someone with access
		# to the admin interface -- ideally we'd call [subst] and restrict what was allowed
		set tag [eval $tag]

		# place the result back into 'str'
		set result ""
		set str [append result \
					 [string range $str 0 [expr [lindex $indices 0] - 1]] \
					 $tag \
					 [string range $str [expr [lindex $indices 1] + 1] end]]
	}

	return $str
}
