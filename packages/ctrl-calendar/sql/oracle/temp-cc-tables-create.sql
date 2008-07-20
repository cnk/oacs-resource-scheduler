create table ctrl_calendars (
    cal_id         integer   
        constraint ctrl_cal_cal_id_pk primary key 
        constraint ctrl_cal_cal_id_fk references acs_objects(object_id),
    cal_name       varchar2(255) 	  
        constraint ctrl_cal_name_nn not null,
    description    varchar2(4000) ,
    owner_id       integer 
        constraint ctrl_cal_owner_id_fk references persons(person_id),
    object_id 	  integer
	constraint ctrl_cal_object_id_nn not null
	constraint ctrl_cal_object_id_fk references acs_objects(object_id)
);
