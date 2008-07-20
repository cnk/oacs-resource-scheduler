ad_page_contract {
    Watches a number of files for reload. Note that the
    paths given to this page should be relative to package root,
    not server root.

    @author Peter Marklund
    @creation-date 17 April 2000
    @cvs-id $Id: file-watch.tcl,v 1.11 2003-04-04 09:19:59 peterm Exp $
} {
    version_id:integer
    paths:multiple
    {return_url ""}
} 

set package_key [apm_package_key_from_version_id $version_id]

foreach path $paths {
    apm_file_watch "packages/$package_key/$path"
}

ad_returnredirect $return_url
