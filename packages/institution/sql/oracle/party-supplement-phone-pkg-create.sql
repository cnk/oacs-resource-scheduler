-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-phone-pkg-create.sql
--
-- Package for holding information about parties (Supplementary Party Information)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2003-08-05
-- @cvs-id			$Id: party-supplement-phone-pkg-create.sql,v 1.2 2007/02/21 03:30:03 andy Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- PHONE NUMBER --------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_party_phone
as
	-- constructor --
	function new (
		phone_id		in inst_party_phones.phone_id%TYPE		default null,
		owner_id		in inst_party_phones.party_id%TYPE,
		type_id			in inst_party_phones.phone_type_id%TYPE	default null,
		description		in inst_party_phones.description%TYPE	default null,
		phone_number	in inst_party_phones.phone_number%TYPE,
		priority_number	in inst_party_phones.phone_priority_number%TYPE	default null,

		object_type		in acs_object_types.object_type%TYPE	default 'phone_number',
		creation_date	in acs_objects.creation_date%TYPE		default sysdate,
		creation_user	in acs_objects.creation_user%TYPE		default null,
		creation_ip		in acs_objects.creation_ip%TYPE			default null,
		context_id		in acs_objects.context_id%TYPE			default null
	) return inst_party_phones.phone_id%TYPE;

	-- destructor --
	procedure delete (
		phone_id		in inst_party_phones.phone_id%TYPE
	);
end inst_party_phone;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_party_phone
as	-- constructor -- allows augmenting/mutation of other objects at runtime
	function new (
		phone_id		in inst_party_phones.phone_id%TYPE		default null,
		owner_id		in inst_party_phones.party_id%TYPE,
		type_id			in inst_party_phones.phone_type_id%TYPE	default null,
		description		in inst_party_phones.description%TYPE	default null,
		phone_number	in inst_party_phones.phone_number%TYPE,
		priority_number	in inst_party_phones.phone_priority_number%TYPE	default null,

		object_type		in acs_object_types.object_type%TYPE	default 'phone_number',
		creation_date	in acs_objects.creation_date%TYPE		default sysdate,
		creation_user	in acs_objects.creation_user%TYPE		default null,
		creation_ip		in acs_objects.creation_ip%TYPE			default null,
		context_id		in acs_objects.context_id%TYPE			default null
	) return inst_party_phones.phone_id%TYPE
	is
		v_phone_id		integer;
		v_type_id		integer;
	begin
		v_phone_id := acs_object.new (
			object_id		=> v_phone_id,
			object_type		=> object_type,
			creation_date	=> creation_date,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip,
			context_id		=> context_id
		);

		-- use a default type_id if it's null
		if type_id is null then
			select category_id into v_type_id
			  from categories
			 where parent_category_id =
					(select category_id
					   from categories
					  where parent_category_id is null
						and name = 'Contact Information')
			   and name = 'Other';
		else
			v_type_id := type_id;
		end if;

		insert into inst_party_phones (
				phone_id, party_id, phone_type_id, description, phone_number, phone_priority_number
			) values (
				v_phone_id, owner_id, v_type_id, description, phone_number, priority_number
		);

		acs_permission.grant_permission (
			object_id			=> v_phone_id,
			grantee_id			=> owner_id,
			privilege			=> 'admin'
		);

		return v_phone_id;
	end new;

	-- destructor --
	procedure delete (
		phone_id		in inst_party_phones.phone_id%TYPE
	) is
		v_phone_id		integer;
	begin
		v_phone_id := phone_id;

		delete from acs_rels
		where object_id_one = v_phone_id
		   or object_id_two = v_phone_id;

		delete from acs_permissions
		where object_id = v_phone_id;

		delete from inst_party_phones
		where phone_id = v_phone_id;

		acs_object.delete(v_phone_id);
	end delete;
end inst_party_phone;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
