ad_library {

    Utility procs 

    @author jeff@ctrl.ucla.edu
    @creation-date 12/15/2005
    @cvs-id $Id$
}

namespace eval crs::util {}

ad_proc -public crs::util::build_branch_js {
} {
    Build branch condition javascript
} {
    set js_code ""
    
    #get the used resources
    set resource_types [db_list_of_lists get_resource_types {}]
    
    set js_lib_code ""
    set count 0
    foreach resource_type $resource_types {
	
	set resource_type_name [lindex $resource_type 0]
	set resource_type_id   [lindex $resource_type 1]
	
	
	set resource_list [db_list_of_lists get_resources {}]
	set resource_count [llength $resource_list]
	
	
	append js_lib_code "lib=libraryList.addLibrary('$resource_type_id','$resource_count');\n"
	
	set js_resource_code ""
	
	foreach resource $resource_list {
	    set resource_name [lindex $resource 0]
	    set resource_id   [lindex $resource 1]
	    append js_resource_code "resource=lib.addState('$resource_name','$resource_id');\n"
	}
	append js_lib_code $js_resource_code 
    }
    set js_code "libraryList= new LibraryList();\n$js_lib_code"
    return $js_code
}

