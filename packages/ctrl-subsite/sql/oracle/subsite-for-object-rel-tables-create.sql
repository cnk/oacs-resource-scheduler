-- /packages/ctrl-subsite/sql/oracle/subsite-for-object-create.sql
--
-- Package for relating subsites to objects 
--
-- @author		avni@ctrl.ucla.edu (AK)
-- @creation-date 	2007-03-09
-- @cvs-id $Id$
--


create table ctrl_subsite_for_object_rels (
    rel_id
        constraint      ctrl_ssite_for_obj_rel_id_fk references acs_rels(rel_id)
        constraint      ctrl_ssite_for_obj_rel_id_pk primary key
);
