declare
    attr_id  acs_attributes.attribute_id%TYPE;
begin
    acs_object_type.create_type (
        object_type        => 'ctrl_ccal_profile' ,
        pretty_name        => 'CTRL Calendar Profile',
        pretty_plural      => 'CTRL Calendar Profile',
        table_name         => 'ctrl_ccal_profiles',
        supertype          => 'acs_object',
        id_column          => 'profile_id'
    --  other parameters below
    --  abstract_p
    --  type_extension_table
    --  name_method
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_ccal_profile',
        attribute_name     => 'profile_name',
        datatype           => 'string' ,
        pretty_name        => 'profile name',
        pretty_plural      => 'profile names'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_ccal_profile',
        attribute_name     => 'owner_id',
        datatype           => 'number' ,
        pretty_name        => 'owner id',
        pretty_plural      => 'owner id'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_ccal_profile',
        attribute_name     => 'package_id',
        datatype           => 'number' ,
        pretty_name        => 'package id',
        pretty_plural      => 'package id'
    );
end;
/

@cc-user-profile-pkg-create
show errors;
commit;
