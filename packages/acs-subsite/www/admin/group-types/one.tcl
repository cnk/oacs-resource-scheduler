# /packages/mbryzek-subsite/www/admin/groups/one.tcl

ad_page_contract {

    Shows summary information about one group type

    @author mbryzek@arsdigita.com
    @creation-date Wed Nov  8 18:02:15 2000
    @cvs-id $Id: one.tcl,v 1.4 2003-05-17 09:59:47 jeffd Exp $

} {
    group_type:notnull
} -properties {
    context:onevalue
    group_type:onevalue
    group_type_enc:onevalue
    group_type_pretty_name:onevalue
    groups:multirow
    attributes:multirow
    allowed_relations:multirow
    return_url:onevalue
    dynamic_p:onevalue
    more_relation_types_p:onevalue
}

set user_id [ad_conn user_id]
set return_url_enc [ad_urlencode [ad_conn url]?[ad_conn query]]
set group_type_enc [ad_urlencode $group_type]

set package_id [ad_conn package_id]

set context [list [list "[ad_conn package_url]admin/group-types/" "Group types"] "One type"]

if { ![db_0or1row select_pretty_name {
    select t.pretty_name as group_type_pretty_name, t.dynamic_p,
           nvl(gt.default_join_policy, 'open') as default_join_policy
      from acs_object_types t, group_types gt
     where t.object_type = :group_type
       and t.object_type = gt.group_type(+)
}] } {
    ad_return_error "Group type doesn't exist" "Group type \"$group_type\" doesn't exist"
    return
}

# Pull out the first 25 groups of this type. If there are more, we'll
# offer a link to display them all. Alphabetize the first 25 groups

db_multirow groups groups_select {
    select my_view.group_name, my_view.group_id, rownum as num 
    from (select /*+ ORDERED */ DISTINCT  g.group_name, g.group_id
           from acs_objects o, groups g,
                application_group_element_map app_group, 
                all_object_party_privilege_map perm
          where perm.object_id = g.group_id
            and perm.party_id = :user_id
            and perm.privilege = 'read'
            and g.group_id = o.object_id
            and o.object_type = :group_type
            and app_group.package_id = :package_id
            and app_group.element_id = g.group_id
          order by lower(g.group_name)) my_view 
    where rownum <= 26
}

# Select out all the attributes for groups of this type
db_multirow attributes attributes_select {
    select a.attribute_id, a.pretty_name, 
           a.ancestor_type, t.pretty_name as ancestor_pretty_name
      from acs_object_type_attributes a,
           (select t.object_type, t.pretty_name, level as type_level
              from acs_object_types t
             start with t.object_type='group'
           connect by prior t.object_type = t.supertype) t 
     where a.object_type = :group_type
       and t.object_type = a.ancestor_type
    order by type_level 
}


# Select out all the allowed relationship types
db_multirow allowed_relations relations_select {
    select t.pretty_name, g.rel_type, g.group_rel_type_id
      from acs_object_types t, group_type_rels g
     where t.object_type = g.rel_type
       and g.group_type = :group_type
     order by lower(t.pretty_name)
}

# See if we need to offer a link to add a rel type
set more_relation_types_p [rel_types::additional_rel_types_p -group_type $group_type]

ad_return_template
