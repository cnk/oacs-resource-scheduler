-- /packages/ctrl-subsite/sql/oracle/subsite-for-object-rel-pkg-create.sql
--
-- Package for relating subsites to objects
--
-- @author		avni@ctrl.ucla.edu (AK)
-- @creation-date	2007-03-12
-- @cvs-id $Id$
--


create or replace package ctrl_subsite_for_object_rel
as
	function new (
		subsite_id		in acs_rels.object_id_one%TYPE,
		object_id		in acs_rels.object_id_two%TYPE,
		creation_user		in acs_objects.creation_user%TYPE			default null,
		creation_ip		in acs_objects.creation_ip%TYPE				default null,
		rel_type		in acs_rels.rel_type%TYPE				default 'ctrl_subsite_for_object_rel',
		rel_id			in ctrl_subsite_for_object_rels.rel_id%TYPE		default null
	) return ctrl_subsite_for_object_rels.rel_id%TYPE;
	
	procedure del (
		rel_id			in ctrl_subsite_for_object_rels.rel_id%TYPE
	);
end ctrl_subsite_for_object_rel;
/
show errors

create or replace package body ctrl_subsite_for_object_rel
as
	function new (
		subsite_id		in acs_rels.object_id_one%TYPE,
		object_id		in acs_rels.object_id_two%TYPE,
		creation_user		in acs_objects.creation_user%TYPE		default null,
		creation_ip		in acs_objects.creation_ip%TYPE			default null,
		rel_type		in acs_rels.rel_type%TYPE			default 'ctrl_subsite_for_object_rel',
		rel_id			in ctrl_subsite_for_object_rels.rel_id%TYPE	default null
	) return ctrl_subsite_for_object_rels.rel_id%TYPE
	is
		v_rel_id		ctrl_subsite_for_object_rels.rel_id%TYPE;
	begin
		v_rel_id := acs_rel.new(
			rel_id			=> rel_id,
			rel_type		=> rel_type,
			object_id_one		=> subsite_id,
			object_id_two		=> object_id,
			context_id		=> subsite_id,
			creation_user		=> creation_user,
			creation_ip		=> creation_ip
		);

		insert into ctrl_subsite_for_object_rels	(rel_id)
		values						(v_rel_id);

		return v_rel_id;
	end new;

	procedure del (
		rel_id			in ctrl_subsite_for_object_rels.rel_id%TYPE
	)
	is
	begin
		acs_rel.del(rel_id);

		 delete from ctrl_subsite_for_object_rels
		 where rel_id = ctrl_subsite_for_object_rel.del.rel_id;
	end del;
end ctrl_subsite_for_object_rel;
/
show errors
