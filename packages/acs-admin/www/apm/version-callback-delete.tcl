ad_page_contract {

    @author Peter Marklund
    @creation-date 28 January 2003
    @cvs-id $Id: version-callback-delete.tcl,v 1.1 2003-01-29 15:53:23 peterm Exp $  
} {
    version_id:integer,notnull    
    type:notnull
}

set package_key [apm_package_key_from_version_id $version_id]
apm_remove_callback_proc -type $type -package_key $package_key

ad_returnredirect "version-callbacks?version_id=$version_id"