-- /packages/events/sql/oracle/events-tables-create.sql
-- 
-- The CTRL Events Package used to manage events for objects
-- This package is used by the Digest, Room Reservation, and Calendar Packages
-- 
-- @creation-date 04/01/2005
-- @update-date 08/08/2008 (ported to postgres)
--
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
       repeat_template_p		boolean default 'f' 
					constraint ctrl_events_rt_p_nn not null
					constraint ctrl_events_repeat_template_ck check ((repeat_template_p='t' and repeat_template_id is null) or repeat_template_p='f'),
       title				varchar(1000) 
					constraint ctrl_events_title_nn not null,
       speakers				varchar(4000),
       start_date			timestamptz,
       end_date				timestamptz,
       all_day_p			boolean default 'f' 
					constraint ctrl_events_all_day_p_nn not null,
       location				varchar(4000),
       notes				text,
       capacity				integer,
       image_item_id			integer 
					constraint ctrl_events_image_item_id_fk references cr_items(item_id),
       -- event_image			blob,
       --lob				integer
       --				constraint ctrl_events_lob_fk references lobs(lob_id),
       --event_image_width		integer,
       --event_image_height		integer,
       --event_image_file_type		varchar(100),
       --event_image_caption		varchar(4000),
       status			        varchar(15) default 'scheduled'
					constraint ctrl_events_status_ck check (status in ('cancelled','pending','scheduled')),
       public_p				boolean default 't'
					constraint ctrl_events_public_p_nn not null,
       approved_p			boolean default 't'
					constraint ctrl_events_approved_p_nn not null,
       category_id			integer
					constraint ctrl_event_cat_id_fk references ctrl_categories(category_id),
       package_id			integer
					constraint ctrl_event_pkg_id_fk references apm_packages(package_id)
);

-- create index ctrl_events_lob_idx ON ctrl_events(lob);

--create trigger ctrl_events_lob_trig before delete or update or insert
--on ctrl_events for each row execute procedure on_lob_ref();

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
					constraint ctrl_events_rsvp_event_id_fk references ctrl_events(event_id)
					on delete cascade,
       rsvp_admin_approval_required_p	boolean default 'f',
       rsvp_registration_start_date	timestamptz
					constraint ctrl_events_rsvp_reg_sd_nn not null,
       rsvp_registration_end_date	timestamptz,
       rsvp_capacity_consideration_p	boolean default 'f' 
					constraint ctrl_events_rsvp_capconsi_p_nn not null,
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
			      constraint ctrl_events_att_rsvp_e_id_fk references ctrl_events_rsvps(rsvp_event_id) 
			      on delete cascade,
       email		      varchar(100) 
			      constraint ctrl_events_att_email_nn not null,	
       first_name	      varchar(100)
			      constraint ctrl_events_att_first_name_nn not null,
       last_name	      varchar(100)
			      constraint ctrl_events_att_last_name_nn not null,
       response_status	      varchar(15)
			      constraint ctrl_events_att_resp_stat_nn not null
			      constraint ctrl_events_att_resp_stat_ck check (response_status in ('attending','decline')),
       approval_status	      varchar(15)
			      constraint ctrl_events_att_appvl_stat_nn not null
			      constraint ctrl_events_att_appvl_stat_ck check (approval_status in ('attending','pending','denied')),
       signin_id	      varchar(100),
       signin_date	      timestamptz,
       constraint event_att_event_att_un unique (rsvp_event_id,email)
);

comment on table ctrl_events_attendees is '
This table stores all the people who have reserved a space to this event. It contains
the site visitor name, email, and phone';

create table ctrl_events_attendees_roles (
       event_attendee_id	integer
				constraint ear_event_att_id_nn not null
				constraint ear_event_att_id_fk references ctrl_events_attendees(event_attendee_id)
				on delete cascade,
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
				constraint ctrl_events_tasks_event_id_fk references ctrl_events(event_id)
				on delete cascade,
       title			varchar(300)
				constraint ctrl_events_tasks_title_nn not null,
       assigned_by		integer
				constraint ctrl_events_tasks_assign_by_nn not null
				constraint ctrl_events_tasks_assign_by_fk references users(user_id),
       due_date			timestamptz,
       priority			varchar(10)
				constraint ctrl_events_tasks_priority_nn not null
				constraint ctrl_events_tasks_priority_ck check (priority in ('high', 'medium', 'low')),
       status			varchar(15)
				constraint ctrl_events_tasks_status_nn not null
				constraint ctrl_events_tasks_status_ck check (status in ('open', 'closed')),
       category_id		integer
				constraint ctrl_events_tasks_category_nn not null
				constraint ctrl_events_tasks_category_fk references ctrl_categories(category_id),
       start_date		timestamptz,
       end_date			timestamptz,
				constraint ctrl_events_tasks_end_date_ck check (start_date <= end_date),
       percent_completed	integer
				constraint ctrl_events_tasks_per_comp_ck check (percent_completed >=0 and percent_completed <=100),
       notes			varchar(1000)
);

