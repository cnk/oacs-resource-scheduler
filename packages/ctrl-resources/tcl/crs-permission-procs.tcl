ad_library {
    Set of procs to deal with permissions to edit/delete/change state of reservation

    @author KH
    @cvs-id $Id$
    @creation-date 2006-06-03
}

namespace eval crs::request::permission {}


ad_proc -public crs::request::permission::permission_p {
    -object_id:required
    -party_id:required
    -privilege:required
} {
    This proc is a wrapper around the permission_p built in OACS and the permission
    specific to the room reservation

    @param object_id the object
    @param party_id the party
    @param privilege
} {

    

    



}
