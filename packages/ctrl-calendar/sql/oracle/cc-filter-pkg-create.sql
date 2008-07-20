-- 
-- PL/SQL code for object type ctrl_calendar_filter
-- @author  kellie@ctrl.ucla.edu
-- @creation-date 08/03/2007
-- @cvs-id $Id$


create or replace package ctrl_calendar_filter
as 
   function new (
	cal_filter_id 			 in ctrl_calendar_filters.CAL_FILTER_ID%TYPE default NULL,
	filter_name 			 in ctrl_calendar_filters.FILTER_NAME%TYPE,
	description 			 in ctrl_calendar_filters.DESCRIPTION%TYPE,
	cal_id	 			 in ctrl_calendar_filters.CAL_ID%TYPE,
	filter_type 			 in ctrl_calendar_filters.FILTER_TYPE%TYPE,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'ctrl_calendar_filter',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null,
        package_id                       in acs_objects.PACKAGE_ID%TYPE  default null
   ) return ctrl_calendar_filters.cal_filter_id%TYPE;

   procedure del (
	cal_filter_id in ctrl_calendar_filters.cal_filter_id%TYPE
   );

end ctrl_calendar_filter;
/
show errors

create or replace package body ctrl_calendar_filter
as 
   function new (
	cal_filter_id 			 in ctrl_calendar_filters.CAL_FILTER_ID%TYPE default NULL,
	filter_name 			 in ctrl_calendar_filters.FILTER_NAME%TYPE,
	description 			 in ctrl_calendar_filters.DESCRIPTION%TYPE,
	cal_id	 			 in ctrl_calendar_filters.CAL_ID%TYPE,
	filter_type 			 in ctrl_calendar_filters.FILTER_TYPE%TYPE,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'ctrl_calendar_filter',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null,
        package_id                       in acs_objects.PACKAGE_ID%TYPE  default null
   ) return ctrl_calendar_filters.cal_filter_id%TYPE
   is
	v_cal_filter_id ctrl_calendar_filters.cal_filter_id%TYPE;
   begin
	v_cal_filter_id := acs_object.new (
	   OBJECT_ID => cal_filter_id,
	   OBJECT_TYPE => object_type,
	   CREATION_DATE => creation_date,
	   CREATION_USER => creation_user,
	   CREATION_IP => creation_ip,
	   CONTEXT_ID => context_id,
	   PACKAGE_ID => package_id
	);
	
	insert into ctrl_calendar_filters (
	   cal_filter_id,
	   filter_name,
	   description,
	   cal_id,
	   filter_type
	) values (
	   v_cal_filter_id,
	   new.filter_name,
	   new.description,
	   new.cal_id,
	   new.filter_type
	);
	
	return v_cal_filter_id;
   end new;

   procedure del (
	cal_filter_id in ctrl_calendar_filters.cal_filter_id%TYPE
   )
   is 
   begin
   	delete from ctrl_cal_filter_object_map where cal_filter_id = del.cal_filter_id;
	delete from ctrl_calendar_filters where cal_filter_id = del.cal_filter_id;
	acs_object.del(del.cal_filter_id);
   end del;
end ctrl_calendar_filter;
/
show errors
commit;
