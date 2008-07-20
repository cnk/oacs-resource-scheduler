<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="subsite_select">
        <querytext>
            select lpad('&nbsp;',30*(level-1),'&nbsp;') || p.instance_name subsite_name, 
                   p.package_id subsite_id,
                   decode(acs_permission.permission_p(p.package_id,
                                            :user_id,
                                            'write'),
                't', 1,
                'f', 0) as write_p
            from   site_nodes s, apm_packages p
            where  p.package_id = s.object_id
            and    p.package_key = 'acs-subsite'
            start  with s.object_id = :root_subsite_id
            connect by prior s.node_id = s.parent_id
        </querytext>
    </fullquery>

    <fullquery name="subsite_added">
        <querytext>
select b.package_id subsite_id
from  acs_rels a, apm_packages b
where a.rel_type = 'ctrl_subsite_for_object_rel'
and   a.object_id_two = :room_id
and   b.package_id = a.object_id_one
and   b.package_key = 'acs-subsite'
and   acs_permission.permission_p(b.package_id, :user_id, 'write') = 't'
        </querytext>
    </fullquery>

</queryset>
