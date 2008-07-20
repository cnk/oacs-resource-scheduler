-- /packages/ctrl-calendar/sql/oracle/cc-tables-create.sql
-- 
-- The CTRL Calendar Package 
-- UI for Displaying Events
--
-- @creation-date 4/1/2007
-- @author CTRL
-- @cvs-id $Id$
--

create table ctrl_calendar_templates (
    template_id   integer  
        constraint ctrl_cal_tpls_template_id_pk primary key,
    name          varchar2(25)
        constraint ctrl_cal_tpls_name_nn not null,
    template      clob     
);

create table ctrl_calendars (
    cal_id         integer   
        constraint ctrl_cal_cal_id_pk primary key 
        constraint ctrl_cal_cal_id_fk references acs_objects(object_id),
    cal_name       varchar2(255) 	  
        constraint ctrl_cal_name_nn not null,
    description    varchar2(4000) ,
    owner_id       integer 
        constraint ctrl_cal_owner_id_fk references persons(person_id),
    object_id     integer
        constraint ctrl_cal_object_id_nn not null
        constraint ctrl_cal_object_id_fk references acs_objects(object_id),
    package_id        integer
    	constraint ctrl_cal_package_id_fk references acs_objects(object_id),
    -- the view preferences for the calendar,
    template_id   integer 
        constraint ctrl_cal_template_id_fk references ctrl_calendar_templates(template_id)
);

create table ctrl_calendar_user_prefs (
    cal_id        integer
        constraint ctrl_cal_prefs_cal_id_fk references ctrl_calendars(cal_id),
    user_id       integer 
        constraint ctrl_cal_prefs_user_id_fk references users(user_id)
        constraint ctrl_cal_prefs_user_id_nn not null,
    pref_view     clob,
    constraint ctrl_cal_prefs_cal_user_id_pk primary key(cal_id, user_id)
);

create table ctrl_calendar_filters (
    cal_filter_id    integer 
        constraint ctrl_cal_filters_id_pk primary key ,
    filter_name	     varchar(100)
	constraint ctrl_cal_filters_name_nn not null,
    description	     varchar(1000),
    cal_id         integer
        constraint ctrl_cal_filters_cal_id_nn not null
        constraint ctrl_cal_filters_cal_id_fk references ctrl_calendars(cal_id),
    -- current filter types are object or category
    filter_type      varchar2(15) 
        constraint ctrl_cal_filters_fl_type_nn not null
);

create table ctrl_cal_filter_object_map (
    cal_filter_id integer
	constraint ctrl_cal_fil_obj_id_nn not null
	constraint ctrl_cal_fil_obj_id_fk references ctrl_calendar_filters(cal_filter_id),
    -- the object, category to filter
    object_id integer 
        constraint ctrl_cal_filters_obj_id_fk references acs_objects(object_id),
    color varchar(15),
    constraint cc_fo_pk primary key (cal_filter_id,object_id,color)
);

create table ctrl_calendar_event_map (
	cal_id		integer
			constraint cc_em_cal_id_nn not null
			constraint cc_em_cal_id_fk references ctrl_calendars(cal_id),
	event_id	integer
			constraint cc_em_event_id_nn not null
			constraint cc_em_event_id_fk references ctrl_events(event_id),
	constraint cc_em_pk primary key (cal_id, event_id)
);

create table ctrl_calendar_event_categories (
	event_id	integer	
			constraint cc_ec_event_id_nn not null
			constraint cc_ec_event_id_fk references ctrl_events(event_id),
	category_id	integer	
			constraint cc_ec_category_id_nn not null
			constraint cc_ec_category_id_fk references ctrl_categories(category_id),
	constraint cc_ec_pk primary key (event_id, category_id)
);

create table ctrl_calendar_event_downloads (
	event_id	integer
			constraint cce_download_event_id_nn not null
			constraint cce_download_event_id_fk references ctrl_events(event_id),
	email		varchar2(250)
			constraint cce_download_email_nn not null,
	download_date	date default sysdate,
	constraint cce_download_pk primary key (event_id, email)
);


/* XML Structures:

<Preferences>
    <view_schedule>daily,weekly,monthly,yearly</view_schedule>      
</Preferences>

*/