create table ctrl_events_notifications (
       event_id			  integer
				  constraint ctrl_events_note_event_id_nn not null
				  constraint ctrl_events_note_event_id_fk references ctrl_events(event_id)
				  on delete cascade,
       email			  varchar(100)
				  constraint ctrl_events_note_email_nn not null,
       notification_category_id	  integer
				  constraint ctrl_events_note_cat_id_nn not null
				  constraint ctrl_events_note_cat_id_fk references ctrl_categories(category_id),
       date_to_send		  timestamptz
				  constraint ctrl_events_note_date_send_nn not null,
       date_sent		  timestamptz,
       constraint ctrl_events_notif_email_pk primary key (event_id, notification_category_id, email)
);


create table ctrl_events_repetitions (
       repeat_template_id		integer 
					constraint ctrl_events_rep_repeat_e_id_pk primary key
					constraint ctrl_events_rep_repeat_e_id_fk references ctrl_events(event_id)
					on delete cascade,
       frequency_type			varchar(100)
					constraint ctrl_events_rep_freq_type_nn not null
					constraint ctrl_events_rep_freq_type_ck check (frequency_type in ('daily','weekly', 'monthly', 'yearly')),
       frequency			integer
					constraint ctrl_events_rep_freq_nn not null,
       specific_day_frequency		varchar(100) 
					constraint ctrl_events_spec_day_freq_ck check (specific_day_frequency in ('first','second','third','fourth','last')),
       specific_days			varchar(100),
       specific_dates_of_month		varchar(100),					
       specific_months			varchar(100),
       end_date				timestamptz,
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

create table ctrl_events_categories_map (
 	event_id		integer
 				constraint ctrl_ecm_event_id_nn not null
 				constraint ctrl_ecm_event_id_fk references ctrl_events(event_id)
				on delete cascade,
  	category_id		integer
 				constraint ctrl_ecm_category_id_nn not null
 				constraint ctrl_ecm_category_id_fk references ctrl_categories(category_id),
 	constraint ctrl_ecm_pk primary key (event_id, category_id)
);

comment on table ctrl_events_categories_map is '
This table is used to map categories to events. It allows an event to be in multiple categories.';


create table ctrl_events_objects (
       	event_object_id		 integer 
				 constraint ctrl_eo_object_id_pk primary key
					 constraint ctrl_eo_object_id_fk references acs_objects(object_id),
       	name			 varchar(300) 
				 constraint ctrl_eo_name_nn not null,
        last_name		 varchar(300),
       	object_type_id		 integer
				 constraint ctrl_eo_object_type_id_nn not null
				 constraint ctrl_eo_object_type_id_fk references ctrl_categories(category_id),
       	description		 varchar(4000),
       	url			 varchar(1000),
       	-- image		 blob,
	lob			 integer
				 constraint ctrl_eo_lob_fk references lobs(lob_id),
       	image_width		 integer,
       	image_height		 integer,
       	image_file_type		 varchar(100),
       	constraint ctrl_eo_name_object_type_id_un unique (name, last_name, object_type_id)
);

create index ctrl_eo_lob_idx ON ctrl_events_objects(lob);

create trigger ctrl_eo_lob_trig before delete or update or insert
on ctrl_events_objects for each row execute procedure on_lob_ref();

comment on table ctrl_events_objects is '
	This table stores general objects which can be used by events.
	Examples of objects are speakers, hosts, video links, ping pong table, etc..
	acs_rels is used to map these objects to events
';

create table ctrl_events_event_object_map (
       event_id                 integer     
                                constraint ctrl_eeom_event_id_nn not null   
                                constraint ctrl_eeom_event_id_fk references ctrl_events(event_id)  
                                on delete cascade,
       event_object_id          integer
                                constraint ctrl_eeom_object_id_nn not null
				constraint ctrl_eeom_object_id_fk references ctrl_events_objects(event_object_id),
       tag     			varchar(100) 
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
