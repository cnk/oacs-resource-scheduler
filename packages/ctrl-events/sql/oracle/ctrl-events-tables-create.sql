-- /packages/events/sql/oracle/events-tables-create.sql
-- 
-- The CTRL Events Package used to manage events for objects
-- This package is used by the Digest, Room Reservation, and Calendar Packages
-- 
-- @creation-date 04/01/2005
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @cvs-id $Id: ctrl-events-tables-create.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
-- 

create table ctrl_events (
       event_id				integer
					constraint ctrl_events_event_id_pk primary key
					constraint ctrl_events_event_id_fk references acs_objects(object_id),
       event_object_id			integer	   
					constraint ctrl_events_eo_id_nn not null
					constraint ctrl_events_eo_id_fk references acs_objects(object_id),
       repeat_template_id		integer
					constraint ctrl_events_repeat_event_fk references ctrl_events(event_id),
       repeat_template_p		char(1) default 'f' 
					constraint ctrl_events_rt_p_nn not null
					constraint ctrl_events_rt_p_ck check(repeat_template_p in ('t','f')),
					constraint ctrl_events_repeat_template_ck check ((repeat_template_p='t' and repeat_template_id is null) or repeat_template_p='f'),
       title				varchar2(1000) not null,
       speakers				varchar2(4000),
       start_date			date,
       end_date				date,
       all_day_p			char(1) default 'f' 
					constraint ctrl_events_all_day_p_nn not null
					constraint ctrl_events_all_day_p_ck check (all_day_p in ('t','f')),
       location				varchar2(4000),
       notes				clob,
       capacity				integer,
       event_image			blob,
       event_image_width		integer,
       event_image_height		integer,
       event_image_file_type		varchar2(100),
       event_image_caption		varchar2(4000),
       status			        varchar2(15) default 'scheduled'
					constraint ctrl_events_status_ck check (status in ('cancelled','pending','scheduled')),
       public_p				char(1) default 't'
					constraint ctrl_events_public_p_nn not null
					constraint ctrl_events_public_p_ck check (public_p in ('t','f')),			
       approved_p			char(1) default 't'
					constraint ctrl_events_approved_p_nn not null
					constraint ctrl_events_approved_p_ck check (approved_p in ('t','f')),			
       category_id			number(30)
					constraint ctrl_event_cat_id_fk references ctrl_categories(category_id),
       package_id			integer
					constraint ctrl_event_pkg_id_fk references apm_packages(package_id)
);

comment on table ctrl_events is '
	This table stores all the events for objects in the system.
';

comment on column ctrl_events.repeat_template_id is '
	This column is null if the event has no parent. It is used for repeating events.
';

comment on column ctrl_events.repeat_template_p is '
	This column is used to determine if an event is a repeating event.
	If "t", this event is the event from which all the repeating events are copied.
	This event will be the parent_event_id of the repeating events.
';

create table ctrl_events_rsvps (
       rsvp_event_id			integer
					constraint ctrl_events_rsvp_event_id_pk primary key
					constraint ctrl_events_rsvp_event_id_fk references ctrl_events(event_id),
       rsvp_admin_approval_required_p	char(1) default 'f' constraint ctrl_events_rsvp_admin_p_ck check (rsvp_admin_approval_required_p in ('t','f')),
       rsvp_registration_start_date	date
					constraint ctrl_events_rsvp_reg_sd_nn not null,
       rsvp_registration_end_date	date,
       rsvp_capacity_consideration_p	char(1) default 'f' 
					constraint ctrl_events_rsvp_capconsi_p_nn not null
					constraint ctrl_events_rsvp_capconsi_p_ck check(rsvp_capacity_consideration_p in ('t','f')),
       constraint ctrl_events_rsvp_reg_ed_ck check(rsvp_registration_start_date <= rsvp_registration_end_date)
);

comment on column ctrl_events_rsvps.rsvp_admin_approval_required_p is '
	This column is only used if rsvp_p is true.
';

comment on column ctrl_events_rsvps.rsvp_registration_start_date is '
	This column is only used if rsvp_p is true.
