ad_page_contract {
    Disables a version of a package.
    @author Jon Salz [jsalz@arsdigita.com]
    @creation-date 17 April 2000
    @cvs-id $Id: version-disable.tcl,v 1.3 2002-09-18 11:54:42 jeffd Exp $
} {
    version_id:integer
}

apm_version_disable -callback apm_dummy_callback $version_id

ad_returnredirect "version-view?version_id=$version_id"
