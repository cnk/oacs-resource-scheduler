
ad_library {
    Procedures to insert, delete, and manage CTRL Events
    
    @author		kellie@ctrl.ucla.edu (KL)
    @creation-date	05/17/06
    @cvs-id $Id: ce-image-procs.tcl,v 1.2 2006/08/08 00:53:11 avni Exp $
}

namespace eval ctrl_event_image {}

ad_proc -public ctrl_event_image::image {
    {-event_id:required}
    {-event_image:required}
} {
    Upload image into db
} {
    if {![empty_string_p $event_image]} {
	set content_tmpfilename [ns_queryget event_image.tmpfile]		
	set event_image_file_type [ns_guesstype $event_image]
	set extension [string tolower [file extension $event_image]]
            
	#determining the dimensions of the image                                                                                          
	if {[string equal $extension "jpeg"] || [string equal $extension ".jpg"]} {
	    catch { set dimensions [ns_jpegsize $content_tmpfilename] }
	} elseif {[string equal $extension ".gif"]} {
	    catch { set dimensions [ns_gifsize $content_tmpfilename]}
	}

	if {[exists_and_not_null dimensions]} {
	    set event_image_width [lindex $dimensions 0]
	    set event_image_height [lindex $dimensions 1]
	} else {
            set event_image_width ""                
	    set event_image_height ""
	}
	 
	db_dml image_upload {} -blob_files [list $content_tmpfilename]
    }
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
