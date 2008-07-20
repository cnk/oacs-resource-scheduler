# /packages/mbryzek-subsite/www/admin/rel-segments/delete-2.tcl

ad_page_contract {

    Deletes the relational segment

    @author mbryzek@arsdigita.com
    @creation-date Tue Dec 12 11:23:12 2000
    @cvs-id $Id: delete-2.tcl,v 1.2 2007-01-10 21:22:07 gustafn Exp $

} {
    segment_id:integer,notnull
    { operation "" }
    { return_url "" }
} -validate {
    segment_exists_p -requires {segment_id:notnull} {
	if { ![rel_segments_permission_p -privilege delete $segment_id] } {
	    ad_complain "The segment either does not exist or you do not have permission to delete it"
	}
    }
}

if {$operation eq "Yes, I really want to delete this segment"} {
    if { $return_url eq "" } {
	# Go back to the group for this segment
	set group_id [db_string select_group_id {
	    select s.group_id from rel_segments s where s.segment_id = :segment_id
	} -default ""]
	if { $group_id ne "" } {
	    set return_url "../groups/one?[ad_export_vars group_id]"
	}
    }

    # Delete all the constraints that require this segment
    db_transaction {
	rel_segments_delete $segment_id
    }
} 

if { $return_url eq "" } {
    set return_url "one?[ad_export_vars {segment_id}]"
}

ad_returnredirect $return_url

