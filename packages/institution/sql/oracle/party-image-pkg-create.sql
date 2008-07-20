-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-image-pkg-create.sql
--
-- Package for holding images of parties.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-05-18
-- @cvs-id $Id: party-image-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- PARTY IMAGE ---------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_party_image
as
	-- constructor --
	function new (
		image_id		in inst_party_images.image_id%TYPE				default null,
		owner_id		in inst_party_images.party_id%TYPE,
		type_id			in inst_party_images.image_type_id%TYPE			default null,
		description		in inst_party_images.description%TYPE			default null,
		height			in inst_party_images.height%TYPE				default null,
		width			in inst_party_images.width%TYPE					default null,
		format			in inst_party_images.format%TYPE				default 'image/jpeg',

		object_type		in acs_object_types.object_type%TYPE			default 'inst_party_image',
		creation_date	in acs_objects.creation_date%TYPE				default sysdate,
		creation_user	in acs_objects.creation_user%TYPE				default null,
		creation_ip		in acs_objects.creation_ip%TYPE					default null,
		context_id		in acs_objects.context_id%TYPE					default null
	) return inst_party_images.image_id%TYPE;

	-- destructor --
	procedure delete (
		image_id		in inst_party_images.image_id%TYPE
	);
end inst_party_image;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_party_image
as
	-- constructor
	function new (
		image_id		in inst_party_images.image_id%TYPE				default null,
		owner_id		in inst_party_images.party_id%TYPE,
		type_id			in inst_party_images.image_type_id%TYPE			default null,
		description		in inst_party_images.description%TYPE			default null,
		height			in inst_party_images.height%TYPE				default null,
		width			in inst_party_images.width%TYPE					default null,
		format			in inst_party_images.format%TYPE				default 'image/jpeg',

		object_type		in acs_object_types.object_type%TYPE			default 'inst_party_image',
		creation_date	in acs_objects.creation_date%TYPE				default sysdate,
		creation_user	in acs_objects.creation_user%TYPE				default null,
		creation_ip		in acs_objects.creation_ip%TYPE					default null,
		context_id		in acs_objects.context_id%TYPE					default null
	) return inst_party_images.image_id%TYPE
	is
		v_image_id			integer;
		v_obj_exists_p		integer;
		v_obj_type			acs_objects.object_type%TYPE;
		v_image_exists_p	integer;
		v_type_id			integer;
		unused				integer;
	begin
		v_image_id := acs_object.new (
			object_id		=> v_image_id,
			object_type		=> object_type,
			creation_date	=> creation_date,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip,
			context_id		=> context_id
		);

		-- use a default type_id if it's null
		if type_id is null then
			v_type_id := category.lookup('//Image//Other');
		else
			v_type_id := inst_party_image.new.type_id;
		end if;

		insert into inst_party_images (
				image_id, party_id, image_type_id, description, image, height, width, format
			) values (
				v_image_id, owner_id, v_type_id, description, empty_blob(), height, width, format
		);

		return v_image_id;
	end new;

	-- destructor --
	procedure delete (
		image_id		in inst_party_images.image_id%TYPE
	) is
		v_image_id		integer;
	begin
		v_image_id := image_id;

		delete from inst_party_images
		where image_id = v_image_id;

		acs_object.delete(v_image_id);
	end delete;
end inst_party_image;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------


