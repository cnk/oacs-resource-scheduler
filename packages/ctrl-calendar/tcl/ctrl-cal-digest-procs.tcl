# /packages/ctrl-calendar/tcl/ctrl-cal-digest-procs.tcl

ad_library {
    
    Calendar Digest Procedures
    
    @author avni@ctrl.ucla.edu (AK)
    @creation-date 12/01/06
    @cvs-id $Id$
}

namespace eval ctrl::cal {}
namespace eval ctrl::cal::digest {}
namespace eval ctrl::cal::digest::ext {}

ad_proc -public ctrl::cal::digest::get_cal_digest_id {
    -cal_id
    -ext_digest_id
    -ext_digest_url_root
} {
    This procedures returns the cal_digest_id
    for the passed in cal_id and ext_digest

    Returns "" if record does not exist
} {
    return [db_string get_cal_digest_id {
	select cal_digest_id
	from   ccal_digest_map
	where  cal_id = :cal_id
	and    ext_digest_id = :ext_digest_id
	and    ext_digest_url_root = :ext_digest_url_root
    } -default ""]
}

ad_proc -public ctrl::cal::digest::event_is_posting_in_digest_p {
    -event_id
    -digest_id
} {
    This procedure returns 1 if the passed in event_id
    is already a posting in the passed in digest_id
} {
    return [db_string event_is_posting_p {
	select cepm.ext_posting_id
	from   ccal_event_posting_map cepm,
	       ccal_digest_map cdm
	where  cepm.event_id = :event_id
	and    cepm.cal_digest_id = cdm.cal_digest_id
	and    cdm.ext_digest_id = :digest_id
    } -default 0]
}

ad_proc -public ctrl::cal::digest::get_notposted_digest_list {
    -cal_id
    -event_id
} {
    This procedure returns a list of digests to which the event_id passed in has not been posted, but can be
} {
    set digest_mapped_constraint ""
    set digest_mapped_list [join [db_list get_digest_mapped_list {
	select cal_digest_id
	from  ccal_event_posting_map
	where event_id = :event_id
    }] ","]

    if {![empty_string_p $digest_mapped_list]} {
	#AMK 
	return
	set digest_mapped_constraint " and cal_digest_id not in ($digest_mapped_list)"
    }
    
    set digests_not_posted ""
#	select cal_digest_id,
#               ext_digest_url_root,
#               ext_digest_id as digest_id
#	from   ccal_digest_map
#	where  1=1 cal_id = :cal_id $digest_mapped_constraint
    db_foreach get_digest_list "
	select distinct cal_digest_id,
               ext_digest_url_root,
               ext_digest_id as digest_id
	from   ccal_digest_map
	where  1=1 $digest_mapped_constraint
    " {
	set digest_name [ctrl::cal::digest::ext::get_digest_name -cal_digest_id $cal_digest_id]
	# AMK
	set url_root [util_current_location]
	append digests_not_posted "&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"$url_root/digest/ws/posting-add?[export_url_vars digest_id event_id cal_digest_id]\">$digest_name</a><br>"
	# AMK
	break
    }

    return $digests_not_posted
}

ad_proc -public ctrl::cal::digest::get_posted_digest_list {
    -event_id
} {
    This procedure returns a list of names of the digests to which the event has been posted
} {
    set digest_mapped_list [list]
    set counter 0
    db_foreach get_digest_mapped_list {
	select cal_digest_id
	from  ccal_event_posting_map
	where event_id = :event_id
    } {
	set digest_name [ctrl::cal::digest::ext::get_digest_name -cal_digest_id $cal_digest_id]
	lappend digest_mapped_list "&nbsp;&nbsp;&nbsp;&nbsp;$digest_name<br>"
	incr counter
    }
    return $digest_mapped_list 
}

ad_proc -private ctrl::cal::digest::ext::get_digest_name {
    -cal_digest_id
} {
    This procedure returns the digest name of the cal_digest_id passed in.
    This proc calls a web service as this digest may be external to this server.
} {
    # AMK
    set external_digest_info [db_0or1row get_digest_info {
	select ext_digest_url_root,
	       ext_digest_id,
	       dd.name
	from   ccal_digest_map,
	       drc_digests dd
	where  cal_digest_id = :cal_digest_id
	and    ext_digest_id = dd.digest_id
    }]

    if {$external_digest_info} {
	return $name
    } else {
	return ""
    }
    
}

