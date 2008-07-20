# /packages/mbryzek-subsite/www/admin/groups/constraints-create.tcl

ad_page_contract {

    Describes constraints and offers the option to create a relational
    segment for this rel_type

    @author mbryzek@arsdigita.com
    @creation-date Thu Jan  4 10:54:36 2001
    @cvs-id $Id: constraints-create.tcl,v 1.3 2002-09-06 21:49:59 jeffd Exp $

} {
    group_id:notnull,integer
    rel_type:notnull
    { return_url "" }
} -properties {
    context:onevalue
    export_vars:onevalue
    rel_type_pretty_name:onevalue
    group_name:onevalue
}

set context [list [list "[ad_conn package_url]admin/groups/" "Groups"] [list one?[ad_export_vars group_id] "One Group"] "Add constraint"]
set export_vars [ad_export_vars -form {group_id rel_type return_url}]

db_1row select_props {
    select acs_group.name(:group_id) as group_name,
           t.pretty_name as rel_type_pretty_name
      from acs_object_types t
     where t.object_type = :rel_type
}

ad_return_template


