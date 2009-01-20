-- /packages/events/sql/oracle/event-oacsmd-create.sql
--
-- CTRL Events OACS Objects and Attributes
--
-- @creation-date 04/15/2005
-- @update-date 08/30/2008 (ported to postgres)
--
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @cvs-id $Id: ctrl-events-objects-oacsmd-create.sql,v 1.1 2006/11/21 20:31:52 avni Exp $
--

create function inline_0 ()
returns integer as '
begin
	 -- create object type -----------------------------------------
	 PERFORM acs_object_type__create_type (
		''ctrl_event_object'',		-- object_type              	
		''CTRL Event Object'',		-- pretty_name              
		''CTRL Event Objects'',		-- pretty_plural            
		''acs_object'',			-- supertype                
		''ctrl_event_objects'',		-- table_name               
		''event_object_id'',		-- id_column          
	    	null,          			-- package_name
	    	''f'',				-- abstract_p
	    	null,				-- type_extensions_table
	   	''ctrl_event_object__name''  	-- name_method              
	 );
	-- end create object type ------------------------------------

	return 0;

end;' language 'plpgsql';

select inline_0();
drop function inline_0();


create function inline_1 ()
returns integer as '
begin 
	-- create attributes -----------------------------------------
	PERFORM acs_attribute__create_attribute (
	 ''ctrl_event_object'',		-- object_type
	 ''event_object_id'',		-- attribute_name
	 ''integer'',			-- datatype
	 ''Event Object Id'',		-- pretty_name
	 ''Event Object Ids'',		-- pretty_plural
	  null,				-- table_name
	  null,				-- column_name
	  null,				-- default_value
	  1,				-- min_n_values
	  1,				-- max_n_values
	  null,				-- sort_order
	 ''type_specific'',	        -- storage
	 ''f''				-- static_p
	);

	PERFORM acs_attribute__create_attribute (
	 ''ctrl_event_object'',		-- object_type
	 ''name'',			-- attribute_name
	 ''string'',			-- datatype
	 ''Name'',			-- pretty_name
	 ''Names'',			-- pretty_plural
	  null,				-- table_name
	  null,				-- column_name
	  null,				-- default_value
	  1,				-- min_n_values
	  1,				-- max_n_values
	  null,				-- sort_order
	  ''type_specific'',	        -- storage
	  ''f''				-- static_p
	);

	PERFORM acs_attribute__create_attribute (
	 ''ctrl_event_object'',		-- object_type
	 ''object_type'',		-- attribute_name
	 ''integer'',			-- datatype
	 ''Object Type Id'',		-- pretty_name
	 ''Object Type Ids'',		-- pretty_plural
	  null,				-- table_name
	  null,				-- column_name
	  null,				-- default_value
	  1,				-- min_n_values
	  1,				-- max_n_values
	  null,				-- sort_order
	  ''type_specific'',	        -- storage
	  ''f''				-- static_p
	);

	PERFORM acs_attribute__create_attribute (
	 ''ctrl_event_object'',		-- object_type
	 ''description'',		-- attribute_name
	 ''string'',			-- datatype
	 ''Description'',		-- pretty_name
	 ''Descriptions'',		-- pretty_plural
	  null,				-- table_name
	  null,				-- column_name
	  null,				-- default_value
	  1,				-- min_n_values
	  1,				-- max_n_values
	  null,				-- sort_order
	  ''type_specific'',	        -- storage
	  ''f''				-- static_p
	);

	PERFORM acs_attribute__create_attribute (
	 ''ctrl_event_object'',		-- object_type
	 ''url'',			-- attribute_name
	 ''string'',			-- datatype
	 ''URL'',			-- pretty_name
	 ''URLs'',			-- pretty_plural
	  null,				-- table_name
	  null,				-- column_name
	  null,				-- default_value
	  1,				-- min_n_values
	  1,				-- max_n_values
	  null,				-- sort_order
	  ''type_specific'',	        -- storage
	  ''f''				-- static_p
	);	

	-- end create attributes -------------------------------------

	return 0;

end;' language 'plpgsql';

select inline_1();
drop function inline_1();
