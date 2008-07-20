<?xml version=1.0?>
  <queryset>

    <fullquery name="ctrl::cal::profile::add.check">
      <querytext>
         select profile_id from ccal_profiles where owner_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::delete.profile">
      <querytext>
         begin
           ctrl_ccal_profile.del (
              profile_id =>    :profile_id
           );
         end;
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::add_filter.check_cal_category">
      <querytext>
         select filter_id from ccal_profile_filters
         where  profile_id = :profile_id
         and    profile_type = :profile_type and cal_id = :cal_id and category_id = :category_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::add_filter.check_calendar">
      <querytext>
         select filter_id from ccal_profile_filters
         where  profile_id = :profile_id
         and    profile_type = :profile_type and cal_id = :cal_id and category_id is null 
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::add_filter.check_category">
      <querytext>
         select filter_id from ccal_profile_filters
         where  profile_id = :profile_id
         and    profile_type = :profile_type and cal_id is null and category_id = :category_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::add_filter.cal_category">
      <querytext>
         insert into ccal_profile_filters(filter_id, profile_id, profile_type, cal_id, category_id)
         values(ccal_profile_filter_id_seq.nextval,:profile_id,:profile_type, :cal_id,:category_id)
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::add_filter.calendar">
      <querytext>
         insert into ccal_profile_filters(filter_id, profile_id, profile_type, cal_id, category_id)
         values(ccal_profile_filter_id_seq.nextval,:profile_id,:profile_type, :cal_id, null)
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::add_filter.category">
      <querytext>
         insert into ccal_profile_filters(filter_id, profile_id, profile_type, cal_id, category_id)
         values(ccal_profile_filter_id_seq.nextval,:profile_id,:profile_type, null,:category_id)
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::delete_filter_by_id.filter">
      <querytext>
         delete from ccal_profile_filters where filter_id = :filter_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::delete_filter_by_category.filter">
      <querytext>
         delete from ccal_profile_filters 
         where  profile_id = :profile_id
         and    profile_type = 'category' and category_id = :category_id 
      </querytext>
    </fullquery>
 
    <fullquery name="ctrl::cal::profile::delete_filter_by_calendar.filter">
      <querytext>
         delete from ccal_profile_filters
         where  profile_id = :profile_id
         and    profile_type = 'calendar' and cal_id = :cal_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::get_category.ids">
      <querytext>
         select category_id
         from   ccal_profile_filters
         where  profile_id = :profile_id
         and    profile_type = 'category'
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::get_calendar.ids">
      <querytext>
         select cal_id
         from   ccal_profile_filters
         where  profile_id = :profile_id
         and    profile_type = 'calendar'
      </querytext>
    </fullquery>
  
    <fullquery name="ctrl::cal::profile::update_email.email">
      <querytext>
         update ccal_profiles
         set    email_period = :email_period,
                email_upto = :email_upto,
                email_upto_type = :email_upto_type
         $set_email_day
         where  profile_id = :profile_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::send_email.profile_email">
      <querytext>
         select email_period, email_day, 
                decode(email_sent,'','',to_char(email_sent,'YYYY-MM-DD')) email_sent, 
                trim(to_char(sysdate,'Day')) today_day,
                to_char(sysdate,'YYYY-MM-DD') today,
                to_char(sysdate-7,'YYYY-MM-DD') before_week,
                to_char(sysdate-1,'YYYY-MM-DD') before_day,
                email_upto, email_upto_type
         from   ccal_profiles
         where  owner_id = :user_id 
         and    email_period is not null
         and    email_period != 'none'
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::send_email.profile_calendar_category">
      <querytext>
         select b.profile_type, b.cal_id, b.category_id, 
                decode(b.profile_type,'calendar',c.cal_name,'') calendar_name,
                decode(b.profile_type,'category',d.name,'') category_name
         from   ccal_profiles a, ccal_profile_filters b, ctrl_calendars c, ctrl_categories d
         where  a.owner_id = :user_id
         and    b.profile_id = a.profile_id
         and    c.cal_id (+)= b.cal_id
         and    d.category_id (+) = b.category_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::send_email.email_sent">
      <querytext>
         update ccal_profiles
         set    email_sent = sysdate
         where  owner_id = :user_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::send_email.events">
      <querytext>
       select z.event_object_id cal_id, z.event_id, z.title event_title, z.notes event_notes,
              z.location event_location,
              trim(to_char(z.start_date, 'mm/dd/yy hh12:mi am')) event_start_date,
              trim(to_char(z.end_date, 'mm/dd/yy hh12:mi am')) event_end_date
       from   ctrl_events z
       where  z.event_id in (select b.event_id
                             from   ctrl_calendars a, ctrl_calendar_event_map m, ctrl_events b $from_category
                             where  a.cal_id = a.object_id
                             and    a.owner_id is null
                             and    m.cal_id = a.cal_id
                             and    b.event_id = m.event_id 
                             and    to_char(b.end_date, 'yyyy-mm-dd') >= to_char(sysdate,'yyyy-mm-dd')
                             $sql_where)
       $sql_where_event
       order by z.start_date asc
      </querytext>
    </fullquery>

    <fullquery name="ctrl::cal::profile::send_email_all.users">
      <querytext>
         select user_id, email from cc_users where member_state = 'approved'
      </querytext>
    </fullquery>

  </queryset>
