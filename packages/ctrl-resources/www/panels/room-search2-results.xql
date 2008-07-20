<?xml version="1.0"?>
<queryset>

    <partialquery name="filter_subsite">
       <querytext>
          where v.subsite_id = :subsite_id
       </querytext>
    </partialquery>

    <partialquery name="filter_name">
       <querytext>
          and   lower(r.name) like '%$name_arg%'
       </querytext>
    </partialquery>

    <partialquery name="filter_capacity">
       <querytext>
          and   r.capacity = :capacity_arg
       </querytext>
    </partialquery>

    <partialquery name="filter_location">
       <querytext>
          and   lower(r.floor) || lower(r.room) || lower(a.address_line_1) || lower(a.address_line_2) || lower(a.address_line_3) || lower(a.address_line_4) || lower(a.address_line_5) || lower(a.city) || lower(a.zipcode) || lower(s.abbrev) || lower(s.state_name) like lower('%$location%')
       </querytext>
    </partialquery>

    <partialquery name="filter_eq">
       <querytext>
          and   r.room_id in (select e.parent_resource_id 
                              from   crs_resources e 
                              where  e.resource_category_id in ($eq_csv)
                              group by e.parent_resource_id
                              having count(distinct e.resource_category_id) = $eq_ctr)
       </querytext>
    </partialquery>

    <partialquery name="filter_eq2">
       <querytext>
          and   r.room_id in (select e.parent_resource_id
                              from   crs_resources e
                              where  e.resource_category_id in ($eq_csv)
                              group by e.parent_resource_id
                              having count(distinct e.resource_category_id) != $eq_ctr)
       </querytext>
    </partialquery>

    <partialquery name="filter_service">
       <querytext>
          and   lower(r.services) like '%$add_services%'
       </querytext>
    </partialquery>

    <partialquery name="filter_all_day">
       <querytext>
         and    r.room_id not in (select ev1.event_object_id
                                  from   ctrl_events ev1, crs_events ev2
                                  where  (to_char(ev1.start_date,'YYYY-MM-DD') = :all_day or to_char(ev1.end_date,'YYYY-MM-DD') = :all_day)
                                  and    ev2.event_id = ev1.event_id
                                  and    ev2.status = 'approved')
       </querytext>
    </partialquery>

    <partialquery name="filter_time">
       <querytext>
         and    r.room_id not in (select ev1.event_object_id
                                  from   ctrl_events ev1, crs_events ev2
                                  where  ((to_char(ev1.start_date,'YYYY-MM-DD-HH24-MI-SS') >= :start_date and
                                           to_char(ev1.start_date,'YYYY-MM-DD-HH24-MI-SS') <= :end_date) or
                                          (to_char(ev1.end_date,  'YYYY-MM-DD-HH24-MI-SS') >= :start_date and
                                           to_char(ev1.end_date,  'YYYY-MM-DD-HH24-MI-SS') <= :end_date) or
                                          (to_char(ev1.start_date,'YYYY-MM-DD-HH24-MI-SS') <  :start_date and
                                           to_char(ev1.end_date,  'YYYY-MM-DD-HH24-MI-SS') >  :end_date)) 
                                  and    to_char(ev1.end_date,'YYYY-MM-DD') <= :end_date
                                  and    ev2.event_id = ev1.event_id
                                  and    ev2.status = 'approved')
       </querytext>
    </partialquery>

    <fullquery name="room_select_all">
       <querytext>
          select r.room_id, r.name, r.description, r.capacity, r.floor, r.services, r.approval_required_p, a.address_line_1
          from   crs_room_details r, ctrl_addresses a, us_states s
          where  r.enabled_p = 't'
          and    r.room_id in (select v.resource_id from crs_subsite_resrc_map_vw v $filter_subsite)
          $filter_eq
          $filter_name
          $filter_capacity
          $filter_service
          $filter_all_day
          $filter_time
          and    a.address_id (+) = r.address_id
          and    s.fips_state_code (+) = a.fips_state_code
          $filter_location
          [template::list::orderby_clause -orderby -name "room"]
       </querytext>
    </fullquery>

    <fullquery name="room_select">
       <querytext>
          select r.room_id, r.name, r.description, r.capacity, r.floor, r.services, r.approval_required_p, a.address_line_1
          from   crs_room_details r, ctrl_addresses a, us_states s
          where  r.enabled_p = 't'
          and    r.room_id in (select v.resource_id from crs_subsite_resrc_map_vw v $filter_subsite)
          $filter_eq
          $filter_name
          $filter_capacity
          $filter_service
          $filter_all_day
          $filter_time
          and    a.address_id (+) = r.address_id
          and    s.fips_state_code (+) = a.fips_state_code
          $filter_location
          [template::list::page_where_clause -name "room" -and -key "r.room_id"]
          [template::list::orderby_clause -orderby -name "room"]
       </querytext>
    </fullquery>

    <fullquery name="room2_total">
       <querytext>
          select count(*) room2_total
          from   crs_room_details r, ctrl_addresses a, us_states s
          where  r.enabled_p = 't'
          and    r.room_id in (select v.resource_id from crs_subsite_resrc_map_vw v $filter_subsite)
          $filter_eq2
          $filter_name
          $filter_capacity
          $filter_service
          $filter_all_day
          $filter_time
          and    a.address_id (+) = r.address_id
          and    s.fips_state_code (+) = a.fips_state_code
          $filter_location
          [template::list::orderby_clause -orderby -name "room"]
       </querytext>
    </fullquery>

    <fullquery name="room2_select">
       <querytext>
    select *
    from ( 
       select x.*, rownum as row_num
       from (
          select r.room_id, r.name, r.description, r.capacity, r.floor, r.services, r.approval_required_p, a.address_line_1
          from   crs_room_details r, ctrl_addresses a, us_states s
          where  r.enabled_p = 't'
          and    r.room_id in (select v.resource_id from crs_subsite_resrc_map_vw v $filter_subsite)
          $filter_eq2
          $filter_name
          $filter_capacity
          $filter_service
          $filter_all_day
          $filter_time
          and    a.address_id (+) = r.address_id
          and    s.fips_state_code (+) = a.fips_state_code
          $filter_location
          [template::list::orderby_clause -orderby -name "room"]
       ) x
    )
    where (row_num >= :lower_bound2 and row_num <= :upper_bound2)
       </querytext>
    </fullquery>



</queryset>
