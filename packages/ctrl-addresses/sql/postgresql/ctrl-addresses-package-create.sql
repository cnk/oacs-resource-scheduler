-- -*- tab-width: 4 -*- --
--
-- /packages/ctrl-addresses/sql/oracle/ctrl-addresses-pkg-create.sql
--
-- CTRL Addresses Package Declaration
-- 
-- @author jmhek@cs.ucla.edu
-- @author cnk@ugcs.caltech.edu
-- @creation-date 08/16/2008
-- @cvs-id $Id:$
-- 

-- function new  --------------------------------------------------------------

select define_function_args('ctrl_address__new','address_id,address_type_id,description,room,floor,building_id,address_line_1,address_line_2,address_line_3,address_line_4,address_line_5,city,fips_state_code,zipcode,zipcode_ext,fips_country_code,gis,creation_date;sysdate,creation_user,object_type:''ctrl_address'',creation_ip,context_id');

create or replace function ctrl_address__new (ctrl_addresses.address_id%TYPE, ctrl_addresses.address_type_id%TYPE, ctrl_addresses.description%TYPE, ctrl_addresses.room%TYPE, ctrl_addresses.floor%TYPE, ctrl_addresses.building_id%TYPE, ctrl_addresses.address_line_1%TYPE, ctrl_addresses.address_line_2%TYPE, ctrl_addresses.address_line_3%TYPE, ctrl_addresses.address_line_4%TYPE, ctrl_addresses.address_line_5%TYPE, ctrl_addresses.city%TYPE, ctrl_addresses.fips_state_code%TYPE, ctrl_addresses.zipcode%TYPE, ctrl_addresses.zipcode_ext%TYPE, ctrl_addresses.fips_country_code%TYPE, ctrl_addresses.gis%TYPE, acs_objects.creation_date%TYPE, acs_objects.creation_user%TYPE, acs_object_types.object_type%TYPE, acs_objects.creation_ip%TYPE, acs_objects.context_id%TYPE)
returns ctrl_addresses.address_id%TYPE as '
declare 
        p_address_id			alias for $1; 
       	p_address_type_id		alias for $2;                  
	p_description			alias for $3;   -- default null
	p_room				alias for $4;   -- default null
	p_floor				alias for $5;   -- default null
	p_building_id			alias for $6;   -- default null
	p_address_line_1		alias for $7;   
	p_address_line_2		alias for $8;   -- default null
	p_address_line_3		alias for $9;   -- default null
	p_address_line_4		alias for $10;  -- default null
	p_address_line_5		alias for $11;  -- default null
	p_city				alias for $12;  -- default null
	p_fips_state_code		alias for $13;
	p_zipcode			alias for $14;
	p_zipcode_ext			alias for $15;  -- default null
	p_fips_country_code		alias for $16;   
	p_gis				alias for $17;  -- default null
	creation_date			alias for $18;  -- default current_time
	creation_user			alias for $19;  -- default null
	object_type			alias for $20;  -- default ''ctrl_address''
	creation_ip			alias for $21;  -- default null
	context_id			alias for $22;  -- default null
	v_address_id                    acs_objects.object_id%TYPE;
        v_creation_date                 date;
	v_object_type                   acs_object_types.object_type%TYPE;
   begin
        -- default some info so I only need a brief or complete signature
        if creation_date is null then
            select current_time into v_creation_date;
        else
            v_creation_date := creation_date;
        end if;

        if object_type is null then
            v_object_type := ''ctrl_address'';    
        else
            v_object_type := object_type;
        end if;

	v_address_id := acs_object__new (
                p_address_id, 
                v_object_type, 
                v_creation_date,
	        creation_user,
                creation_ip,
	        context_id
	);

	insert into ctrl_addresses (
		address_id, address_type_id, description, room, floor, building_id,
		address_line_1, address_line_2, address_line_3, address_line_4, address_line_5,
		city, fips_state_code, zipcode, zipcode_ext, fips_country_code, gis
	) values (
		v_address_id, p_address_type_id, p_description, p_room, p_floor, p_building_id,
		p_address_line_1, p_address_line_2, p_address_line_3, p_address_line_4, p_address_line_5,
		p_city, p_fips_state_code, p_zipcode, p_zipcode_ext, p_fips_country_code, p_gis
	);

	return v_address_id;
