-- /packages/events/sql/oracle/event-oacsmd-create.sql
--
-- CTRL Events OACS Objects and Attributes
--
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 04/15/2005
-- @cvs-id $Id: ctrl-events-oacsmd-create.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
--


create function inline_0 ()
returns integer as '
begin 
	-- create object type -----------------------------------------
	PERFORM acs_object_type__create_type (
	    ''ctrl_event'',		-- object_type 
	    ''CTRL Event'',		-- pretty_name   
	    ''CTRL Events'',		-- pretty_plural 
	    ''acs_object'', 		-- supertype 
	    ''ctrl_events'',		-- table_name    
	    ''event_id'',		-- id_column 
	    null,          		-- package_name
	    ''f'',			-- abstract_p
	    null,			-- type_extensions_table
	   ''ctrl_events__title''       -- name_method              
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
	 ''ctrl_event'',		-- object_type
	 ''event_id'',			-- attribute_name
	 ''integer'',			-- datatype
	 ''Event Id'',			-- pretty_name
	 ''Event Ids'',			-- pretty_plural
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
	 ''ctrl_event'',		-- object_type
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
	 ''ctrl_event'',		-- object_type
	 ''title'',			-- attribute_name
	 ''string'',			-- datatype
	 ''Title'',			-- pretty_name
	 ''Titles'',			-- pretty_plural
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
	 ''ctrl_event'',		-- object_type
	 ''start_date'',		-- attribute_name
	 ''date'',			-- datatype
	 ''Start Date'',		-- pretty_name
	 ''Start Dates'',		-- pretty_plural
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
	 ''ctrl_event'',		-- object_type
	 ''end_date'',			-- attribute_name
	 ''date'',			-- datatype
	 ''End Date'',			-- pretty_name
	 ''End Dates'',			-- pretty_plural
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
	 ''ctrl_event'',		-- object_type
	 ''all_day_p'',			-- attribute_name
	 ''boolean'',			-- datatype
	 ''All Day Event Boolean'',	-- pretty_name
	 ''All Day Event Booleans'',	-- pretty_plural
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
	 ''ctrl_event'',		-- object_type
	 ''location'',			-- attribute_name
	 ''string'',			-- datatype
	 ''Location'',			-- pretty_name
	 ''Locations'',			-- pretty_plural
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
	 ''ctrl_event'',		-- object_type
	 ''notes'',			-- attribute_name
	 ''string'',			-- datatype
	 ''Notes'',			-- pretty_name
	 ''Notes'',			-- pretty_plural
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
	 ''ctrl_event'',		-- object_type
	 ''capacity'',			-- attribute_name
	 ''integer'',			-- datatype
	 ''Capacity'',			-- pretty_name
	 ''Capacity'',			-- pretty_plural
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

