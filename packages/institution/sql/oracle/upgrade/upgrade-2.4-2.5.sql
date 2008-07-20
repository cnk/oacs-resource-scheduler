alter table inst_groups add keywords varchar2(4000);

declare
	attr_id			acs_attributes.attribute_id%TYPE;
begin

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_group',
		attribute_name	=> 'KEYWORDS',
		pretty_name		=> 'Keyword',
		pretty_plural	=> 'Keywords',
		datatype		=> 'string'
	);

end;
/
show errors;

@../group-pkg-create.sql

commit;
