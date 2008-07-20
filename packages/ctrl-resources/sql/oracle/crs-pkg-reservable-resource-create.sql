-- 
-- PL/SQL code for object type crs_reservable_resource
-- @author  Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-09
-- @cvs-id $Id$

create or replace package crs_reservable_resource 
as 
    function new (
        resource_id                      in crs_reservable_resources.RESOURCE_ID%TYPE  default NULL ,
        name                             in crs_resources.NAME%TYPE  ,
        description                      in crs_resources.DESCRIPTION%TYPE  ,
        resource_category_id             in crs_resources.RESOURCE_CATEGORY_ID%TYPE  ,
        enabled_p                        in crs_resources.ENABLED_P%TYPE  default 't' ,
        services                         in crs_resources.SERVICES%TYPE  ,
        property_tag                     in crs_resources.PROPERTY_TAG%TYPE  ,
        package_id                       in crs_resources.PACKAGE_ID%TYPE  ,
        owner_id                         in crs_resources.OWNER_ID%TYPE default null,
        quantity                         in crs_resources.QUANTITY%TYPE default 1,
        parent_resource_id               in crs_resources.PARENT_RESOURCE_ID%TYPE default null,
        how_to_reserve                   in crs_reservable_resources.HOW_TO_RESERVE%TYPE  ,
        approval_required_p              in crs_reservable_resources.APPROVAL_REQUIRED_P%TYPE  default 'f',
        address_id                       in crs_reservable_resources.ADDRESS_ID%TYPE  ,
        department_id                    in crs_reservable_resources.DEPARTMENT_ID%TYPE  ,
        floor                            in crs_reservable_resources.FLOOR%TYPE  ,
        room                             in crs_reservable_resources.ROOM%TYPE  ,
        gis                              in crs_reservable_resources.GIS%TYPE  ,
	new_email_notify_list            in crs_reservable_resources.NEW_EMAIL_NOTIFY_LIST%TYPE default null,
	update_email_notify_list         in crs_reservable_resources.UPDATE_EMAIL_NOTIFY_LIST%TYPE default null,
	color         			 in crs_reservable_resources.COLOR%TYPE default null,
        reservable_p                     in crs_reservable_resources.RESERVABLE_P%TYPE default 't',
        reservable_p_note                in crs_reservable_resources.RESERVABLE_P_NOTE%TYPE default null,
        special_request_p                in crs_reservable_resources.SPECIAL_REQUEST_P%TYPE default 'f',
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'crs_reservable_resource',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_reservable_resources.resource_id%TYPE; 

    procedure del (
        resource_id                      crs_reservable_resources.resource_id%TYPE
    );

    function name (
        resource_id                      crs_reservable_resources.resource_id%TYPE
    ) return varchar2;

end crs_reservable_resource;
/
show errors

create or replace package body crs_reservable_resource 
as 
    function new (
        resource_id                      in crs_reservable_resources.RESOURCE_ID%TYPE  default NULL ,
        name                             in crs_resources.NAME%TYPE  ,
        description                      in crs_resources.DESCRIPTION%TYPE  ,
        resource_category_id             in crs_resources.RESOURCE_CATEGORY_ID%TYPE  ,
        enabled_p                        in crs_resources.ENABLED_P%TYPE  default 't' ,
        services                         in crs_resources.SERVICES%TYPE  ,
        property_tag                     in crs_resources.PROPERTY_TAG%TYPE  ,
        package_id                       in crs_resources.PACKAGE_ID%TYPE  ,
        owner_id                         in crs_resources.OWNER_ID%TYPE default null,
        quantity                         in crs_resources.QUANTITY%TYPE default 1,
        parent_resource_id               in crs_resources.PARENT_RESOURCE_ID%TYPE default null,
        how_to_reserve                   in crs_reservable_resources.HOW_TO_RESERVE%TYPE  ,
        approval_required_p              in crs_reservable_resources.APPROVAL_REQUIRED_P%TYPE  default 'f',
        address_id                       in crs_reservable_resources.ADDRESS_ID%TYPE  ,
        department_id                    in crs_reservable_resources.DEPARTMENT_ID%TYPE  ,
        floor                            in crs_reservable_resources.FLOOR%TYPE  ,
        room                             in crs_reservable_resources.ROOM%TYPE  ,
        gis                              in crs_reservable_resources.GIS%TYPE  ,
	new_email_notify_list            in crs_reservable_resources.NEW_EMAIL_NOTIFY_LIST%TYPE default null,
	update_email_notify_list         in crs_reservable_resources.UPDATE_EMAIL_NOTIFY_LIST%TYPE default null,
	color         			 in crs_reservable_resources.COLOR%TYPE default null,
        reservable_p                     in crs_reservable_resources.RESERVABLE_P%TYPE default 't',
        reservable_p_note                in crs_reservable_resources.RESERVABLE_P_NOTE%TYPE default null,
        special_request_p                in crs_reservable_resources.SPECIAL_REQUEST_P%TYPE default 'f',
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'crs_reservable_resource',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_reservable_resources.resource_id%TYPE
    is
        v_resource_id crs_reservable_resources.resource_id%TYPE;        
    begin

        v_resource_id := crs_resource.new (
		RESOURCE_ID  		=> resource_id,
	    	NAME 			=> name,
	    	DESCRIPTION 		=> description,
	 	RESOURCE_CATEGORY_ID 	=> resource_category_id,
		ENABLED_P 		=> enabled_p,
		SERVICES 		=> services,
		PROPERTY_TAG 		=> property_tag,
		PACKAGE_ID 		=> package_id,
                OWNER_ID                => owner_id,
                QUANTITY                => quantity,
                PARENT_RESOURCE_ID      => parent_resource_id,
            	OBJECT_TYPE  		=> object_type,
            	CREATION_DATE  		=> creation_date,
            	CREATION_USER  		=> creation_user,
            	CREATION_IP  		=> creation_ip,
            	CONTEXT_ID  		=> context_id
        );

        insert into crs_reservable_resources (
            resource_id,
            how_to_reserve,
            approval_required_p,
            address_id,
            department_id,
            floor,
            room,
            gis,
	    new_email_notify_list,
	    update_email_notify_list,
	    color,
            reservable_p,
            reservable_p_note,
            special_request_p
        ) values (
            v_resource_id,
            new.how_to_reserve,
            new.approval_required_p,
            new.address_id,
            new.department_id,
            new.floor,
            new.room,
            new.gis,
	    new.new_email_notify_list,
	    new.update_email_notify_list,
	    new.color,
            new.reservable_p,
            new.reservable_p_note,
            new.special_request_p
        ); 
	return v_resource_id;

    end new; 

    procedure del (
        resource_id                      crs_reservable_resources.resource_id%TYPE
    )
    is
	calendar number :=0;
    begin 
	FOR calendar in (select cal_id from ctrl_calendars where cal_id in (select object_id from acs_objects where context_id=del.resource_id)) LOOP
		ctrl_calendar.del(calendar.cal_id);
	END LOOP;
        delete from crs_reservable_resources where resource_id = del.resource_id;
	delete from crs_resources where resource_id = del.resource_id;
        acs_object.del(del.resource_id);
    end del;

    function name (
        resource_id                      crs_reservable_resources.resource_id%TYPE
    ) return varchar2
    is
    begin
        return 'crs_reservable_resource '|| resource_id;
    end name;
end crs_reservable_resource;
/
show errors

commit;
