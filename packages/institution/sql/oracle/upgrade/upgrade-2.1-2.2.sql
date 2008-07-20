alter table inst_personnel add status_id integer;
alter table inst_personnel add constraint inst_personnel_status_id_fk foreign key (status_id) references categories(category_id);

declare
	pcat0_id	integer := category.lookup('//Personnel Status');
	cat_id		integer;
begin
	cat_id		:= category.lookup('//Personnel Status//Active');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'Active',
								plural			=> 'Active',
								description		=> '');
	else
		update	categories
		   set	name		= 'Active',
				plural		= 'Active',
				description	= ''
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Status//Inactive');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'Inactive',
								plural			=> 'Inactive',
								description		=> '');
	else
		update	categories
		   set	name		= 'Inactive',
				plural		= 'Inactive',
				description	= ''
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Status//Deceased');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'Deceased',
								plural			=> 'Deceased',
								description		=> '');
	else
		update	categories
		   set	name		= 'Deceased',
				plural		= 'Deceased',
				description	= ''
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Status//Fired');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'Fired',
								plural			=> 'Fired',
								description		=> '');
	else
		update	categories
		   set	name		= 'Fired',
				plural		= 'Fired',
				description	= ''
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Status//Quit');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'Quit',
								plural			=> 'Quit',
								description		=> '');
	else
		update	categories
		   set	name		= 'Quit',
				plural		= 'Quit',
				description	= ''
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Status//On Leave');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'On Leave',
								plural			=> 'On Leave',
								description		=> '');
	else
		update	categories
		   set	name		= 'On Leave',
				plural		= 'On Leave',
				description	= ''
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Status//Retired');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'Retired',
								plural			=> 'Retired',
								description		=> '');
	else
		update	categories
		   set	name		= 'Retired',
				plural		= 'Retired',
				description	= ''
		 where	category_id = cat_id;
	end if;
end;
/

update inst_personnel set status_id =
(
	case
		when status = 'active'	then category.lookup('//Personnel Status//Active')
		when status = 'onleave'	then category.lookup('//Personnel Status//On Leave')
		when status = 'fired'	then category.lookup('//Personnel Status//Fired')
		when status = 'quit'	then category.lookup('//Personnel Status//Quit')
		else					category.lookup('//Personnel Status//Inactive')
	end
);

alter table inst_personnel drop column status;
@../personnel-pkg-create.sql
@../faculty-pkg-create.sql
commit;