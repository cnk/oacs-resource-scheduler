# /packages/ctrl-calendar/www/admin/filter/index.tcl		-*- tab-width: 4 -*-
ad_page_contract {
	Calendar filter page
	@author			kellie@ctrl.ucla.edu
	@creation-date	07/26/2007
	@cvs-id			$Id$
} {
	{cal_id:naturalnum,optional}
	{julian_date:naturalnum,optional}
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set package_url	[ad_conn package_url]

################################################################################
set filter_sql		""

if {![permission::permission_p -object_id $package_id -privilege admin]} {
	append filter_sql " and o.creation_user = :user_id"
}

if {[exists_and_not_null cal_id]} {
	append filter_sql " and f.cal_id = :cal_id"
}

db_multirow -extend {
	view_link
	edit_link
	delete_link
} get_cal_filters get_cal_filters {} {
	set view_link	"<a href=\"[export_vars -base filter-view	{cal_filter_id cal_id}]\">View</a>"
	set edit_link	"<a href=\"[export_vars -base filter-ae		{cal_filter_id cal_id}]\">Edit</a>"
	set delete_link	"<a href=\"[export_vars -base filter-delete	{cal_filter_id cal_id}]\">Delete</a>"
}

set filter_url [export_vars -base filter-ae {cal_id}]
