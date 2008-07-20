-- 
-- PL/SQL code for object type crs_room
-- @author  Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-09
-- @cvs-id $Id$

create or replace package crs_room 
as 
    function new (
        room_id                          in crs_rooms.ROOM_ID%TYPE  default NULL ,
        name                             in crs_resources.NAME%TYPE  ,
        description                      in crs_resources.DESCRIPTION%TYPE  ,
        resource_category_id             in crs_resources.RESOURCE_CATEGORY_ID%TYPE  ,
        enabled_p                        in crs_resources.ENABLED_P%TYPE  default 't' ,
        services                         in crs_resources.SERVICES%TYPE  ,
        property_tag                     in crs_resources.PROPERTY_TAG%TYPE  ,
        package_id                       in crs_resources.PACKAGE_ID%TYPE  ,
        owner_id                         in crs_resources.OWNER_ID%TYPE default null,
        parent_resource_id               in crs_resources.PARENT_RESOURCE_ID%TYPE default null,
        how_to_reserve                   in crs_reservable_resources.HOW_TO_RESERVE%TYPE  ,
        approval_required_p              in crs_reservable_resources.APPROVAL_REQUIRED_P%TYPE  default 'f',
        address_id                       in crs_reservable_resources.ADDRESS_ID%TYPE  ,
        department_id                    in crs_reservable_resources.DEPARTMENT_ID%TYPE  ,
        floor                            in crs_reservable_resources.FLOOR%TYPE  ,
        room                             in crs_reservable_resources.ROOM%TYPE  ,
        gis                              in crs_reservable_resources.GIS%TYPE  ,
	color				 in crs_reservable_resources.COLOR%TYPE, 
        reservable_p                     in crs_reservable_resources.RESERVABLE_P%TYPE ,
        reservable_p_note                in crs_reservable_resources.RESERVABLE_P_NOTE%TYPE ,
        special_request_p                in crs_reservable_resources.SPECIAL_REQUEST_P%TYPE ,
	new_email_notify_list            in crs_reservable_resources.NEW_EMAIL_NOTIFY_LIST%TYPE default null,
	update_email_notify_list         in crs_reservable_resources.UPDATE_EMAIL_NOTIFY_LIST%TYPE default null,
        capacity                         in crs_rooms.CAPACITY%TYPE  ,
        dimensions_width                 in crs_rooms.DIMENSIONS_WIDTH%TYPE  ,
        dimensions_length                in crs_rooms.DIMENSIONS_LENGTH%TYPE  ,
        dimensions_height                in crs_rooms.DIMENSIONS_HEIGHT%TYPE  ,
        dimensions_unit                  in crs_rooms.DIMENSIONS_UNIT%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'crs_room',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_rooms.room_id%TYPE; 

    procedure del (
        room_id                          crs_rooms.room_id%TYPE
    );

    function name (
        room_id                          crs_rooms.room_id%TYPE
    ) return varchar2;

end crs_room;
/
show errors

create or replace package body crs_room 
as 
    function new (
        room_id                          in crs_rooms.ROOM_ID%TYPE  default NULL ,
        name                             in crs_resources.NAME%TYPE  ,
        description                      in crs_resources.DESCRIPTION%TYPE  ,
        resource_category_id             in crs_resources.RESOURCE_CATEGORY_ID%TYPE  ,
        enabled_p                        in crs_resources.ENABLED_P%TYPE  default 't' ,
        services                         in crs_resources.SERVICES%TYPE  ,
        property_tag                     in crs_resources.PROPERTY_TAG%TYPE  ,
        package_id                       in crs_resources.PACKAGE_ID%TYPE  ,
        owner_id                         in crs_resources.OWNER_ID%TYPE default null,
        parent_resource_id               in crs_resources.PARENT_RESOURCE_ID%TYPE default null,
        how_to_reserve                   in crs_reservable_resources.HOW_TO_RESERVE%TYPE  ,
        approval_required_p              in crs_reservable_resources.APPROVAL_REQUIRED_P%TYPE  default 'f',
        address_id                       in crs_reservable_resources.ADDRESS_ID%TYPE  ,
        department_id                    in crs_reservable_resources.DEPARTMENT_ID%TYPE  ,
        floor                            in crs_reservable_resources.FLOOR%TYPE  ,
        room                             in crs_reservable_resources.ROOM%TYPE  ,
        gis                              in crs_reservable_resources.GIS%TYPE  ,
	color				 in crs_reservable_resources.COLOR%TYPE ,
        reservable_p                     in crs_reservable_resources.RESERVABLE_P%TYPE ,
        reservable_p_note                in crs_reservable_resources.RESERVABLE_P_NOTE%TYPE ,
        special_request_p                in crs_reservable_resources.SPECIAL_REQUEST_P%TYPE ,
	new_email_notify_list            in crs_reservable_resources.NEW_EMAIL_NOTIFY_LIST%TYPE default null,
	update_email_notify_list         in crs_reservable_resources.UPDATE_EMAIL_NOTIFY_LIST%TYPE default null,
        capacity                         in crs_rooms.CAPACITY%TYPE  ,
        dimensions_width                 in crs_rooms.DIMENSIONS_WIDTH%TYPE  ,
        dimensions_length                in crs_rooms.DIMENSIONS_LENGTH%TYPE  ,
        dimensions_height                in crs_rooms.DIMENSIONS_HEIGHT%TYPE  ,
        dimensions_unit                  in crs_rooms.DIMENSIONS_UNIT%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'crs_room',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_rooms.room_id%TYPE
    is
        v_room_id crs_rooms.room_id%TYPE;        
    begin
        v_room_id := crs_reservable_resource.new (
		RESOURCE_ID  		=> room_id,
	    	NAME 			=> name,
	    	DESCRIPTION 		=> description,
	 	RESOURCE_CATEGORY_ID 	=> resource_category_id,
		ENABLED_P 		=> enabled_p,
		SERVICES 		=> services,
		PROPERTY_TAG 		=> property_tag,
		PACKAGE_ID 		=> package_id,
                OWNER_ID                => owner_id,
                PARENT_RESOURCE_ID      => parent_resource_id,
		HOW_TO_RESERVE		=> how_to_reserve,
		APPROVAL_REQUIRED_P	=> approval_required_p,
		ADDRESS_ID		=> address_id,
		DEPARTMENT_ID		=> department_id,
		FLOOR			=> floor,
		ROOM			=> room,
		GIS			=> gis,
		NEW_EMAIL_NOTIFY_LIST   => new_email_notify_list,
		UPDATE_EMAIL_NOTIFY_LIST=> update_email_notify_list,
		COLOR			=> color,
                RESERVABLE_P            => reservable_p,
                RESERVABLE_P_NOTE       => reservable_p_note,
                SPECIAL_REQUEST_P       => special_request_p,
            	OBJECT_TYPE  		=> object_type,
            	CREATION_DATE  		=> creation_date,
            	CREATION_USER  		=> creation_user,
            	CREATION_IP  		=> creation_ip,
            	CONTEXT_ID  		=> context_id
        );

        insert into crs_rooms (
            room_id,
            capacity,
            dimensions_width,
            dimensions_length,
            dimensions_height,
            dimensions_unit
        ) values (
            v_room_id,
            new.capacity,
            new.dimensions_width,
            new.dimensions_length,
            new.dimensions_height,
            new.dimensions_unit
        ); 
	return v_room_id;

    end new; 

    procedure del (
        room_id                          crs_rooms.room_id%TYPE
    )
    is
    begin 	
        delete from crs_rooms where room_id = del.room_id;
	delete from crs_resources where parent_resource_id = del.room_id;
	crs_reservable_resource.del(del.room_id);
        acs_object.del(del.room_id);
    end del;

    function name (
        room_id                          crs_rooms.room_id%TYPE
    ) return varchar2
    is
    begin
        return 'crs_room '|| room_id;
    end name;
end crs_room;
/
show errors

commit;
