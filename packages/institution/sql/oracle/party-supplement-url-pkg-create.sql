-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-url-pkg-create.sql
--
-- Package for maintaining URLs of parties.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-13
-- @cvs-id $Id: party-supplement-url-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- URL --------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_party_url
as
	-- constructor --
	function new (
		url_id			in inst_party_urls.url_id%TYPE			default null,
		owner_id		in inst_party_urls.party_id%TYPE,
		type_id			in inst_party_urls.url_type_id%TYPE		default null,
		description		in inst_party_urls.description%TYPE		default null,
		url				in inst_party_urls.url%TYPE,

		object_type		in acs_object_types.object_type%TYPE	default 'url',
		creation_date	in acs_objects.creation_date%TYPE		default sysdate,
		creation_user	in acs_objects.creation_user%TYPE		default null,
		creation_ip		in acs_objects.creation_ip%TYPE			default null,
		context_id		in acs_objects.context_id%TYPE			default null
	) return inst_party_urls.url_id%TYPE;

	-- destructor --
	procedure delete (
		url_id		in inst_party_urls.url_id%TYPE
	);
end inst_party_url;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_party_url
as
	-- constructor -- allows augmenting/mutation of other objects at runtime
	function new (
		url_id			in inst_party_urls.url_id%TYPE			default null,
		owner_id		in inst_party_urls.party_id%TYPE,
		type_id			in inst_party_urls.url_type_id%TYPE		default null,
		description		in inst_party_urls.description%TYPE		default null,
		url				in inst_party_urls.url%TYPE,

		object_type		in acs_object_types.object_type%TYPE	default 'url',
		creation_date	in acs_objects.creation_date%TYPE		default sysdate,
		creation_user	in acs_objects.creation_user%TYPE		default null,
		creation_ip		in acs_objects.creation_ip%TYPE			default null,
		context_id		in acs_objects.context_id%TYPE			default null
	) return inst_party_urls.url_id%TYPE
	is
		v_url_id		integer;
		v_obj_exists_p	integer;
		v_obj_type		acs_objects.object_type%TYPE;
		v_url_exists_p	integer;
		v_type_id		integer;
		unused			integer;
	begin
		v_obj_exists_p := 1;
		v_obj_type := null;

		v_url_exists_p := 1;

		begin
			select object_type into v_obj_type
			  from acs_objects
			 where object_id = inst_party_url.new.url_id;
			exception when no_data_found then v_obj_exists_p := 0;
		end;

		begin
			select 1 into unused from inst_party_urls where url_id = inst_party_url.new.url_id;
			exception when no_data_found then v_url_exists_p := 0;
		end;

		if v_url_exists_p = 1 and v_url_exists_p = v_obj_exists_p then
			raise_application_error(-20000,
				'URL exists already: url_id/object_id = ' ||
				v_url_id || '.'
			);
		end if;

		v_url_id := inst_party_url.new.url_id;

		if url_id is not null and v_obj_exists_p = 1 then
			if v_obj_type <> 'url' then
				raise_application_error(-20000,
					'Attempted to create url object that already ' ||
					'exists and is not a url: url_id/object_id = ' ||
					v_url_id || '.'
				);
			end if;
		else
			v_url_id := acs_object.new (
				object_id		=> v_url_id,
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
			v_type_id := inst_party_url.new.type_id;
		end if;

		if v_url_exists_p = 0 then
			insert into inst_party_urls (
					url_id, party_id, url_type_id, description, url
				) values (
					v_url_id, owner_id, v_type_id, description, url
			);
		end if;

		acs_permission.grant_permission (
			object_id			=> v_url_id,
			grantee_id			=> owner_id,
			privilege			=> 'admin'
		);

		return v_url_id;
	end new;

	-- destructor --
	procedure delete (
		url_id		in inst_party_urls.url_id%TYPE
	) is
		v_url_id	integer;
	begin
		v_url_id := url_id;

		delete from acs_rels
		where object_id_one = v_url_id
		   or object_id_two = v_url_id;

		delete from acs_permissions
		where object_id = v_url_id;

		delete from inst_party_urls
		where url_id = v_url_id;

		acs_object.delete(v_url_id);
	end delete;
end inst_party_url;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
