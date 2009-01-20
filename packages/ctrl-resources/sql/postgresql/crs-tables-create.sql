-- /packages/ctrl-resources/sql/oracle/crs-tables-create.sql
--
-- Table Creation for CTRL Resources
--
-- @author avni@ctrl.ucla.edu (AK)
-- @creation-date 12/6/2005
-- @cvs-id $Id$
--

create table crs_resources (
	resource_id		integer
				constraint cr_resource_id_pk primary key
				constraint cr_resource_id_fk references acs_objects(object_id),
	parent_resource_id	integer
				constraint cr_parent_resource_id_fk references crs_resources(resource_id),
	name			varchar(1000)
				constraint cr_name_nn not null,
	description		varchar(4000),
	resource_category_id	integer
				constraint cr_resource_category_id_fk references ctrl_categories(category_id),
	owner_id		integer
				constraint cr_owner_id_fk references parties(party_id),
	enabled_p		boolean default 't'
				constraint cr_enabled_p_nn not null,
	quantity		integer default 1,
	services		varchar(4000),
	property_tag		varchar(1000),
        resource_type           varchar(1000),
	package_id		integer
				constraint cr_package_id_fk references apm_packages(package_id)
);

create table crs_images (
	image_id		integer
				constraint cri_image_id_pk primary key
				constraint cri_image_id_fk references acs_objects(object_id),
	resource_id		integer
				constraint cri_resource_id_nn not null
				constraint cri_resource_id_fk references crs_resources(resource_id)
	-- image			blob,
	-- image_name		varchar(100)
				constraint cri_image_name_nn not null,
	-- image_width		integer 
				constraint cri_image_width_nn not null,
	-- image_height		integer
				constraint cri_image_height_nn not null,
	-- image_file_type		varchar2(100)
				constraint cri_image_file_type_nn not null
);

create table crs_reservable_resources (
	resource_id		integer
				constraint crres_resource_id_pk primary key
				constraint crres_resource_id_fk references acs_objects(object_id),
	how_to_reserve		varchar(4000),
	contact_info		varchar(4000),
	approval_required_p	boolean default 'f'
				constraint crres_approval_required_p_nn not null,
	address_id		integer
				constraint crres_address_id_fk references ctrl_addresses(address_id),
	department_id		integer
				constraint crres_department_id_fk references ctrl_categories(category_id),
	floor			varchar(100)
				constraint crres_floor_nn not null,
	room			varchar(100)
				constraint crres_room_nn not null,
	gis			varchar(1000),
    	-- email notify for new reservations
    	new_email_notify_list     varchar(2000),
    	-- email notify for update to reservations
    	update_email_notify_list  varchar(2000),
	color			varchar(6) 
        reservable_p            boolean,
        reservable_p_note       varchar(300),
        special_request_p       boolean
);

create table  crs_rooms (
	room_id			integer
				constraint crroom_room_id_pk primary key
				constraint crroom_room_id_fk references crs_reservable_resources(resource_id),
	capacity		integer,
	dimensions_width	integer,
	dimensions_length	integer,
	dimensions_height	integer,
	dimensions_unit		varchar(100)
);

create table crs_room_templates (
	room_type_id		integer
				constraint crrt_room_id_nn not null
				constraint crrt_room_id_fk references ctrl_categories(category_id),
	equipment_type_id	integer
				constraint crrt_equipment_type_id_nn not null
				constraint crrt_equipment_type_id_fk references ctrl_categories(category_id)
);

create table crs_requests (
	request_id		integer
				constraint crreq_request_id_pk primary key
				constraint crreq_request_id_fk references acs_objects(object_id),
	repeat_template_id	integer
				constraint crreq_repeat_request_fk references crs_requests(request_id),
	repeat_template_p	boolean default 'f'
				constraint crreq_rt_p_nn not null
				constraint crreq_repeat_template_ck check((repeat_template_p='t' and repeat_template_id is null) or repeat_template_p='f'),
	name			varchar(1000)
				constraint crreq_name_nn not null,
	description		varchar(4000),
	status			varchar(100)
				constraint crreq_status_nn not null
				constraint crreq_status_ck check (status in ('approved','denied','pending','cancelled')),
        package_id              integer ,
	reserved_by		integer
				constraint crreq_reserved_by_nn not null
				constraint crreq_reserved_by_fk references users(user_id),
	requested_by		varchar(1000) ,
        requested_date          timestamptz default current_timestamp 
				constraint ccreq_req_date_nn not null
);

create table crs_events (
	event_id		integer
				constraint cre_event_id_pk primary key
				constraint cre_event_id_fk references ctrl_events(event_id),
	request_id		integer
				constraint cre_request_id_nn not null
				constraint cre_request_id_fk references crs_requests(request_id),
	status			varchar(100)
				constraint cre_status_nn not null
				constraint cre_status_ck check (status in ('approved','denied','pending','cancelled')),
	reserved_by		integer
				constraint cre_reserved_by_nn not null
				constraint cre_reserved_by_fk references users(user_id),
	date_reserved		timestamptz default current_timestamp
				constraint cre_date_reserved_nn not null,
	event_code		varchar(1000)
				constraint cre_event_code_nn not null
);


commit;
