-- 
-- OACS Metadata for crs_request
-- 
-- @author Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-13
-- @cvs-id $Id$
--

declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'crs_request' ,
        pretty_name        => 'Resource Request',
        pretty_plural      => 'Resource Requests',
        table_name         => 'crs_requests',
        supertype          => 'acs_object',
        id_column          => 'request_id'
    --  other parameters below
    --  abstract_p         
    --  type_extension_table 
    --  name_method    
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_request',
        attribute_name     => 'name',
        datatype           => 'string' ,
        pretty_name        => 'name pretty name',
        pretty_plural      => 'name plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_request',
        attribute_name     => 'description',
        datatype           => 'string' ,
        pretty_name        => 'description pretty name',
        pretty_plural      => 'description plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_request',
        attribute_name     => 'status',
        datatype           => 'string' ,
        pretty_name        => 'status pretty name',
        pretty_plural      => 'status plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_request',
        attribute_name     => 'reserved_by',
        datatype           => 'number' ,
        pretty_name        => 'reserved_by pretty name',
        pretty_plural      => 'reserved_by plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_request',
        attribute_name     => 'requested_by',
        datatype           => 'string' ,
        pretty_name        => 'requested_by pretty name',
        pretty_plural      => 'requested_by plural pretty name'
    );
end;
/
show errors

commit;
