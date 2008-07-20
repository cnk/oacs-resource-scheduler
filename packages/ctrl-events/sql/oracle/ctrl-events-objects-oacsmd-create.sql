-- /packages/events/sql/oracle/event-oacsmd-create.sql
--
-- CTRL Events OACS Objects and Attributes
--
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 04/15/2005
-- @cvs-id $Id: ctrl-events-objects-oacsmd-create.sql,v 1.1 2006/11/21 20:31:52 avni Exp $
--

-- create object type -----------------------------------------
begin
	acs_object_type.create_type (
	    supertype     => 'acs_object',
	    object_type   => 'ctrl_event_object',
	    pretty_name   => 'CTRL Event Object',
	    pretty_plural => 'CTRL Event Objects',
	    table_name    => 'ctrl_events_objects',
	    id_column     => 'event_object_id'
        );
end;
/
show errors;
-- end create object type ------------------------------------

-- create attributes -----------------------------------------
declare
	attr_id acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event_object',
		attribute_name	=> 'event_object_id',
		pretty_name	=> 'Event Object Id',
		pretty_plural	=> 'Event Object Ids',
		datatype	=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event_object',
		attribute_name  => 'name',
		pretty_name	=> 'Name',
		pretty_plural	=> 'Names',
		datatype	=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event_object',
		attribute_name  => 'object_type_id',
		pretty_name	=> 'Object Type Id',
		pretty_plural	=> 'Object Type Ids',
		datatype	=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event_object',
		attribute_name  => 'description',
		pretty_name	=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype	=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event_object',
		attribute_name  => 'url',
		pretty_name	=> 'URL',
		pretty_plural	=> 'URLs',
		datatype	=> 'string'
	);

end;
/
show errors;

-- end create attributes -------------------------------------
