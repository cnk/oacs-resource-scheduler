-- 
-- PL/SQL code for crs_policy
-- @author  Jianming He
-- @creation-date 2006-08-03
-- @cvs-id $Id$

create or replace package crs_policy 
as 
    function get_policy (
	user_id 			 in users.USER_ID%TYPE,
	resource_id			 in crs_reservable_resources.RESOURCE_ID%TYPE
    ) return crs_resv_resource_policies.POLICY_ID%TYPE;

    function get_policy_by_group_id (
	group_id 			 in groups.GROUP_ID%TYPE,
	resource_id			 in crs_reservable_resources.RESOURCE_ID%TYPE
    ) return crs_resv_resource_policies.POLICY_ID%TYPE;

    function check_compliance (
	policy_id 			 in crs_resv_resource_policies.POLICY_ID%TYPE,
	request_date		 	 DATE,
	reservation_start_date		 DATE,
	reservation_end_date		 DATE,
	action				 varchar2
    ) return NUMBER;

end crs_policy;
/
show errors

create or replace package body crs_policy 
as 
    function get_policy (
	user_id 			 in users.USER_ID%TYPE,
	resource_id			 in crs_reservable_resources.RESOURCE_ID%TYPE
    ) return crs_resv_resource_policies.POLICY_ID%TYPE
    is
      	v_group_id groups.GROUP_ID%TYPE;
      	v_policy_id crs_resv_resource_policies.POLICY_ID%TYPE := null;
	v_flag number;
	cursor v_cursor is 
	  select b.group_id, b.policy_id
   	  from   crs_resv_resource_policies a, crs_resv_resource_pol_assns b
   	  where  a.resource_id = get_policy.resource_id and 
	         a.policy_id = b.policy_id 
          order by a.priority_level desc; 

    begin
	-- select policy_id with highest priority_level
	open v_cursor;
	loop
	begin
	    fetch v_cursor into v_group_id, v_policy_id;
	    select 1 into v_flag
	    from dual where exists (select 1
	    from   group_approved_member_map
	    where  member_id = get_policy.user_id and
                   group_id = v_group_id);
 	    exit when v_flag = 1;
	    exception when no_data_found then return null;
	end;
	end loop;
        close v_cursor;

	return v_policy_id;
    end get_policy; 

    function get_policy_by_group_id (
	group_id 			 in groups.GROUP_ID%TYPE,
	resource_id			 in crs_reservable_resources.RESOURCE_ID%TYPE
    ) return crs_resv_resource_policies.POLICY_ID%TYPE
    is
      	v_policy_id crs_resv_resource_policies.POLICY_ID%TYPE;
    begin
	-- select policy_id with highest priority_level
	select a.policy_id into v_policy_id
	from   crs_resv_resource_policies a, crs_resv_resource_pol_assns b
	where  b.group_id = get_policy_by_group_id.group_id and 
	       b.policy_id = a.policy_id and 
	       a.resource_id = get_policy_by_group_id.resource_id and 
	       a.priority_level >= ANY (select a2.priority_level 
				        from   crs_resv_resource_policies a2, crs_resv_resource_pol_assns b2
				        where  b2.group_id = get_policy_by_group_id.group_id and 
					       b2.policy_id = a2.policy_id and 
					       a2.resource_id = get_policy_by_group_id.resource_id);

	return v_policy_id;
    end get_policy_by_group_id; 

    function check_compliance (
	policy_id 			 in crs_resv_resource_policies.POLICY_ID%TYPE,
	request_date		 	 DATE,
	reservation_start_date		 DATE,
	reservation_end_date		 DATE,
	action				 varchar2
    ) return NUMBER
    is
	v_lrd    crs_resv_resource_policies.latest_resv_date%TYPE;
	v_tiard  crs_resv_resource_policies.time_interval_after_rsv_dte%TYPE;
	v_tibsd  crs_resv_resource_policies.time_interval_before_start_dte%TYPE;
	v_rpbsd  crs_resv_resource_policies.resv_period_before_start_date%TYPE;
    begin
	-- get policy details
	select latest_resv_date, time_interval_after_rsv_dte, time_interval_before_start_dte, 
	       resv_period_before_start_date into v_lrd, v_tiard, v_tibsd, v_rpbsd
        from   crs_resv_resource_policies
        where  policy_id = check_compliance.policy_id;

	if (action = 'new') then
	    -- reservation end date cannot be after the end date in policy
	    if (check_compliance.reservation_end_date > v_lrd) then
	        return 0;
	    -- reservation cannot be made after reservation_start_date - interval
	    elsif (check_compliance.request_date > check_compliance.reservation_start_date - v_rpbsd/86400) then
		return 0;
	    else
		return 1;
	    end if;
	else
	    -- modification cannot be made after request_date + interval
	    if (sysdate > check_compliance.request_date + v_tiard/86400) then
		return 0;
	    -- modification cannot be made after reservation_start_date - interval
	    elsif (sysdate > check_compliance.reservation_start_date - v_tibsd/86400) then
		return 0;
	    else
		return 1;
	    end if;
	end if;

    end check_compliance;			
end crs_policy;
/
show errors

commit;





