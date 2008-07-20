declare
	v_contact_info_top_level_id integer;
begin
	select category_id into v_contact_info_top_level_id
	  from categories
	 where parent_category_id is null
	   and name = 'Contact Information';

	-- this may have to change for hierarchies of greater depth
	delete from categories where parent_category_id = v_contact_info_top_level_id;
	delete from categories where category_id = v_contact_info_top_level_id;
end;
/