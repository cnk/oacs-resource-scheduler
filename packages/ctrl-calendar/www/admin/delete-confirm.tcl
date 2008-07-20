ad_page_contract {

    Confirm the deletion of this cal

    @author jeff@ctrl.ucla.edu (JW)
    @creation-date 2005-12-18
    @cvs-id $Id$

    @param request_id primary key

} {
    cal_id:naturalnum,optional
    {return_url [get_referrer]}
} 


set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set title "Confirm Delete"
set context " Confirm Delete "


ctrl::cal::get -cal_id $cal_id -column_array "cal_info"
set cal_name $cal_info(cal_name)

ad_form -name "confirm" -form {
    {warn:text(inform) {label {Confirm:}} {value "Are you sure you want to delete $cal_name"}}
    {sub_yes:text(submit) {label {Yes}}}
    {sub_no:text(submit) {label {No}}}
} -on_submit {
    if {![empty_string_p $sub_yes]} {
	ctrl::cal::remove -cal_id $cal_id
    }
} -after_submit {
    ad_returnredirect $return_url
} -export {return_url cal_id}
