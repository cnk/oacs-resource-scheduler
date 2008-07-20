-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-create.sql
--
-- Tables for holding information about parties (Supplementary Party Information)
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-07-20
-- @cvs-id $Id: party-supplement-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- inst_party_category_map will store the mapping of inst_groups or inst_personnel to categories
create table inst_party_category_map (
	party_id				integer 		not null,
		constraint			inst_pcm_party_id_fk foreign key (party_id) references parties(party_id),
	category_id				integer			not null,
		constraint			inst_pcm_category_id_fk foreign key (category_id) references categories(category_id),
	constraint 				inst_pcm_party_category_id_pk primary key (party_id,category_id)
);

-- inst_party_addresses will store information
create table inst_party_addresses (
	address_id				integer
		constraint			inst_pa_address_id_pk primary key,
		constraint			inst_pa_address_id_fk foreign key (address_id) references acs_objects(object_id),
	party_id				integer			not null,
		constraint  		inst_pa_party_id_fk foreign key (party_id) references parties(party_id),
	address_type_id			integer			not null,
		constraint  		inst_pa_address_type_id_fk foreign key (address_type_id) references categories (category_id),
	description				varchar2(1000),
	building_name			varchar2(300),
	room_number				varchar2(300),
	address_line_1			varchar2(300)	not null,
	address_line_2			varchar2(300),
	address_line_3			varchar2(300),
	address_line_4			varchar2(300),
	address_line_5			varchar2(300),
	city					varchar2(300),
	fips_state_code			char(2),
		constraint			inst_pa_fips_sc_fk foreign key (fips_state_code) references us_states(fips_state_code),
	zipcode					char(5),
		constraint		    	inst_pa_zipcode_fk foreign key (fips_state_code,zipcode) references us_zipcodes(fips_state_code,zipcode),
	zipcode_ext				char(4),
	fips_country_code		char(2),
		constraint			inst_pa_fips_cc_fk foreign key (fips_country_code) references countries(iso)
);

create table inst_party_phones (
	phone_id				integer
		constraint			inst_pp_phone_id_pk primary key,
		constraint			inst_pp_phone_id_fk foreign key (phone_id) references acs_objects(object_id),
	party_id				integer			not null,
		constraint  		inst_pp_party_id_fk foreign key (party_id) references parties (party_id),
	phone_type_id			integer			not null,
		constraint  		inst_pp_phone_type_id_fk foreign key (phone_type_id) references categories (category_id),
	description				varchar2(1000),
	phone_number			varchar2(100)	not null,
	phone_priority_number	integer
);

create table inst_party_emails (
	email_id				integer
		constraint			inst_pe_email_id_pk primary key,
		constraint			inst_pe_email_id_fk foreign key (email_id) references acs_objects(object_id),
	party_id				integer			not null,
		constraint  		inst_pe_party_id_fk foreign key (party_id) references parties (party_id),
	email_type_id			integer			not null,
		constraint  		inst_pe_email_type_id_fk foreign key (email_type_id) references categories (category_id),
	description				varchar2(1000),
	email					varchar2(1000)	not null
);


create table inst_party_urls (
	url_id					integer
		constraint			inst_pu_url_id_pk primary key,
		constraint			inst_pu_url_id_fk foreign key (url_id) references acs_objects(object_id),
	party_id				integer			not null,
		constraint  		inst_pu_party_id_fk foreign key (party_id) references parties (party_id),
	url_type_id				integer			not null,
		constraint  		inst_pu_url_type_id_fk foreign key (url_type_id) references categories (category_id),
	description				varchar2(1000),
	url						varchar2(2000)	not null
);

