-- -*- tab-width: 4 -*- --
--
-- packages/ctrl-categories/sql/postgres/categories-oacsmd-create.sql
--
-- OpenACS MetaData for a simple category module (similar to the ACS 3.4.10
-- category module)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @author			cnk@caltech.edu (CNK) -- postgres port
-- @creation-date	2008-07-20
-- @cvs-id			$Id:$
--

-- Create a new object type for categories
create or replace function inline_0 ()
returns integer as '
begin
PERFORM acs_object_type__create_type (
        ''ctrl_category'',            -- object_type              
        ''CTRL Category'',            -- pretty_name              
        ''CTRL Categories'',          -- pretty_plural            
        ''acs_object'',               -- supertype                
        ''ctrl_categories'',          -- table_name               
        ''category_id'',              -- id_column                
        null,                         -- package_name             
        ''f'',                        -- abstract_p               
        null,                         -- type_extensions_table    
        ''ctrl_category__name''  	  -- name_method              
    );
    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

-- Register the attributes
create or replace function inline_1 ()
returns integer as '
begin
-- Register the meta-data for APM-packages                                                                                    
 PERFORM acs_attribute__create_attribute (
        ''ctrl_category'',
        ''name'',
        ''string'',
        ''Name'',
        ''Names'',
        null,
        null,
        null,
        1,
        1,
        null,
        ''type_specific'',
        ''f''
);

 PERFORM acs_attribute__create_attribute (
        ''ctrl_category'',
        ''plural'',
        ''string'',
        ''Plural'',
        ''Plurals'',
        null,
        null,
        null,
        1,
        1,
        null,
        ''type_specific'',
        ''f''
 );

 PERFORM acs_attribute__create_attribute (
        ''ctrl_category'',
        ''description'',
        ''string'',
        ''Description'',
        ''Descriptions'',
        null,
        null,
        null,
        1,
        1,
        null,
        ''type_specific'',
        ''f''
 );

 PERFORM acs_attribute__create_attribute (
        ''ctrl_category'',
        ''enabled_p'',
        ''integer'',
        ''Enabled?'',
        ''Enabled?'',
        null,
        null,
        null,
        1,
        1,
        null,
        ''type_specific'',
        ''f''
 );

 PERFORM acs_attribute__create_attribute (
        ''ctrl_category'',
        ''profiling_weight'',
        ''integer'',
        ''Profiling Weight'',
        ''Profiling Weights'',
        null,
        null,
        null,
        1,
        1,
        null,
        ''type_specific'',
        ''f''
 );

 return 0;   
end;' language 'plpgsql';

select inline_1 ();

drop function inline_1 ();


