ad_page_contract {
    
    This is called by server monitoring scripts, such as 
    keepalive (see http://arsdigita.com/free-tools/keepalive.html)
    if it doesn't return "success" then they are supposed
    to kill the AOLserver.

    You can also use this with our Uptime monitoring system,
    described in Chapter 15 of http://photo.net/wtr/thebook/

    This tests total db connectivity.

    @cvs-id $Id: dbtest.tcl,v 1.1.1.1 2001-03-13 22:59:27 ben Exp $
} { }

if { ![db_0or1row date_check {
    select sysdate from dual
}] } {
    doc_return 500 text/plain "failed"	
} else {
    ns_return 200 text/plain "success"
}


