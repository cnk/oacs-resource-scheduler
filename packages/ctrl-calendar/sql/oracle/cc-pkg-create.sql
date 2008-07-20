-- 
-- PL/SQL code for object type ctrl_calendar
-- @author  Jeff Wang (jeff@ctrl.ucla.edu)
-- @creation-date 2005-12-19
-- @cvs-id $Id$


create or replace package ctrl_calendar 
as 
    function new (
        cal_id                           in ctrl_calendars.CAL_ID%TYPE  default NULL ,
        cal_name                         in ctrl_calendars.CAL_NAME%TYPE  ,
        description                      in ctrl_calendars.DESCRIPTION%TYPE  ,
        owner_id                         in ctrl_calendars.OWNER_ID%TYPE  ,
        object_id                        in ctrl_calendars.OBJECT_ID%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'ctrl_calendar',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null,
        package_id                       in ctrl_calendars.PACKAGE_ID%TYPE  default null
    ) return ctrl_calendars.cal_id%TYPE; 

    procedure del (
        cal_id                           ctrl_calendars.cal_id%TYPE
    );

    function name (
        cal_id                           ctrl_calendars.cal_id%TYPE
    ) return varchar2;

end ctrl_calendar;
/
show errors


create or replace package body ctrl_calendar 
as 
    function new (
        cal_id                           in ctrl_calendars.CAL_ID%TYPE  default NULL ,
        cal_name                         in ctrl_calendars.CAL_NAME%TYPE  ,
        description                      in ctrl_calendars.DESCRIPTION%TYPE  ,
        owner_id                         in ctrl_calendars.OWNER_ID%TYPE  ,
        object_id                        in ctrl_calendars.OBJECT_ID%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'ctrl_calendar',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null,
        package_id                       in ctrl_calendars.PACKAGE_ID%TYPE  default null
    ) return ctrl_calendars.cal_id%TYPE
    is
        v_cal_id ctrl_calendars.cal_id%TYPE;        
    begin

        v_cal_id := acs_object.new (
            OBJECT_ID => cal_id,
            OBJECT_TYPE  => object_type,
            CREATION_DATE  => creation_date,
            CREATION_USER  => creation_user,
            CREATION_IP  => creation_ip,
            CONTEXT_ID  => context_id
        );

        insert into ctrl_calendars (
            cal_id,
            cal_name,
            description,
            owner_id,
            object_id,
	    package_id
        ) values (
            v_cal_id,
            new.cal_name,
            new.description,
            new.owner_id,
            new.object_id,
	    new.package_id
        ); 

     return v_cal_id;	
    end new; 

    procedure del (
        cal_id                           ctrl_calendars.cal_id%TYPE
    )
    is
    begin 
	delete from ctrl_calendar_event_categories where event_id in (select event_id from ctrl_events where event_object_id=del.cal_id);

	FOR event in (select event_id from ctrl_events where event_object_id=del.cal_id) LOOP
		ctrl_event.del(event.event_id);
	END LOOP;
	delete from ccal_profile_filters where cal_id = del.cal_id;
	delete from ctrl_calendars where cal_id = del.cal_id;
        acs_object.del(del.cal_id);
    end del;

    function name (
        cal_id                           ctrl_calendars.cal_id%TYPE
    ) return varchar2
    is
	cal_name ctrl_calendars.cal_name%TYPE;
    begin
	select cal_name into cal_name from ctrl_calendars where cal_id = name.cal_id;

	return cal_name;
    end name;

end ctrl_calendar;
/
show errors
commit;
