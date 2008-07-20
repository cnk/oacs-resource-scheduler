-- PL/SQL code for object type ctrl_ccal_profile
-- @author  Sung Hong (shhong@mednet.ucla.edu)
-- @creation-date 2006-02-27
-- @cvs-id $Id$


create or replace package ctrl_ccal_profile
as
    function new (
	object_id                        in acs_objects.OBJECT_ID%TYPE     default null,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE   default 'ctrl_ccal_profile',
        creation_date                    in acs_objects.CREATION_DATE%TYPE default sysdate,
	creation_ip                      in acs_objects.CREATION_IP%TYPE   default null,
        creation_user                    in acs_objects.CREATION_USER%TYPE default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE    default null,
    	profile_name			 in ccal_profiles.PROFILE_NAME%TYPE,
	owner_id			 in ccal_profiles.OWNER_ID%TYPE,
	package_id			 in ccal_profiles.PACKAGE_ID%TYPE  default null
        ) return ccal_profiles.profile_id%TYPE;

    procedure del (
        profile_id                       ccal_profiles.profile_id%TYPE
    );
end ctrl_ccal_profile;
/
show errors


create or replace package body ctrl_ccal_profile
as
    function new (
	object_id                        in acs_objects.OBJECT_ID%TYPE     default null,
        object_type                      in acs_objects.OBJECT_TYPE%TYPE   default 'ctrl_ccal_profile',
        creation_date                    in acs_objects.CREATION_DATE%TYPE default sysdate,
	creation_ip                      in acs_objects.CREATION_IP%TYPE   default null,
        creation_user                    in acs_objects.CREATION_USER%TYPE default null,
        context_id                       in acs_objects.CONTEXT_ID%TYPE    default null,
    	profile_name			 in ccal_profiles.PROFILE_NAME%TYPE,
	owner_id			 in ccal_profiles.OWNER_ID%TYPE,
	package_id			 in ccal_profiles.PACKAGE_ID%TYPE  default null
        ) return ccal_profiles.profile_id%TYPE
    is
        v_profile_id ccal_profiles.profile_id%TYPE;
    begin
	v_profile_id := acs_object.new (
	    OBJECT_ID      => object_id,
            OBJECT_TYPE    => object_type,
            CREATION_DATE  => creation_date,
            CREATION_IP    => creation_ip,
            CREATION_USER  => creation_user,
            CONTEXT_ID     => context_id
        );
        insert into ccal_profiles (
            profile_id,
            profile_name,
            owner_id,
            package_id
        ) values (
            v_profile_id,
            new.profile_name,
            new.owner_id,
            new.package_id
        );
	return v_profile_id;
    end new;

    procedure del (
        profile_id                           ccal_profiles.profile_id%TYPE
    )
    is
    begin
        delete from ccal_profiles where profile_id = del.profile_id;
        acs_object.del(del.profile_id);
    end del;
end ctrl_ccal_profile;
/
show errors

