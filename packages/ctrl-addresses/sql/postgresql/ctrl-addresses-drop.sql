-- /packages/ctrl-addresses/sql/oracle/ctrl-addresses-drop.sql
-- 
-- Drop Script for CTRL Addresses
-- 
-- @author jmhek@cs.ucla.edu
-- @author cnk@ugcs.caltech.edu
-- @creation-date 08/16/2008
-- @cvs-id $Id:$
--

create function inline_0 ()
returns integer as '
declare
    d     record;
begin
      -- drop instances
      FOR d in (select object_id from acs_objects where object_type = ''ctrl_address'') LOOP
	  PERFORM ctrl_address__delete(d.object_id);
      END LOOP;

    return null;

end;' language 'plpgsql';

select inline_0 ();
drop function inline_0(); 


-- drop plpgsql package
select drop_package('ctrl_address');

select acs_object_type__drop_type('ctrl_address', 'f');

drop table ctrl_addresses;