';

comment on column ctrl_events_rsvps.rsvp_registration_end_date is '
	This column is only used if rsvp_p is true.
';

comment on column ctrl_events_rsvps.rsvp_capacity_consideration_p is '
	This column is only used if rsvp_p is true.
';

create table ctrl_events_attendees (
       event_attendee_id      integer
			      constraint ctrl_events_att_event_att_pk primary key,
       rsvp_event_id	      integer	 
			      constraint ctrl_events_att_rsvp_e_id_nn not null
			      constraint ctrl_events_att_rsvp_e_id_fk references ctrl_events_rsvps(rsvp_event_id) ,
       email		      varchar2(100) 
			      constraint ctrl_events_att_email_nn not null,	
       first_name	      varchar2(100)
			      constraint ctrl_events_att_first_name_nn not null,
       last_name	      varchar2(100)
			      constraint ctrl_events_att_last_name_nn not null,
       response_status	      varchar2(15)
			      constraint ctrl_events_att_resp_stat_nn not null
			      constraint ctrl_events_att_resp_stat_ck check (response_status in ('attending','decline')),
       approval_status	      varchar2(15)
			      constraint ctrl_events_att_appvl_stat_nn not null
			      constraint ctrl_events_att_appvl_stat_ck check (approval_status in ('attending','pending','denied')),
       signin_id	      varchar2(100),
       signin_date	      date,
       constraint event_att_event_att_un unique (rsvp_event_id,email)
);

comment on table ctrl_events_attendees is '
This table stores all the people who have reserved a space to this event. It contains
the site visitor name, email, and phone';

create table ctrl_events_attendees_roles (
       event_attendee_id	integer
				constraint ear_event_att_id_nn not null
				constraint ear_event_att_id_fk references ctrl_events_attendees(event_attendee_id),
       role_id			integer
				constraint ctrl_events_role_role_id_nn not null
				constraint ctrl_events_role_role_id_fk references ctrl_categories(category_id),
       constraint ctrl_events_role_event_role_pk primary key (event_attendee_id, role_id)
);


create table ctrl_events_tasks (
       task_id			integer
				constraint ctrl_events_tasks_task_id_pk primary key,
       event_id			integer
				constraint ctrl_events_tasks_event_id_nn not null
				constraint ctrl_events_tasks_event_id_fk references ctrl_events(event_id),
       title			varchar2(300)
				constraint ctrl_events_tasks_title_nn not null,
       assigned_by		integer
				constraint ctrl_events_tasks_assign_by_nn not null
				constraint ctrl_events_tasks_assign_by_fk references users(user_id),
       due_date			date,
       priority			varchar2(10)
				constraint ctrl_events_tasks_priority_nn not null
				constraint ctrl_events_tasks_priority_ck check (priority in ('high', 'medium', 'low')),
       status			varchar2(15)
				constraint ctrl_events_tasks_status_nn not null
				constraint ctrl_events_tasks_status_ck check (status in ('open', 'closed')),
       category_id		integer
				constraint ctrl_events_tasks_category_nn not null
				constraint ctrl_events_tasks_category_fk references ctrl_categories(category_id),
       start_date		date,
       end_date			date,
				constraint ctrl_events_tasks_end_date_ck check (start_date <= end_date),
       percent_completed	integer
				constraint ctrl_events_tasks_per_comp_ck check (percent_completed >=0 and percent_completed <=100),
       notes			varchar2(1000)
);

create table ctrl_events_notifications (
       event_id			  integer
				  constraint ctrl_events_note_event_id_nn not null
				  constraint ctrl_events_note_event_id_fk references ctrl_events(event_id),
       email			  varchar2(100)
				  constraint ctrl_events_note_email_nn not null,
       notification_category_id	  integer
				  constraint ctrl_events_note_cat_id_nn not null
				  constraint ctrl_events_note_cat_id_fk references ctrl_categories(category_id),
       date_to_send		  date
				  constraint ctrl_events_note_date_send_nn not null,
       date_sent		  date,
       constraint ctrl_events_notif_email_pk primary key (event_id, notification_category_id, email)
);


