<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="subsite_added">
        <querytext>
select b.package_id subsite
from  acs_rels a, apm_packages b
where a.rel_type = 'ctrl_subsite_for_object_rel'
and   a.object_id_two = :room_id
and   b.package_id = a.object_id_one
and   b.package_key = 'acs-subsite'
and   acs_permission.permission_p(b.package_id, :user_id, 'write') = 't'
        </querytext>
    </fullquery>

    <fullquery name="rel_select">
        <querytext>
           select a.rel_id
           from   acs_rels a
           where  a.rel_type = 'ctrl_subsite_for_object_rel'
           and    a.object_id_one = :subsite_id
           and    a.object_id_two = :room_id 
        </querytext>
    </fullquery>

</queryset>
