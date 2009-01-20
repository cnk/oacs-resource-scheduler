
ad_library {
    Procedures to insert, delete, and manage CTRL Events
    
    @author		kellie@ctrl.ucla.edu (KL)
    @creation-date	05/17/06
    @cvs-id $Id: ce-image-procs.tcl,v 1.2 2006/08/08 00:53:11 avni Exp $
}

namespace eval ctrl_event_image {}

ad_proc -public ctrl_event_image::new {
    {-event_id:required}
    {-event_image:required}
    {-event_image_caption:required}
} {
    Upload image into db
} {

    if {![empty_string_p $event_image]} {
	set mime_type [ns_guesstype $event_image]
	set content_tmpfilename [ns_queryget event_image.tmpfile]		
	set item_id [image::new -name "Image for Event ID: $event_id" -parent_id $event_id -tmp_filename $content_tmpfilename \
			 -mime_type $mime_type -description $event_image_caption]
	return $item_id
    }
    return 0
}

ad_proc -public ctrl_event_image::update {
    {-image_item_id:required}
    {-event_image:required}
    {-event_image_caption:required}
} {
    Adds new revision to image in db
} {
    if {![empty_string_p $event_image]} {
	set mime_type [ns_guesstype $event_image]
	set extension [string tolower [file extension $event_image]]
	set content_tmpfilename [ns_queryget event_image.tmpfile]		
	foreach {width height} [image::get_file_dimensions -filename $content_tmpfilename -mime_type $mime_type] {}

	content::revision::new -item_id $image_item_id -tmp_filename $content_tmpfilename -description $event_image_caption \
	    -is_live "t" -description $event_image_caption \
	    -attributes [list [list width $width] [list height $height]]
    }
    return
}

ad_proc -public ctrl_event_image::ctrl_event_object_image {
    {-event_object_id:required}
    {-image:required}
} {
    Upload image into db
} {
    if {![empty_string_p $image]} {
	set content_tmpfilename [ns_queryget image.tmpfile]		
	set image_file_type [ns_guesstype $image]
	set extension [string tolower [file extension $image]]
            
	#determining the dimensions of the image                                                                                          
	if {[string equal $extension "jpeg"] || [string equal $extension ".jpg"]} {
	    catch { set dimensions [ns_jpegsize $content_tmpfilename] }
	} elseif {[string equal $extension ".gif"]} {
	    catch { set dimensions [ns_gifsize $content_tmpfilename]}
	}

	if {[exists_and_not_null dimensions]} {
	    set image_width [lindex $dimensions 0]
	    set image_height [lindex $dimensions 1]
	} else {
            set image_width ""                
	    set image_height ""
	}
	db_dml image_upload {} -blob_files [list $content_tmpfilename]
    }
}
