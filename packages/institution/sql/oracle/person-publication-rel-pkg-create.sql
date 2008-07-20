-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/publication-map-pkg-create.sql
--
-- Package for relating subsites to parties that they are for
-- (though they are not necessarily administrated by those parties)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004-10-11
-- @cvs-id			$Id: person-publication-rel-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------- PERSON-PUBLICATION RELATIONSHIP ----------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_person_publication_rel
as
	function new (
		publication_id	in acs_rels.object_id_one%TYPE,
		person_id		in acs_rels.object_id_two%TYPE,
		creation_user	in acs_objects.creation_user%TYPE			default null,
		creation_ip		in acs_objects.creation_ip%TYPE				default null,
		rel_type		in acs_rels.rel_type%TYPE					default 'inst_person_publication_rel',
		rel_id			in inst_person_publication_rels.rel_id%TYPE	default null
	) return inst_person_publication_rels.rel_id%TYPE;

	procedure delete (
		rel_id			in inst_person_publication_rels.rel_id%TYPE
	);
end inst_person_publication_rel;
/
show errors

create or replace package body inst_person_publication_rel
as
	function new (
		publication_id	in acs_rels.object_id_one%TYPE,
		person_id		in acs_rels.object_id_two%TYPE,
		creation_user	in acs_objects.creation_user%TYPE			default null,
		creation_ip		in acs_objects.creation_ip%TYPE				default null,
		rel_type		in acs_rels.rel_type%TYPE					default 'inst_person_publication_rel',
		rel_id			in inst_person_publication_rels.rel_id%TYPE	default null
	) return inst_person_publication_rels.rel_id%TYPE
	is
		v_rel_id		inst_person_publication_rels.rel_id%TYPE;
	begin
		v_rel_id := acs_rel.new(
			rel_id			=> rel_id,
			rel_type		=> rel_type,
			object_id_one	=> publication_id,
			object_id_two	=> person_id,
			context_id		=> nvl(creation_user, person_id),
			creation_user	=> creation_user,
			creation_ip		=> creation_ip
		);

		insert into inst_person_publication_rels	(rel_id)
		values										(v_rel_id);

		return v_rel_id;
	end new;

	procedure delete (
		rel_id			in inst_person_publication_rels.rel_id%TYPE
	)
	is
	begin
		acs_rel.delete(rel_id);

		delete from inst_person_publication_rels
		 where rel_id = inst_person_publication_rel.delete.rel_id;
	end delete;
end inst_person_publication_rel;
/
show errors
