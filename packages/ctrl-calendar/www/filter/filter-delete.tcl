# /packages/ctrl-calendar/www/admin/filter-delete.tcl

ad_page_contract {
    Delete a calendar filter
    
    @author kellie@ctrl.ucla.edu
    @creation-date 08/03/2007
    @cvs-id $Id
} {
    cal_filter_id:naturalnum,notnull
    cal_id:naturalnum,notnull
}

    set exist_p [ctrl::cal::filter::get -cal_filter_id $cal_filter_id -column_array filter_info]
    if {$exist_p} {
	set page_title "Delete $filter_info(filter_name)"
    } else {
	ad_return_error 1 "<br><ul><li>Invalid Filter Id</li></ul>"
	ad_script_abort
    }
ad_form -name "filter_delete" -method post -html {encytpe multipart/form-date} -form {
    cal_filter_id:text(hidden)
    cal_id:text(hidden)
    {filter_name:text(inform) {label "Filter Name:"} optional}
    {description:text(inform) {label "Description:"} optional}
} -on_request {
    set filter_name $filter_info(filter_name)
    set description $filter_info(description)
} -on_submit {
    ctrl::cal::filter::remove -cal_filter_id $cal_filter_id 
} -after_submit {
    ad_returnredirect "index?[export_url_vars cal_id]"
}






