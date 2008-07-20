ad_library {
    
    Procs for images
    
    @creation-date 2/11/2005
    @cvs-id $Id: image-procs.tcl,v 1.2 2005/03/10 23:27:22 jwang1 Exp $
} 

namespace eval ctrl_procs::image {}

ad_proc -public ctrl_procs::image::get_info {
    {-filename}
    {-array}
    {-type ""}
} {
    Get the size of a .jpg or .gif image.  Returns the height and width information in the given array.
    
    @param filename The absolute path to the .jpg or .gif image in the filesystem.
    @param array    The name of the array to upvar the width and height information to.
    @param type     Either a gif or jpg

    @returns 1 if successful, 0 otherwise.

    @author Jeff Wang
    @creation-date 2/11/2005

} {

    #Parse the file name out
    set extension ""
    set found_p [regexp {.*/(.*)[.](.*)} $filename match image_filename extension]
    upvar $array "local_array"
    set file_list [glob -nocomplain $filename]
    
    if {(!$found_p && [empty_string_p $type]) || ([llength $file_list] == 0)} {
	return 0
    } else {

	if {[string equal $extension "gif"] || [string equal $type "gif"]} {
	    set size [ns_gifsize $filename]
	} elseif {[string equal $extension "jpg"] || [string equal $type "jpg"]} {
	    set size [ns_jpegsize $filename]
	} else {
	    ad_return_complaint 1 "Error calling ctrl_procs::image::get_info -- 
	    This proc can only retreive information on .gif and .jpg images and you requested $extension"
	    ad_script_abort
	}
	

	set local_array(width)  [lindex $size 0]
	set local_array(height) [lindex $size 1]

	return 1
    }
    return 0
}
