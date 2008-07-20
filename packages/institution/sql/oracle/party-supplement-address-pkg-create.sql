-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-pkg-create.sql
--
-- Package for holding information about parties (Supplementary Party Information)
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-05
-- @cvs-id $Id: party-supplement-address-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------------------- ADDRESS ----------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_party_address
as
	-- constructor --
	function new (
		address_id		in inst_party_addresses.address_id%TYPE			default null,
		owner_id		in inst_party_addresses.party_id%TYPE,
		type_id			in inst_party_addresses.address_type_id%TYPE	default null,

		description		in inst_party_addresses.description%TYPE		default null,
		building_name	in inst_party_addresses.building_name%TYPE		default null,
		room_number		in inst_party_addresses.room_number%TYPE		default null,

		address_line_1	in inst_party_addresses.address_line_1%TYPE,
		address_line_2	in inst_party_addresses.address_line_2%TYPE		default null,
		address_line_3	in inst_party_addresses.address_line_3%TYPE		default null,
		address_line_4	in inst_party_addresses.address_line_4%TYPE		default null,
		address_line_5	in inst_party_addresses.address_line_5%TYPE		default null,

		city			in inst_party_addresses.city%TYPE				default null,
		state_code		in inst_party_addresses.fips_state_code%TYPE	default null,
		zipcode			in inst_party_addresses.zipcode%TYPE			default null,
		zipcode_ext		in inst_party_addresses.zipcode_ext%TYPE		default null,
		country_code	in inst_party_addresses.fips_country_code%TYPE	default null,

		object_type		in acs_object_types.object_type%TYPE			default 'address',
		creation_date	in acs_objects.creation_date%TYPE				default sysdate,
		creation_user	in acs_objects.creation_user%TYPE				default null,
		creation_ip		in acs_objects.creation_ip%TYPE					default null,
		context_id		in acs_objects.context_id%TYPE					default null
	) return inst_party_addresses.address_id%TYPE;

	-- destructor --
	procedure delete (
		address_id		in inst_party_addresses.address_id%TYPE
	);
