# /packages/institution/www/admin/publication/endnote-upload.tcl

ad_page_contract {

    @author nick@ucla.edu
    @creation-date 2004/04/06
    @cvs-id $Id: endnote-upload.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:integer 0}
    {file_type "xml"}
}

set user_id [ad_maybe_redirect_for_registration]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

set title "Endote Publication Upload"

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/publication/ "Publication Index"] [list [set subsite_url]institution/publication/upload-info "Publication Import Directions"] [set title]]]

# boolean for success of the entire upload - assume it is not successful
set success_p 0

if {$personnel_id} {
    set personnel_element    {
	{personnel_id:integer(hidden) {value $personnel_id}}
	{personnel:integer(hidden) {value $personnel_id}}
    }
} else {
    set personnel_options [db_list_of_lists personnel_info {
	select	first_names || ' ' || last_name as name,
	        personnel_id
	from	persons,
	        inst_personnel
	where	person_id = personnel_id
	and	acs_permission.permission_p(personnel_id, :user_id, 'create') = 't'
    }]
	
    set personnel_element "{personnel:integer(multiselect),multiple,optional   {label \"Select the personnel to associate to these publications\"} {options \$personnel_options}}"
}


# create for that allows user to upload their file
ad_form -name publication_upload -html {enctype "multipart/form-data"} -form "
    {upload_file:text(file)                             {label \"<font color=f40219>*</font> File to upload\"}} 
    $personnel_element
    {file_type:text(select)                             {label \"<font color=f40219>*</font> File Type\"} {options {{\"XML\" xml} {\"Text\" txt}}} {value $file_type}}
" -on_submit {

    #if successful must set success_p to 1
    set upload_tmpfilename [ns_queryget upload_file.tmpfile]
    set upload_extension [string tolower [file extension $upload_file]]
    set upload_bytes [file size $upload_tmpfilename]

    if {[string compare $upload_extension ".xml"] == 0} {
	#open and parse file here.
	set file_id [open $upload_tmpfilename r]

	# need to read the file into a string for parsing
	set xml_doc [read $file_id]
        close $file_id

	# calling function to parse file and add rows to inst_publications and inst_personnel_publication_map tables
	
	set result_list [publication::xml_upload -personnel $personnel -xml_doc $xml_doc]
	set no_title_counter [lindex $result_list 0]
	set success_list [lindex $result_list 1]
	set failure_list [lindex $result_list 2]

    } elseif {[string compare $upload_extension ".txt"] == 0} {
	#open and parse file here.
	set file_id [open $upload_tmpfilename r]

	set result_list [publication::txt_upload -personnel $personnel -txt_file_id $file_id]
	set no_title_counter [lindex $result_list 0]
	set success_list [lindex $result_list 1]
	set failure_list [lindex $result_list 2]
    } else {
	ad_return_complaint 1 "You must upload only valid EndNote files with an '.xml' or '.txt' extension."
	ad_script_abort
    }


} -after_submit {
    ad_return_template "endnote-upload-result"
    return
    #ad_returnredirect "[ad_conn package_url]admin/publication/endnote-upload-result?[export_vars {success_list failure_list no_title_counter personnel personnel_id}]"
}
