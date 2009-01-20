-- 
-- PL/SQL code for object type crs_event
--
-- @author  Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-09
-- @cvs-id $Id$

create or replace package crs_event 
as 
    function new (
        event_id                         in crs_events.EVENT_ID%TYPE,
        request_id                       in crs_events.REQUEST_ID%TYPE  ,
        status                           in crs_events.STATUS%TYPE  ,
        reserved_by                      in crs_events.RESERVED_BY%TYPE  ,
        date_reserved                    in crs_events.DATE_RESERVED%TYPE  default sysdate,
        event_code                       in crs_events.EVENT_CODE%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'ctrl_event',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_events.event_id%TYPE; 

    procedure del (
        event_id                         crs_events.event_id%TYPE
    );

    function name (
        event_id                         crs_events.event_id%TYPE
    ) return varchar2;

end crs_event;
/
show errors

create or replace package body crs_event 
as 
    function new (
        event_id                         in crs_events.EVENT_ID%TYPE,
        request_id                       in crs_events.REQUEST_ID%TYPE  ,
        status                           in crs_events.STATUS%TYPE  ,
        reserved_by                      in crs_events.RESERVED_BY%TYPE  ,
        date_reserved                    in crs_events.DATE_RESERVED%TYPE  default sysdate,
        event_code                       in crs_events.EVENT_CODE%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'ctrl_event',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_events.event_id%TYPE
    is
        v_event_id crs_events.event_id%TYPE;        
    begin

        insert into crs_events (
            event_id,
            request_id,
            status,
            reserved_by,
            date_reserved,
            event_code
        ) values (
            event_id,
            new.request_id,
            new.status,
            new.reserved_by,
            new.date_reserved,
            new.event_code
        ); 

	return event_id;

    end new; 

    procedure del (
        event_id                         crs_events.event_id%TYPE
    )
    is
    begin 
        delete from crs_events where event_id = del.event_id;
        ctrl_event.del(del.event_id);
    end del;

    function name (
        event_id                         crs_events.event_id%TYPE
    ) return varchar2
    is
    begin
        return 'crs_event '|| event_id;
    end name;
end crs_event;
/
show errors

commit;