create table ctrl_events_repetitions (
       repeat_template_id		integer 
					constraint ctrl_events_rep_repeat_e_id_pk primary key
					constraint ctrl_events_rep_repeat_e_id_fk references ctrl_events(event_id),
       frequency_type			varchar2(100)
					constraint ctrl_events_rep_freq_type_nn not null
					constraint ctrl_events_rep_freq_type_ck check (frequency_type in ('daily','weekly', 'monthly', 'yearly')),
       frequency			integer
					constraint ctrl_events_rep_freq_nn not null,
       specific_day_frequency		varchar2(100) 
					constraint ctrl_events_spec_day_freq_ck check (specific_day_frequency in ('first','second','third','fourth','last')),
       specific_days			varchar2(100),
       specific_dates_of_month		varchar2(100),					
       specific_months			varchar2(100),
       end_date				date,
       constraint ctrl_events_rep_month_spec_ck check (((specific_dates_of_month is not null or specific_months is not null) 
		  and specific_day_frequency is null and specific_days is null) or 
		  (specific_dates_of_month is null and specific_months is null and specific_day_frequency is not null and specific_days is not null))
);


comment on column ctrl_events_repetitions.specific_days is '
This contains the days of week on which the repetition occurs.
This will be a comma separated list in the following format:
Mon,Tue,Wed,Thu,Fri,Sat,Sun
';

comment on column ctrl_events_repetitions.specific_dates_of_month is '
This is used for the monthly repetition and contains the dates within the month
on which the repetition occurs. This will be a comma separated list in the following format:
1,2,3..31
';

comment on column ctrl_events_repetitions.specific_months is '
This contains the months in which the repetition occurs.
This will be a comma separate list in the following format:
1,2,3..12
';

create table ctrl_events_objects (
       event_object_id		 integer 
				 constraint ctrl_eo_object_id_pk primary key
				 constraint ctrl_eo_object_id_fk references acs_objects(object_id),
       name			 varchar2(300) 
				 constraint ctrl_eo_name_nn not null,
       last_name		 varchar2(300),
       object_type_id		 integer
				 constraint ctrl_eo_object_type_id_nn not null
				 constraint ctrl_eo_object_type_id_fk references ctrl_categories(category_id),
       description		 varchar2(4000),
       url			 varchar2(1000),
       image			 blob,
       image_width		 integer,
       image_height		 integer,
       image_file_type		 varchar2(100),
       constraint ctrl_eo_name_object_type_id_un unique (name, last_name, object_type_id)
);

comment on table ctrl_events_objects is '
	This table stores general objects which can be used by events.
	Examples of objects are speakers, hosts, video links, ping pong table, etc..
	acs_rels is used to map these objects to events
';


create table ctrl_events_event_object_map (
       event_id			integer  
				constraint ctrl_eeom_event_id_nn not null
				constraint ctrl_eeom_event_id_fk references ctrl_events(event_id),
       event_object_id		integer
				constraint ctrl_eeom_object_id_nn not null
				constraint ctrl_eeom_object_id_fk references ctrl_events_objects(event_object_id),
       tag			varchar2(100) 
				constraint ctrl_eeom_tag_nn not null,
       event_object_group_id    integer
                                constraint ctrl_eeom_group_id_nn not null,
       constraint ctrl_eeom_group_id_un unique (event_id, event_object_id, event_object_group_id),
       constraint ctrl_eeom_event_tag_un unique (event_id, tag),
       constraint ctrl_eeom_pk primary key (event_id, event_object_id)
);

comment on table ctrl_events_event_object_map is '
This table stores the map of event_objects to events.
Administrators can select which objects they want to associate
with events and use the tag field to refer to the object
in the event description.
';

comment on column ctrl_events_event_object_map.tag is '
The tag of an event object is how to refer to the object
within the description of an event. For example,
if the tag=rome and refers to the video of dr. rome, to refer to the object in the description
you would use <ctrl_event_object tag=rome>.
If you wanted to get all video objects for an event you would use <ctrl_event_object object_type=video>.
';
