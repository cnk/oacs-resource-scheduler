-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/subsite-for-party-rel-pkg-create.sql
--
-- Package for relating subsites to parties that they are for
-- (though they are not necessarily administrated by those parties)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004-06-14
-- @cvs-id $Id: subsite-for-party-rel-pkg-create.sql,v 1.2 2007/01/06 03:10:08 avni Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------- SUBSITE FOR PARTY RELATIONSHIP -----------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_subsite_for_party_rel
as
	function new (
		subsite_id		in acs_rels.object_id_one%TYPE,
		party_id		in acs_rels.object_id_two%TYPE,
		creation_user	in acs_objects.creation_user%TYPE			default null,
		creation_ip		in acs_objects.creation_ip%TYPE				default null,
		rel_type		in acs_rels.rel_type%TYPE					default 'subsite_for_party_rel',
		rel_id			in inst_subsite_for_party_rels.rel_id%TYPE	default null
	) return inst_subsite_for_party_rels.rel_id%TYPE;
	
	procedure delete (
		rel_id			in inst_subsite_for_party_rels.rel_id%TYPE
	);
end inst_subsite_for_party_rel;
/
show errors

create or replace package body inst_subsite_for_party_rel
as
	function new (
		subsite_id		in acs_rels.object_id_one%TYPE,
		party_id		in acs_rels.object_id_two%TYPE,
		creation_user	in acs_objects.creation_user%TYPE			default null,
		creation_ip		in acs_objects.creation_ip%TYPE				default null,
		rel_type		in acs_rels.rel_type%TYPE					default 'subsite_for_party_rel',
		rel_id			in inst_subsite_for_party_rels.rel_id%TYPE	default null
	) return inst_subsite_for_party_rels.rel_id%TYPE
	is
		v_rel_id		inst_subsite_for_party_rels.rel_id%TYPE;
	begin
		v_rel_id := acs_rel.new(
			rel_id			=> rel_id,
			rel_type		=> rel_type,
			object_id_one	=> subsite_id,
			object_id_two	=> party_id,
			context_id		=> subsite_id,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip
		);

		insert into inst_subsite_for_party_rels	(rel_id)
		values									(v_rel_id);

		return v_rel_id;
	end new;

	procedure delete (
		rel_id			in inst_subsite_for_party_rels.rel_id%TYPE
	)
	is
	begin
		acs_rel.delete(rel_id);

		 delete from inst_subsite_for_party_rels
		 where rel_id = inst_subsite_for_party_rel.delete.rel_id;
	end delete;
end inst_subsite_for_party_rel;
/
show errors
