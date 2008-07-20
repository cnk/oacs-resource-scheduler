alter table inst_personnel add meta_keywords varchar2(4000);

declare
	attr_id			acs_attributes.attribute_id%TYPE;
begin

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'inst_personnel',
		attribute_name	=> 'META_KEYWORDS',
		pretty_name	=> 'Meta Keyword',
		pretty_plural	=> 'Meta Keywords',
		datatype	=> 'string'
	);

end;
/
show errors;

@../personnel-pkg-create.sql

commit;

