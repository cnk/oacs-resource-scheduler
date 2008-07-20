-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/image-create.sql
--
-- Tables for holding information about parties' images.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-05
-- @cvs-id $Id: party-image-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_party_images (
	image_id				integer
		constraint			inst_prty_img_image_id_pk primary key,
		constraint			inst_prty_img_image_id_fk foreign key (image_id) references acs_objects(object_id),
	party_id				integer			not null,
		constraint  		inst_prty_img_party_id_fk foreign key (party_id) references parties(party_id),
	image_type_id			integer			not null,
		constraint  		inst_prty_img_image_type_id_fk foreign key (image_type_id) references categories(category_id),
	description				varchar2(1000),
	image					blob,
	height					integer,
	width					integer,
	format					varchar2(100),
	constraint inst_prty_img_party_id_desc_un unique (party_id, description)
);
