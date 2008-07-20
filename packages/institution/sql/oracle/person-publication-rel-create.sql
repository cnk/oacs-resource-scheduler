-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/person-publication-rel-create.sql
--
-- Package for relating persons to the publications they created/own.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004-10-11
-- @cvs-id			$Id: person-publication-rel-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_person_publication_rels (
	rel_id
		constraint		inst_prsn_publctns_rel_id_fk references acs_rels(rel_id)
		constraint		inst_prsn_publctns_rel_id_pk primary key
);
