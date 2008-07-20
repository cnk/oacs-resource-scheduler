-- The set of tables to handle user profiles
-- @creation-date 2006-02-24
-- @author KH
-- @cvs-id $Id$

create table ccal_profiles (
    profile_id            integer 
        constraint ccal_profiles_profile_id_pk primary key
        constraint ccal_profiles_profile_id_fk references acs_objects (object_id),
    profile_name          varchar2(50)
        constraint ccal_profiles_name_id_nn not null,
    owner_id              integer 
        constraint ccal_profiles_owner_id_nn not null
        constraint ccal_profiles_owner_id_fk references persons(person_id),
    package_id            integer,
    email_period          varchar2(10),
    email_day             varchar2(10),
    email_sent		  date 
);

-- Use to store the specifying the filters for the profile
-- Options are either to filter by particular calendar, calendar and categories, or just categories
create table ccal_profile_filters (
    filter_id                 integer 
        constraint ccal_prf_ftr_filter_id_pk primary key,
    profile_id                integer 
        constraint ccal_prf_ftr_profile_id_fk references ccal_profiles(profile_id) ,
    profile_type              varchar2(25) default 'calendar' 
        constraint ccal_prf_ftr_profile_type_ck check (profile_type in ('calendar','category', 'cal_category')),
    cal_id               integer 
        constraint ccal_prf_ftr_cal_id_fk references ctrl_calendars(cal_id),
    category_id               integer 
        constraint ccal_prf_ftr_category_id_fk references ctrl_categories(category_id)
);

-- Use to create filter_id values
create sequence ccal_profile_filter_id_seq start with 1;







