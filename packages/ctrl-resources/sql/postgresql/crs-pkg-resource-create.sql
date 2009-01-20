-- 
-- PL/PGSQL code for object type crs_resource
-- @author  Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-09
-- @cvs-id $Id$

select define_function_args('ctrl_resource__new','resource_id:null,name,description,resource_category_id,enabled_p:t,services,property_tag,package_id,owner_id:null,
	quantity:1, parent_resource_id:null, object_type:crs_resource, creation_date:now(), creation_user:null, creation_ip:null, contact_id:null');

create or replace function crs_resource__new(integer,varchar,varchar,integer,boolean,varchar,varchar,integer,integer,integer,integer,varchar,timestamptz,integer,varchar,integer)
returns integer as '
end;' language 'plpgsql';


create or replace package crs_resource
as 
    function new (
        resource_id                      in crs_resources.RESOURCE_ID%TYPE  default NULL ,
        name                             in crs_resources.NAME%TYPE  ,
        description                      in crs_resources.DESCRIPTION%TYPE  ,
        resource_category_id             in crs_resources.RESOURCE_CATEGORY_ID%TYPE  ,
        enabled_p                        in crs_resources.ENABLED_P%TYPE  default 't' ,
        services                         in crs_resources.SERVICES%TYPE  ,
        property_tag                     in crs_resources.PROPERTY_TAG%TYPE  ,
        package_id                       in crs_resources.PACKAGE_ID%TYPE  ,
        owner_id                         in crs_resources.owner_id%TYPE default null,
        quantity                         in crs_resources.quantity%TYPE default 1,
        parent_resource_id               in crs_resources.parent_resource_id%TYPE default null,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'crs_resource',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_resources.resource_id%TYPE; 

    procedure del (
        resource_id                      crs_resources.resource_id%TYPE
    );

    function name (
        resource_id                      crs_resources.resource_id%TYPE
    ) return varchar2;

end crs_resource;
/
show errors

create or replace package body crs_resource 
as 
    function new (
        resource_id                      in crs_resources.RESOURCE_ID%TYPE  default NULL ,
        name                             in crs_resources.NAME%TYPE  ,
        description                      in crs_resources.DESCRIPTION%TYPE  ,
        resource_category_id             in crs_resources.RESOURCE_CATEGORY_ID%TYPE  ,
        enabled_p                        in crs_resources.ENABLED_P%TYPE  default 't',
        services                         in crs_resources.SERVICES%TYPE,
        property_tag                     in crs_resources.PROPERTY_TAG%TYPE  ,
        package_id                       in crs_resources.PACKAGE_ID%TYPE  ,
        owner_id                         in crs_resources.owner_id%TYPE default null,
        quantity                         in crs_resources.quantity%TYPE default 1,
        parent_resource_id               in crs_resources.parent_resource_id%TYPE default null,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE  default 'crs_resource',
        creation_date                    in acs_objects.CREATION_DATE%TYPE  default sysdate,
        creation_user                    in acs_objects.CREATION_USER%TYPE  default null,
        creation_ip                      in acs_objects.CREATION_IP%TYPE  default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE  default null
    ) return crs_resources.resource_id%TYPE
    is
        v_resource_id crs_resources.resource_id%TYPE;        
    begin

        v_resource_id := acs_object.new (
            OBJECT_ID => resource_id,
            OBJECT_TYPE  => object_type,
            CREATION_DATE  => creation_date,
            CREATION_USER  => creation_user,
            CREATION_IP  => creation_ip,
            CONTEXT_ID  => context_id
        );

        insert into crs_resources (
            resource_id,
            name,
            description,
            resource_category_id,
            enabled_p,
            services,
            property_tag,
            package_id ,
            parent_resource_id,
            owner_id, 
            quantity ,
            resource_type 
        ) values (
            v_resource_id,
            new.name,
            new.description,
            new.resource_category_id,
            new.enabled_p,
            new.services,
            new.property_tag,
            new.package_id,
            new.parent_resource_id,
            new.owner_id, 
            new.quantity, 
            new.object_type
        ); 

        return v_resource_id;

    end new; 

    procedure del (
        resource_id                      crs_resources.resource_id%TYPE
    )
    is
    begin 
        delete from crs_resources where resource_id = del.resource_id;
        acs_object.del(del.resource_id);
    end del;

    function name (
        resource_id                      crs_resources.resource_id%TYPE
    ) return varchar2
    is
    begin
        return 'crs_resource '|| resource_id;
    end name;
end crs_resource;
/
show errors

commit;