end inst_party_address;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_party_address
as
	-- constructor --
	function new (
		address_id		in inst_party_addresses.address_id%TYPE			default null,
		owner_id		in inst_party_addresses.party_id%TYPE,
		type_id			in inst_party_addresses.address_type_id%TYPE	default null,

		description		in inst_party_addresses.description%TYPE		default null,
		building_name	in inst_party_addresses.building_name%TYPE		default null,
		room_number		in inst_party_addresses.room_number%TYPE		default null,

		address_line_1	in inst_party_addresses.address_line_1%TYPE,
		address_line_2	in inst_party_addresses.address_line_2%TYPE		default null,
		address_line_3	in inst_party_addresses.address_line_3%TYPE		default null,
		address_line_4	in inst_party_addresses.address_line_4%TYPE		default null,
		address_line_5	in inst_party_addresses.address_line_5%TYPE		default null,

		city			in inst_party_addresses.city%TYPE				default null,
		state_code		in inst_party_addresses.fips_state_code%TYPE	default null,
		zipcode			in inst_party_addresses.zipcode%TYPE			default null,
		zipcode_ext		in inst_party_addresses.zipcode_ext%TYPE		default null,
		country_code	in inst_party_addresses.fips_country_code%TYPE	default null,

		object_type		in acs_object_types.object_type%TYPE			default 'address',
		creation_date	in acs_objects.creation_date%TYPE				default sysdate,
		creation_user	in acs_objects.creation_user%TYPE				default null,
		creation_ip		in acs_objects.creation_ip%TYPE					default null,
		context_id		in acs_objects.context_id%TYPE					default null
	) return inst_party_addresses.address_id%TYPE
	is
		v_address_id	integer;
		v_adr_exists_p	integer := 1;
		v_obj_exists_p	integer := 1;
		v_obj_type		acs_objects.object_type%TYPE;
		v_type_id		integer;
		unused			integer;
	begin
		v_obj_exists_p := 1;
		v_obj_type := null;

		begin
			select object_type into v_obj_type
			  from acs_objects
			 where object_id = inst_party_address.new.address_id;
			exception when no_data_found then v_obj_exists_p := 0;
		end;

		select decode(count(*), 0, 0, 1) into v_adr_exists_p
		  from inst_party_addresses
		 where address_id					= inst_party_address.new.address_id
			or (party_id					= inst_party_address.new.owner_id
				and address_type_id			= inst_party_address.new.type_id
				and nvl(description, '1')	= nvl(inst_party_address.new.description, '1')
				and nvl(building_name, '1')	= nvl(inst_party_address.new.building_name, '1')
				and nvl(room_number, '1')	= nvl(inst_party_address.new.room_number, '1')

				and address_line_1				= inst_party_address.new.address_line_1
				and nvl(address_line_2, '1')	= nvl(inst_party_address.new.address_line_2, '1')
				and nvl(address_line_3, '1')	= nvl(inst_party_address.new.address_line_3, '1')
				and nvl(address_line_4, '1')	= nvl(inst_party_address.new.address_line_4, '1')
				and nvl(address_line_5, '1')	= nvl(inst_party_address.new.address_line_5, '1')

				and nvl(city, '1')				= nvl(inst_party_address.new.city, '1')
				and nvl(fips_state_code, '1')	= nvl(inst_party_address.new.state_code, '1')
				and nvl(zipcode, '1')			= nvl(inst_party_address.new.zipcode, '1')
				and nvl(zipcode_ext, '1')		= nvl(inst_party_address.new.zipcode_ext, '1')
				and nvl(fips_country_code, '1')	= nvl(inst_party_address.new.country_code, '1')
			);

		-- verify that state-code + zipcode are consistent
		if state_code is not null and zipcode is not null then
			declare
				t varchar(100);
			begin
				select fips_state_code || ', ' || zipcode into t
				  from us_zipcodes
				 where fips_state_code = state_code
				   and zipcode = inst_party_address.new.zipcode;
				exception when no_data_found then
				dbms_output.put_line('Invalid: ' || state_code || ', ' || zipcode);
			end;
		end if;

		if v_adr_exists_p = 1 and v_adr_exists_p = v_obj_exists_p then
			raise_application_error(-20000,
				'Address number exists already: address_id/object_id = ' ||
				v_address_id || '.'
			);
		end if;

		v_address_id := inst_party_address.new.address_id;

		if address_id is not null and v_obj_exists_p = 1 then
			if v_obj_type <> 'address' then
				raise_application_error(-20000,
					'Attempted to create address number object that already ' ||
					'exists and is not a address number: address_id/object_id = ' ||
					v_address_id || '.'
				);
			end if;
		else
			v_address_id := acs_object.new (
				object_id		=> address_id,
				object_type		=> object_type,
				creation_date	=> creation_date,
				creation_user	=> creation_user,
				creation_ip		=> creation_ip,
				context_id		=> context_id
			);
		end if;

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
			v_type_id := inst_party_address.new.type_id;
		end if;

		if v_adr_exists_p = 0 then
			insert into inst_party_addresses (
				address_id,
				party_id,
				address_type_id,
				description,
				building_name,
				room_number,
				address_line_1,
				address_line_2,
				address_line_3,
				address_line_4,
				address_line_5,
				city,
				fips_state_code,
				zipcode,
				zipcode_ext,
				fips_country_code
			) values (
				v_address_id,
				owner_id,
				v_type_id,
				description,
				building_name,
				room_number,
				address_line_1,
				address_line_2,
				address_line_3,
				address_line_4,
				address_line_5,
				city,
				state_code,
				zipcode,
				zipcode_ext,
				country_code
			);
		end if;

		acs_permission.grant_permission (
			object_id			=> v_address_id,
			grantee_id			=> owner_id,
			privilege			=> 'admin'
		);

		return v_address_id;
	end new;

	-- destructor --
	procedure delete (
		address_id		in inst_party_addresses.address_id%TYPE
	) is
		v_address_id		integer;
	begin
		v_address_id := address_id;

		delete from acs_rels
		where object_id_one = v_address_id
		   or object_id_two = v_address_id;

		delete from acs_permissions
		where object_id = v_address_id;

		delete from inst_party_addresses
		where address_id = v_address_id;

		acs_object.delete(v_address_id);
	end delete;
end inst_party_address;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
