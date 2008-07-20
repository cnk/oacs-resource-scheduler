-- 
-- PL/SQL code for object type crs_image
--
-- @author  Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-09
-- @cvs-id $Id$

create or replace package crs_image 
as 

    function new (
        image_id                         in crs_images.IMAGE_ID%TYPE  default NULL ,
        resource_id                      in crs_images.RESOURCE_ID%TYPE  ,
	image_name			 in crs_images.IMAGE_NAME%TYPE ,
        image_width                      in crs_images.IMAGE_WIDTH%TYPE  ,
        image_height                     in crs_images.IMAGE_HEIGHT%TYPE  ,
        image_file_type                  in crs_images.IMAGE_FILE_TYPE%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'acs_object',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_images.image_id%TYPE; 

    procedure del (
        image_id                         crs_images.image_id%TYPE
    );

    function name (
        image_id                         crs_images.image_id%TYPE
    ) return varchar2;

end crs_image;
/ 
show errors

create or replace package body crs_image 
as 
    function new (
        image_id                         in crs_images.IMAGE_ID%TYPE  default NULL ,
        resource_id                      in crs_images.RESOURCE_ID%TYPE  ,
	image_name			 in crs_images.IMAGE_NAME%TYPE ,
        image_width                      in crs_images.IMAGE_WIDTH%TYPE  ,
        image_height                     in crs_images.IMAGE_HEIGHT%TYPE  ,
        image_file_type                  in crs_images.IMAGE_FILE_TYPE%TYPE  ,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'acs_object',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_images.image_id%TYPE
    is
        v_image_id crs_images.image_id%TYPE;        
    begin

        v_image_id := acs_object.new (
            OBJECT_ID => image_id,
            OBJECT_TYPE  => object_type,
            CREATION_DATE  => creation_date,
            CREATION_USER  => creation_user,
            CREATION_IP  => creation_ip,
            CONTEXT_ID  => context_id
        );

        insert into crs_images (
            image_id,
            resource_id,
	    image_name,
            image_width,
            image_height,
            image_file_type
        ) values (
            v_image_id,
            new.resource_id,
	    new.image_name,
            new.image_width,
            new.image_height,
            new.image_file_type
        ); 

	return v_image_id;
    end new; 

    procedure del (
        image_id                         crs_images.image_id%TYPE
    )
    is
    begin 
        delete from crs_images where image_id = del.image_id;
        acs_object.del(del.image_id);
    end del;

    function name (
        image_id                         crs_images.image_id%TYPE
    ) return varchar2
    is
    begin
        return 'crs_image '|| image_id;
    end name;
end crs_image;
/
show errors

commit;
