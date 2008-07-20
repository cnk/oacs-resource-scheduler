<?xml version="1.0"?>
<queryset>

<fullquery name="crs::resv_resrc::policy::add.insert_row">
  <querytext>
       insert into crs_resv_resource_policies (policy_id, resource_id, policy_name, latest_resv_date,
            time_interval_after_rsv_dte, time_interval_before_start_dte, resv_period_before_start_date, 
           creation_date, creation_user, last_modified, modifying_user,priority_level, all_day_period_start, all_day_period_end)
       values (:policy_id, :resource_id, :policy_name, :latest_resv_date, 
           :time_interval_after_resv_date , :time_interval_before_start_dte, :resv_period_before_start_date,
           sysdate, :user_id, sysdate, :user_id, :priority_level, :all_day_period_start, :all_day_period_end)
  </querytext>
</fullquery>


<fullquery name="crs::resv_resrc::policy::update.update_row">
  <querytext>
       update crs_resv_resource_policies set [join $update_list ", "] , 
              last_modified = sysdate , modifying_user = :user_id
       where policy_id = :policy_id
  </querytext>
</fullquery>

<fullquery name="crs::resv_resrc::policy::get.retrieve">
  <querytext>
      select policy_id, resource_id, policy_name, latest_resv_date, to_char(latest_resv_date,'Mon dd, yyyy') as latest_resv_date_display,
            time_interval_after_rsv_dte, time_interval_before_start_dte, resv_period_before_start_date, 
            creation_date, creation_user, last_modified, modifying_user,priority_level, 
	    to_char(all_day_period_start, 'HH24:MI') as all_day_period_start, 
	    to_char(all_day_period_end, 'HH24:MI') as all_day_period_end
      from crs_resv_resource_policies 
      where $where_clause
  </querytext>
</fullquery>




<fullquery name="crs::resv_resrc::policy::assign_to_group.group_with_policy">
  <querytext>
      select 1 from 
      dual where exists (select 1 
                         from crs_resv_resource_pol_assns 
                         where policy_id = :policy_id and group_id = :group_id)
  </querytext>
</fullquery>


<fullquery name="crs::resv_resrc::policy::assign_to_group.add_policy_to_group">
  <querytext>
      insert into crs_resv_resource_pol_assns (policy_id, group_id, creation_date, creation_user)
      values (:policy_id, :group_id, sysdate, :user_id)
  </querytext>
</fullquery>

<fullquery name="crs::resv_resrc::policy::check_compliance.get_policy">
  <querytext>
    begin
      :1 := crs_policy.get_policy (
	user_id => :user_id,
	resource_id => :resource_id );
    end;
  </querytext>
</fullquery>

<fullquery name="crs::resv_resrc::policy::check_compliance.check_compliance">
  <querytext>
    begin
      :1 := crs_policy.check_compliance (
	policy_id => :policy_id,
	request_date => $request_date,
	reservation_start_date => $reservation_start_date,
	reservation_end_date => $reservation_end_date,
	action => :action);
    end;
  </querytext>
</fullquery>


</queryset>