end;' language 'plpgsql';


   
-- function delete  --------------------------------------------------------------

select define_function_args('ctrl_address__delete','address_id');

create or replace function ctrl_address__delete (integer)
returns integer as '
declare
	address_id              alias for $1;
begin
	PERFORM acs_object__delete(address_id);
        return 0;
end;' language 'plpgsql';

 
create function inline_0 ()
returns integer as '
begin 
	-- create object type -----------------------------------------
	PERFORM acs_object_type__create_type (
	    ''ctrl_address'',		-- object_type 
	    ''CTRL Address'',		-- pretty_name   
	    ''CTRL Addresses'',		-- pretty_plural 
	    ''acs_object'', 		-- supertype 
	    ''ctrl_addresses'',		-- table_name    
	    ''address_id'',		-- id_column 
	    null,          		-- package_name
	    ''f'',			-- abstract_p
	    null,			-- type_extensions_table
	    null                        -- name_method
        );
	-- end create object type ------------------------------------

	return 0;

end;' language 'plpgsql';

select inline_0();
drop function inline_0();


create function inline_1 ()
returns integer as '
begin 
--- create object attributes -----------------------------------------
    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''address_type_id'',    -- attribute_name     
        ''number'' ,            -- datatype
        ''Address Type ID'',    -- pretty_name
        ''Address Type IDs'',   -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''description'',        -- attribute_name     
        ''string'' ,            -- datatype
        ''Description'',        -- pretty_name
        ''Descriptions'',       -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''room'',               -- attribute_name     
        ''string'' ,            -- datatype
        ''Room'',               -- pretty_name
        ''Rooms'',              -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''floor'',              -- attribute_name     
        ''string'' ,            -- datatype
        ''Floor'',              -- pretty_name
        ''Floors'',             -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''building_id'',        -- attribute_name     
        ''string'' ,            -- datatype
        ''Building ID'',        -- pretty_name
        ''Building IDs'',       -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''address_line_1'',     -- attribute_name     
        ''string'' ,            -- datatype
        ''Address Line 1'',     -- pretty_name
        ''Addresses Line 1'',   -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''address_line_2'',     -- attribute_name     
        ''string'' ,            -- datatype
        ''Address Line 2'',     -- pretty_name
        ''Addresses Line 2'',   -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''address_line_3'',     -- attribute_name     
        ''string'' ,            -- datatype
        ''Address Line 3'',     -- pretty_name
        ''Addresses Line 3'',   -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''address_line_4'',     -- attribute_name     
        ''string'' ,            -- datatype
        ''Address Line 4'',     -- pretty_name
        ''Addresses Line 4'',   -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''address_line_5'',     -- attribute_name     
        ''string'' ,            -- datatype
        ''Address Line 5'',     -- pretty_name
        ''Addresses Line 5'',   -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''city'',               -- attribute_name     
        ''string'' ,            -- datatype
        ''City'',               -- pretty_name
        ''Cities'',             -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''fips_state_code'',    -- attribute_name     
        ''string'' ,            -- datatype
        ''State Code'',         -- pretty_name
        ''State Codes'',        -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''zipcode'',            -- attribute_name     
        ''string'' ,            -- datatype
        ''Zip Code'',           -- pretty_name
        ''Zip Codes'',          -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''zipcode_ext'',        -- attribute_name     
        ''string'' ,            -- datatype
        ''Zip Code Extension'', -- pretty_name
        ''Zip Code Extensions'', -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''fips_country_code'',  -- attribute_name     
        ''string'' ,            -- datatype
        ''Country Code'',       -- pretty_name
        ''Country Codes'',      -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    PERFORM acs_attribute__create_attribute (
        ''ctrl_address'',       -- object_type
        ''gis'',                -- attribute_name     
        ''string'' ,            -- datatype
        ''GIS'',                -- pretty_name
        ''GISs'',               -- pretty_plural
        null,                   -- table_name
        null,                   -- column_name
        null,                   -- default_value
        1,                      -- min_n_values           
        1,                      -- max_n_values           
        null,                   -- sort_order             
        ''type_specific'',      -- storage                
        ''f''                   -- static_p               
    );

    return 0;
end;' language 'plpgsql';

select inline_1();
drop function inline_1();



