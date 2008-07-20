-- /packages/ctrl-calendar/sql/oracle/calendar-digest-tables-create.sql
-- 
-- These tables handle the interactions between the Calendar and Digest Packages
--
-- @creation-date 2006/11/22
-- @author avni@ctrl.ucla.edu (AK)
-- @cvs-id $Id$
--

-- This table contains the calendar to digest map
-- It shows which digests a calendar is allowed to post to
create table ccal_digest_map (
	cal_digest_id		integer
		constraint ccall_dm_cd_id_pk primary key,
	cal_id			integer
		constraint ccal_dm_cal_id_nn not null		
		constraint ccal_dm_cal_id_fk references ctrl_calendars(cal_id),
	-- This is the root URL for all of this digest's web services
	-- This is not necessarily external to this server, but it is possible that is is
	ext_digest_url_root		varchar2(1000)
		constraint ccal_dm_digest_urlr_nn not null,
	ext_digest_id		integer
		constraint ccal_dm_digest_id_nn not null,
	constraint ccal_dm_cal_digest_un unique (cal_id, ext_digest_url_root, ext_digest_id),
	mapping_date		date 	default sysdate
		constraint ccal_dm_mapping_date_nn not null,
	mapped_by		integer
		constraint ccal_dm_mapped_by_nn not null
		constraint ccal_dm_mapped_by_fk references users(user_id)	
);

-- This table maps events to postings
-- It shows which events have been sent over to a digest in the Digest Package
create table ccal_event_posting_map (
	event_id		integer
		constraint ccal_epm_event_id_nn not null
		constraint ccal_epm_event_id_fk references ctrl_events(event_id),
	cal_digest_id		integer
		constraint ccal_epm_cd_id_nn not null
		constraint ccal_epm_cd_id_fk references ccal_digest_map(cal_digest_id),
	-- This is the posting_id that this this event was imported into.
	-- It is not necessarily external to this server, but it can be
	ext_posting_id		integer
		constraint ccal_epm_posting_id_nn not null,
	mapping_date		date  default sysdate
		constraint ccal_epm_mapping_date_nn not null,
	mapped_by		integer
		constraint ccal_epm_mapped_by_nn not null
		constraint ccal_epm_mapped_by_fk references users(user_id),
	constraint ccal_event_cd_id_pk primary key (event_id, cal_digest_id)
);
	

commit;
