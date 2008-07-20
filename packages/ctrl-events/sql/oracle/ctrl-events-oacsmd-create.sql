-- /packages/events/sql/oracle/event-oacsmd-create.sql
--
-- CTRL Events OACS Objects and Attributes
--
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 04/15/2005
-- @cvs-id $Id: ctrl-events-oacsmd-create.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
--

-- create object type -----------------------------------------
begin
	acs_object_type.create_type (
	    supertype     => 'acs_object',
	    object_type   => 'ctrl_event',
	    pretty_name   => 'CTRL Event',
	    pretty_plural => 'CTRL Events',
	    table_name    => 'ctrl_events',
	    id_column     => 'event_id'
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
		object_type	=> 'ctrl_event',
		attribute_name	=> 'event_id',
		pretty_name	=> 'Event Id',
		pretty_plural	=> 'Event Ids',
		datatype	=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'event_object_id',
		pretty_name	=> 'Event Object Id',
		pretty_plural	=> 'Event Object Ids',
		datatype	=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'title',
		pretty_name	=> 'Title',
		pretty_plural	=> 'Titles',
		datatype	=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'start_date',
		pretty_name	=> 'Start Date',
		pretty_plural	=> 'Start Dates',
		datatype	=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'end_date',
		pretty_name	=> 'End Date',
		pretty_plural	=> 'End Dates',
		datatype	=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'all_day_p',
		pretty_name	=> 'All Day Event Boolean',
		pretty_plural	=> 'All Day Event Booleans',
		datatype	=> 'boolean'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'location',
		pretty_name	=> 'Location',
		pretty_plural	=> 'Locations',
		datatype	=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'notes',
		pretty_name	=> 'Notes',
		pretty_plural	=> 'Notes',
		datatype	=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'ctrl_event',
		attribute_name  => 'capacity',
		pretty_name	=> 'Capacity',
		pretty_plural	=> 'Capacity',
		datatype	=> 'integer'
	);
end;
/
show errors;

-- end create attributes -------------------------------------
