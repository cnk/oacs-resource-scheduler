ad_page_contract {

    Home page for OpenACS Object Type administration

    @author Yonatan Feldman (yon@arsdigita.com)
    @creation-date August 13, 2000
    @cvs-id $Id: index.tcl,v 1.5 2006-06-04 00:45:45 donb Exp $

} {}

set page_title "Object Type Hierarchical Index"
set context [list "Object Type Hierarchical Index"]

set object_type_hierarchy [acs_object_type_hierarchy]
