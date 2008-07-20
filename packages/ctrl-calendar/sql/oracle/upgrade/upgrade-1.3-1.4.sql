-- /packages/ctrl-calendar/sql/oracle/upgrade/upgrade-1.3-1.4.sql
--
-- @creation-date 07/23/2007
--


create table ctrl_calendar_filters (
    cal_filter_id    integer
        constraint ctrl_cal_filters_id_pk primary key 
	constraint ctrl_cal_filters_id_fk references acs_objects(object_id),
    filter_name      varchar(100)
        constraint ctrl_cal_filters_name_nn not null,
    description      varchar(1000),
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

@@../cc-filter-create.sql
@@../cc-filter-pkg-create.sql
commit;

