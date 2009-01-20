-- 
-- PL/SQL code for object type crs_request
-- @author  Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-09
-- @cvs-id $Id$

create or replace package crs_request 
as 

    function new (
        request_id                       in crs_requests.REQUEST_ID%TYPE  default NULL ,
	repeat_template_id		 in crs_requests.REPEAT_TEMPLATE_ID%TYPE ,
	repeat_template_p		 in crs_requests.REPEAT_TEMPLATE_P%TYPE ,
        name                             in crs_requests.NAME%TYPE  ,
        description                      in crs_requests.DESCRIPTION%TYPE  ,
        status                           in crs_requests.STATUS%TYPE  ,
        reserved_by                      in crs_requests.RESERVED_BY%TYPE  ,
        requested_by                     in crs_requests.REQUESTED_BY%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'acs_object',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        package_id                       in acs_objects.OBJECT_ID%type default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_requests.request_id%TYPE; 

    procedure del (
        request_id                       crs_requests.request_id%TYPE
    );

    function name (
        request_id                       crs_requests.request_id%TYPE
    ) return varchar2;

end crs_request;
/
show errors

create or replace package body crs_request 
as 
    function new (
        request_id                       in crs_requests.REQUEST_ID%TYPE  default NULL ,
	repeat_template_id		 in crs_requests.REPEAT_TEMPLATE_ID%TYPE ,
	repeat_template_p		 in crs_requests.REPEAT_TEMPLATE_P%TYPE ,
        name                             in crs_requests.NAME%TYPE  ,
        description                      in crs_requests.DESCRIPTION%TYPE  ,
        status                           in crs_requests.STATUS%TYPE  ,
        reserved_by                      in crs_requests.RESERVED_BY%TYPE  ,
        requested_by                     in crs_requests.REQUESTED_BY%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'acs_object',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        package_id                       in acs_objects.OBJECT_ID%type default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_requests.request_id%TYPE
    is
        v_request_id crs_requests.request_id%TYPE;        
    begin

        v_request_id := acs_object.new (
           OBJECT_ID => request_id,
            OBJECT_TYPE  => object_type,
            CREATION_DATE  => creation_date,
            CREATION_USER  => creation_user,
            CREATION_IP  => creation_ip,
            CONTEXT_ID  => context_id
        );

        insert into crs_requests (
            request_id,
	    repeat_template_id,
	    repeat_template_p,
            name,
            description,
            status,
            reserved_by,
            requested_by,
            package_id
        ) values (
            v_request_id,
	    new.repeat_template_id,
	    new.repeat_template_p,
            new.name,
            new.description,
            new.status,
            new.reserved_by,
            new.requested_by,
            new.package_id
        ); 

	return v_request_id;
    end new; 

    procedure del (
        request_id                       crs_requests.request_id%TYPE
    )
    is
    begin
	delete from crs_events where request_id = del.request_id;
        delete from crs_requests where request_id = del.request_id;
        acs_object.del(del.request_id);
    end del;

    function name (
        request_id                       crs_requests.request_id%TYPE
    ) return varchar2
    is
    begin
        return 'crs_request '|| request_id;
    end name;
end crs_request;
/
show errors

commit;





