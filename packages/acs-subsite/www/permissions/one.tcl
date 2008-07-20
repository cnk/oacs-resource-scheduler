# packages-core-ui/www/acs_object/permissions/index.tcl
ad_page_contract {
    Display permissions and children for the given object_id

    Templated + cross site scripting holes patched by davis@xarg.net

    @author rhs@mit.edu
    @creation-date 2000-08-20
    @cvs-id $Id: one.tcl,v 1.13 2007-01-10 21:22:09 gustafn Exp $
} {
    object_id:integer,notnull
    {children_p "f"}
    {application_url ""}
}

set user_id [auth::require_login]
ad_require_permission $object_id admin

# RBM: Check if this is the Main Site and prevent the user from being
#      able to remove Read permission on "The Public" and locking
#      him/herself out.
if {$object_id eq [subsite::main_site_id]} {
    set mainsite_p 1
} else {
    set mainsite_p 0
}


set name [db_string name {}]

set context [list [list "./" [_ acs-subsite.Permissions]] [ad_quotehtml [_ acs-subsite.Permissions_for_name]]]

db_multirow inherited inherited_permissions { *SQL* } { 
}

db_multirow acl acl { *SQL* } {
}

set controls [list]

lappend controls "<a href=\"grant?[export_vars {application_url object_id}]\">[_ acs-subsite.Grant_Permission]</a>"

db_1row context { *SQL* }

if { $security_inherit_p eq "t" && $context_id ne "" } {
    lappend controls "<a href=\"toggle-inherit?[export_vars {application_url object_id}]\">Don't Inherit Permissions from [ad_quotehtml $context_name]</a>"
} else {
    lappend controls "<a href=\"toggle-inherit?[export_vars {application_url object_id}]\">Inherit Permissions from [ad_quotehtml $context_name]</a>"
}

set controls "\[ [join $controls " | "] \]"

set export_form_vars [export_vars -form {object_id application_url}]

set show_children_url "one?[export_vars {object_id application_url {children_p t}}]"
set hide_children_url "one?[export_vars {object_id application_url {children_p f}}]"

if {$children_p eq "t"} {
    db_multirow children children { *SQL* } {
    }
} else {
    db_1row children_count { *SQL* } 
}
