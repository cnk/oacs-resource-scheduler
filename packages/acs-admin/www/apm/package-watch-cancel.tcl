ad_page_contract {
    Cancels all watches in given package.

    @author Peter Marklund
    @cvs-id $Id: package-watch-cancel.tcl,v 1.1 2003-04-04 09:19:59 peterm Exp $
} {
    package_key
    {return_url "index"}
} 

apm_cancel_all_watches $package_key

ad_returnredirect $return_url
