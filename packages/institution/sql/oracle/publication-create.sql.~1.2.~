-- -*- tab-width: 4 -*- ---
--
-- packages/institution/sql/oracle/publication-create.sql
--
-- Data model for publications part of institution package.
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
--
-- @creation-date	2003/07/20
-- @cvs-id $Id: publication-create.sql,v 1.2 2007/01/26 02:02:30 andy Exp $
--

create table inst_publications (
	publication_id			integer
		constraint			inst_publctn_publication_id_pk primary key,
		constraint			inst_publctn_publication_id_fk foreign key (publication_id) references acs_objects(object_id),
	title					varchar2(4000)	not null,
	publication_name		varchar2(4000),
	url						varchar2(1000),
	-- authors is for display purposes only
	authors					varchar2(4000),
	volume					varchar2(1000),
	issue					varchar2(1000),
	page_ranges				varchar2(1000),
	year					integer,
	publish_date			date,
	publication				blob,
	publication_type		varchar2(100),
	publisher				varchar2(100),
	priority_number			integer
);

-- AMK - ADDED 1/31/2006
create table inst_publications_audit (
	publication_id			integer 		not null,
	title					varchar2(4000)	not null,
	publication_name		varchar2(4000),
	url						varchar2(1000),
	authors					varchar2(4000),
	volume					varchar2(1000),
	issue					varchar2(1000),
	page_ranges				varchar2(1000),
	year					integer,
	publish_date			date,
	publisher				varchar2(100),
	creation_date			date default sysdate
);
