-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/publications-pkg-create.sql
--
-- Package for holding information directly related to publications.
--
-- @author nick@ucla.edu
-- @creation-date 2004-02-01
-- @cvs-id $Id: publication-pkg-create.sql,v 1.2 2007/01/26 02:02:30 andy Exp $
--

-- -----------------------------------------------------------------------------
-- --------------------------------- Publications ------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_publication
as
	-- constructor --
	function new (

		-- publications
		publication_id		in inst_publications.publication_id%TYPE	default null,
		title				in inst_publications.title%TYPE,
 		publication_name	in inst_publications.publication_name%TYPE	default null,
 		url					in inst_publications.url%TYPE				default null,
 		authors				in inst_publications.authors%TYPE			default null,
 		volume 				in inst_publications.volume%TYPE			default null,
 		issue				in inst_publications.issue%TYPE				default null,
 		year				in inst_publications.year%TYPE				default null,
 		publish_date		in inst_publications.publish_date%TYPE		default null,
		publication         in inst_publications.publication%TYPE		default empty_blob(),
		page_ranges			in inst_publications.page_ranges%TYPE		default null,
		publisher			in inst_publications.publisher%TYPE			default null,
		publication_type	in inst_publications.publication_type%TYPE	default null,
		priority_number		in inst_publications.priority_number%TYPE	default null,

		-- acs_object
		object_type			in acs_object_types.object_type%TYPE		default 'inst_publication',
		creation_date		in acs_objects.creation_date%TYPE			default sysdate,
		creation_user		in acs_objects.creation_user%TYPE			default null,
		creation_ip			in acs_objects.creation_ip%TYPE				default null,
		context_id			in acs_objects.context_id%TYPE				default null
	) return inst_publications.publication_id%TYPE;

	-- destructor --
	procedure delete (
		publication_id	in inst_publications.publication_id%TYPE
	);
end inst_publication;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_publication
as
	-- constructor --
	function new (
		-- publications
		publication_id			in inst_publications.publication_id%TYPE	default null,
		title					in inst_publications.title%TYPE,
 		publication_name		in inst_publications.publication_name%TYPE	default null,
 		url						in inst_publications.url%TYPE				default null,
 		authors					in inst_publications.authors%TYPE			default null,
 		volume					in inst_publications.volume%TYPE			default null,
 		issue					in inst_publications.issue%TYPE				default null,
 		year					in inst_publications.year%TYPE				default null,
 		publish_date			in inst_publications.publish_date%TYPE		default null,
		publication				in inst_publications.publication%TYPE		default empty_blob(),
 		page_ranges				in inst_publications.page_ranges%TYPE		default null,
		publisher				in inst_publications.publisher%TYPE			default null,
		publication_type		in inst_publications.publication_type%TYPE	default null,
		priority_number			in inst_publications.priority_number%TYPE	default null,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE		default 'inst_publication',
		creation_date			in acs_objects.creation_date%TYPE			default sysdate,
		creation_user			in acs_objects.creation_user%TYPE			default null,
		creation_ip				in acs_objects.creation_ip%TYPE				default null,
		context_id				in acs_objects.context_id%TYPE				default null
	) return inst_publications.publication_id%TYPE
	is
		v_publication_id	integer;
		v_obj_exists_p		integer;
		v_obj_type			acs_objects.object_type%TYPE;
		v_psn_exists_p		integer;
		unused				integer;
	begin
		-- create corresponding person, use object_id if it's available
		v_publication_id		:= acs_object.new (
			object_type			=> object_type,
			creation_date		=> creation_date,
			creation_user		=> creation_user,
			creation_ip			=> creation_ip,
			context_id			=> context_id
		);

		insert into inst_publications (
				publication_id,
				title,
				publication_name,
				url,
				authors,
				volume,
				issue,
				page_ranges,
				year,
				publish_date,
				publisher,
				priority_number
			) values (
				v_publication_id,
				title,
				publication_name,
				url,
				authors,
				volume,
				issue,
				page_ranges,
				year,
				publish_date,
				publisher,
				priority_number
		);


		if creation_user is not null then
			acs_permission.grant_permission (
				object_id			=> v_publication_id,
				grantee_id			=> creation_user,
				privilege			=> 'admin'
			);
		end if;

		return v_publication_id;
	end new;

	-- destructor --
	procedure delete (
		publication_id	in inst_publications.publication_id%TYPE
	) is
		v_publication_id	integer;
	begin
		v_publication_id := publication_id;

		delete 	from inst_external_pub_id_map
		where	inst_publication_id = v_publication_id;

		delete 	from inst_publications
		where 	publication_id = v_publication_id;

		acs_object.delete(v_publication_id);
	end delete;

end inst_publication;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
