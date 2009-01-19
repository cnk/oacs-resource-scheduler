-- /packages/ctrl-addresses/sql/oracle/ctrl-addresses-drop.sql
-- 
-- Drop Script for CTRL Addresses
-- 
-- @author jmhek@cs.ucla.edu
-- @creation-date 12/06/2005
-- @cvs-id $Id: ctrl-addresses-drop.sql,v 1.1 2005/12/13 00:31:36 jwang1 Exp $
--

begin
      FOR d in (select object_id from acs_objects where object_type = 'ctrl_address') LOOP
	  ctrl_address.del(d.object_id);
      END LOOP;
      acs_object_type.drop_type('ctrl_address');
end;
/
show errors

drop package ctrl_address;

drop table ctrl-addresses;
#execute acs_object_type.drop_type('ctrl_address');
