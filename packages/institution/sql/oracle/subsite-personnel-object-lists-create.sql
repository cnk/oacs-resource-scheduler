-- -*- tab-width: 4 -*-
--
-- packages/institution/sql/oracle/subsite-personnel-object-lists-create.sql
--
-- Package for holding lists (ordered subsets) of a personnel's objects that
-- should be displayed on a given subsite.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2005-02-16
-- @cvs-id			$Id: subsite-personnel-object-lists-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- -------------------------------- OBJECT LISTS -------------------------------
-- -----------------------------------------------------------------------------
create table inst_subsite_psnl_obj_lists (
	subsite_id		integer
		constraint		inst_spol_subsite_id_fk		references apm_packages(package_id),
	personnel_id	integer
		constraint  	inst_spol_personnel_id_fk	references inst_personnel(personnel_id),
	object_id		integer
		constraint		inst_spol_object_id_fk		references acs_objects(object_id),
	relative_order	integer,
	in_context_p	char(1)							default 'f'
		constraint		inst_spol_in_context_p_ck	check (in_context_p in ('t','f')),
	constraint inst_spol_spo_un						unique (subsite_id, personnel_id, object_id)
);
