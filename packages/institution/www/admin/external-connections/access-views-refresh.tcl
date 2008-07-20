# /packages/institution/www/admin/external-connections/access-views-refresh.tcl
# Page refreshes the access materialized views

set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
set user_id [ad_maybe_redirect_for_registration]

ReturnHeaders text/html
ns_write "[ad_header "Refresh Materialized Views"]
<p>
Refreshing ..<br><br>"

set error_p 0
db_transaction {
    db_exec_plsql refresh_views {
	begin
	     DBMS_REFRESH.REFRESH(name=> 'axs_refresh_group');
	end;
    }
} on_error {
    set error_p 1
    db_abort_transaction
}

if {$error_p} {
    ad_return_error "Error" "Error Refreshing Views: <p> $errmsg"
    return
}

ns_write "Finished refreshing the data.<p>
<a href=\"${subsite_url}institution/doc/access-pplus-views\">Back to ACCESS Documentation</a><p>"
ns_write "[ad_footer]"

