declare
	v_contact_info_top_level_id integer;
begin
	select categories_sequence.nextval into v_contact_info_top_level_id from dual;

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		v_contact_info_top_level_id,
		null, 0, 't', 'Contact Information', 'Information related to contacting a party.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		1, 't', 'Home', 'Information for contacting a party at home.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		0, 't', 'Work', 'Information for contacting a party at work.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		2, 't', 'Other', ''
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		4, 't', 'Appointment', 'A contact to schedule an appointment.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		3, 't', 'Information', 'A contact to get information.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		5, 't', 'Referral', 'A contact to get assistance in finding a contact.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		6, 't', 'Fax', 'A contact to send facsimiles to.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		7, 't', 'Pager', 'A contact to page a party.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		8, 't', 'Mobile', 'A contact to reach a party wherever they may be.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		9, 't', 'Mailing', 'A contact to related to a mailing location.'
	);

	insert into categories (
		category_id, parent_category_id, profiling_weight, enabled_p, name, description
	) values (
		categories_sequence.nextval, v_contact_info_top_level_id,
		10, 't', 'Shipping', 'A contact to related to a shipping location (for larger things than Mailings).'
	);

end;
/