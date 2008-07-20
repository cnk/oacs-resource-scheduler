ad_library {
    Procs for working with ctrl-addresses

    @author: Jeff Wang <jcwang@cs.ucsd.edu>
    @creation-date: 12/12/05
    @cvs-id $Id: address-procs.tcl,v 1.1 2005/12/13 00:31:36 jwang1 Exp $
}

namespace eval ctrl::address {}


ad_proc -public ctrl::address::get {
    {-address_id:required}
    {-column_array "room"}
} {
    retrieve address info
} {
    upvar $column_array local_array
    db_0or1row get {} -column_array local_array
}


ad_proc -public ctrl::address::new {
    {-address_id ""}
    {-address_type_id:required ""}
    {-building_id:required}
    {-description ""}
    {-floor ""}
    {-room ""}
    {-gis ""}
    {-address_line_1 ""}
    {-address_line_2 ""}
    {-address_line_3 ""}
    {-address_line_4 ""}
    {-address_line_5 ""}
    {-city ""}
    {-fips_state_code ""}
    {-zipcode ""}
    {-zipcode_ext ""}
    {-fips_country_code ""}
    {-creation_user ""}
    {-context_id ""}
} {

    Create a new ctrl address

} {
    if {[empty_string_p $address_id]} {
	set address_id [db_nextval "acs_object_id_seq"]
    }

    if {[empty_string_p $creation_user]} {
	set creation_user [ad_conn user_id]
    }

    if {[empty_string_p $context_id]} {
	set context_id [ad_conn package_id]
    }

    set address_id [db_exec_plsql new {}]
    return $address_id
}


ad_proc -public ctrl::address::delete {
    {-address_id:required}
} {
    Delete an address
} {
    set error_p 0

    db_transaction {
	db_exec_plsql delete {}
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was a problem deleting the address.  --  $errmsg"
	ns_log notice "ERROR: --- Address delete error -- $errmsg ---"
	ad_script_abort
    }
}

ad_proc -public crs::room::updateold {
    {-address_id:required}
    {-address_type_id:required}
    {-building_id:required}
    {-description}
    {-floor}
    {-room}
    {-gis}
    {-address_line_1}
    {-address_line_2}
    {-address_line_3}
    {-address_line_4}
    {-address_line_5}
    {-city}
    {-fips_state_code}
    {-zipcode}
    {-zipcode_ext}
    {-fips_country_code}
} {
    update the address info
} {
    set update_list [list]
    
    if {[info exists address_type]} {
	lappend update_list " address_type = :address_type "
    }
    if {[info exists building_id]} {
	lappend update_list " building_id = :building_id "
    }
    if {[info exists description]} {
	lappend update_list " description = :description "
    }
    if {[info exists floor]} {
	lappend update_list " floor = :floor "
    }
    if {[info exists room]} {
	lappend update_list " room = :room "
    }
    if {[info exists gis]} {
	lappend update_list " gis = :gis "
    }
    if {[info exists address_line_1]} {
	lappend update_list " address_line_1 = :address_line_1 "
    }
    if {[info exists address_line_2]} {
	lappend update_list " address_line_2 = :address_line_2 "
    }
    if {[info exists address_line_3]} {
	lappend update_list " address_line_3 = :address_line_3 "
    }
    if {[info exists address_line_3]} {
        lappend update_list " address_line_3 = :address_line_3 "
    }
    if {[info exists address_line_4]} {
        lappend update_list " address_line_4 = :address_line_4 "
    }
    if {[info exists address_line_5]} {
        lappend update_list " address_line_5 = :address_line_5 "
    }
    if {[info exists city]} {
        lappend update_list " city = :city "
    }
    if {[info exists fips_state_code]} {
        lappend update_list " fips_country_code = :fips_state_code "
    }
    if {[info exists zipcode]} {
        lappend update_list " zipcode = :zipcode_ext "
    }
    if {[info exists fips_country_code]} {
        lappend update_list " fips_country_code = :fips_country_code "
    }

    set update_string [join $update_list ","]
    set error_p 0
    db_transaction {
	db_dml update {}
    } on_error {
	set error_p 1
    }
    
    if {$error_p} {
	ad_return_complaint 1 "There was a problem updating the address."
	ns_log notice "ERROR: --- Address update error -- $errmsg ---"
	ad_script_abort
    }
}
