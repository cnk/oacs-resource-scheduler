# /packages/institution/www/drc/personnel-login.tcl

ad_page_contract {
    Returns Personnel Data XML for the Personnel ID passed in

    @author avni@ctrl.ucla.edu (AK)
    @cvs-id $Id: personnel-login.tcl,v 1.1 2006/09/20 08:43:21 avni Exp $
    @creation-date 9/19/2006
    
} {
    employee_number:trim,integer,notnull
    email:trim,notnull
}


doc_return 200 text/xml [inst::drc::personnel_login_data_xml -employee_number $employee_number -email $email]
return
