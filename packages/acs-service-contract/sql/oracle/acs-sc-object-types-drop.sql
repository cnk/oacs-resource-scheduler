-- $Id: acs-sc-object-types-drop.sql,v 1.1 2001-09-19 22:59:01 donb Exp $
begin
   delete from acs_objects where object_type ='acs_sc_implementation';
   acs_object_type.drop_type('acs_sc_implementation');

   delete from acs_objects where object_type ='acs_sc_operation';
   acs_object_type.drop_type('acs_sc_operation');
 
   delete from acs_objects where object_type ='acs_sc_contract';
   acs_object_type.drop_type('acs_sc_contract');   
end;
/
show errors

