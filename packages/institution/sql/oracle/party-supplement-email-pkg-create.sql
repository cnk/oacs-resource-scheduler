-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-email-pkg-create.sql
--
-- Package for holding email addresses of parties.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-13
-- @cvs-id $Id: party-supplement-email-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- EMAIL ADDRESS --------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_party_email
as
	-- constructor --
	function new (
		email_id		in inst_party_emails.email_id%TYPE		default null,
		owner_id		in inst_party_emails.party_id%TYPE,
		type_id			in inst_party_emails.email_type_id%TYPE	default null,
		description		in inst_party_emails.description%TYPE	default null,
		email			in inst_party_emails.email%TYPE,

		object_type		in acs_object_types.object_type%TYPE	default 'email_address',
		creation_date	in acs_objects.creation_date%TYPE		default sysdate,
		creation_user	in acs_objects.creation_user%TYPE		default null,
		creation_ip		in acs_objects.creation_ip%TYPE			default null,
		context_id		in acs_objects.context_id%TYPE			default null
	) return inst_party_emails.email_id%TYPE;

	-- destructor --
	procedure delete (
		email_id		in inst_party_emails.email_id%TYPE
	);
end inst_party_email;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_party_email
as
	-- constructor -- allows augmenting/mutation of other objects at runtime
	function new (
		email_id		in inst_party_emails.email_id%TYPE		default null,
		owner_id		in inst_party_emails.party_id%TYPE,
		type_id			in inst_party_emails.email_type_id%TYPE	default null,
		description		in inst_party_emails.description%TYPE	default null,
		email			in inst_party_emails.email%TYPE,

		object_type		in acs_object_types.object_type%TYPE	default 'email_address',
		creation_date	in acs_objects.creation_date%TYPE		default sysdate,
		creation_user	in acs_objects.creation_user%TYPE		default null,
		creation_ip		in acs_objects.creation_ip%TYPE			default null,
		context_id		in acs_objects.context_id%TYPE			default null
	) return inst_party_emails.email_id%TYPE
	is
		v_email_id			integer;
		v_obj_exists_p		integer;
		v_obj_type			acs_objects.object_type%TYPE;
		v_email_exists_p	integer;
		v_type_id			integer;
		unused				integer;
	begin
		v_obj_exists_p := 1;
		v_obj_type := null;

		v_email_exists_p := 1;

		begin
			select object_type into v_obj_type
			  from acs_objects
			 where object_id = inst_party_email.new.email_id;
			exception when no_data_found then v_obj_exists_p := 0;
		end;

		begin
			select 1 into unused from inst_party_emails where email_id = inst_party_email.new.email_id;
			exception when no_data_found then v_email_exists_p := 0;
		end;

		if v_email_exists_p = 1 and v_email_exists_p = v_obj_exists_p then
			raise_application_error(-20000,
				'Email address exists already: email_id/object_id = ' ||
				v_email_id || '.'
			);
		end if;

		v_email_id := inst_party_email.new.email_id;

		if email_id is not null and v_obj_exists_p = 1 then
			if v_obj_type <> 'email_address' then
				raise_application_error(-20000,
					'Attempted to create email address object that already ' ||
					'exists and is not a email address: email_id/object_id = ' ||
					v_email_id || '.'
				);
			end if;
		else
			v_email_id := acs_object.new (
				object_id		=> v_email_id,
				object_type		=> object_type,
				creation_date	=> creation_date,
				creation_user	=> creation_user,
				creation_ip		=> creation_ip,
				context_id		=> context_id
			);
		end if;

		-- use a default type_id if it's null
		if type_id is null then
			v_type_id := category.lookup('//Contact Information//Email//Email Address');
		else
			v_type_id := inst_party_email.new.type_id;
		end if;

		if v_email_exists_p = 0 then
			insert into inst_party_emails (
					email_id, party_id, email_type_id, description, email
				) values (
					v_email_id, owner_id, v_type_id, description, email
			);
		end if;

		acs_permission.grant_permission (
			object_id			=> v_email_id,
			grantee_id			=> owner_id,
			privilege			=> 'admin'
		);

		return v_email_id;
	end new;

	-- destructor --
	procedure delete (
		email_id		in inst_party_emails.email_id%TYPE
	) is
		v_email_id		integer;
	begin
		v_email_id := email_id;

		delete from acs_rels
		where object_id_one = v_email_id
		   or object_id_two = v_email_id;

		delete from acs_permissions
		where object_id = v_email_id;

		delete from inst_party_emails
		where email_id = v_email_id;

		acs_object.delete(v_email_id);
	end delete;
end inst_party_email;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
