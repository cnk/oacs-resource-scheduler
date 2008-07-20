-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/required-categories-create.sql
--
-- PL/SQL to ensure that the certain categories, (expected by the Institution
-- package), exist.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-30
-- @cvs-id $Id: required-categories-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- //TODO// change pages to show only categories specific to that type

-- This code will act appropriately if any of the categories already exist
-- (and in some cases, do appropriate upgrades to the installed categories).
declare
	pcat0_id integer;
	pcat1_id integer;
	pcat2_id integer;
	cat_id integer;
begin
	pcat0_id	:= category.lookup('//Contact Information');
	if pcat0_id is null then
		pcat0_id	:= category.new(name	=> 'Contact Information',
									plural	=> 'Contact Information');
	else
		update	categories
		   set	name	= 'Contact Information',
				plural	= 'Contact Information'
		 where	category_id = pcat0_id;
	end if;

	----------------------------------------------------------------------------
	-- Categories for Address Objects ------------------------------------------
	----------------------------------------------------------------------------
	pcat1_id	:= category.lookup('//Contact Information//Address');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id => pcat0_id,
									name	=> 'Address',
									plural	=> 'Addresses');
	else
		update	categories
		   set	name	= 'Address',
				plural	= 'Addresses'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Address//Billing Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Billing Address',
								plural	=> 'Billing Addresses');
	else
		update	categories
		   set	name	= 'Billing Address',
				plural	= 'Billing Addresses'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Address//Home Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Home Address',
								plural	=> 'Home Addresses');
	else
		update	categories
		   set	name	= 'Home Address',
				plural	= 'Home Addresses'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Address//Laboratory Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Laboratory Address',
								plural	=> 'Laboratory Addresses');
	else
		update	categories
		   set	name	= 'Laboratory Address',
				plural	= 'Laboratory Addresses'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Address//Mailing Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Mailing Address',
								plural	=> 'Mailing Addresses');
	else
		update	categories
		   set	name	= 'Mailing Address',
				plural	= 'Mailing Addresses'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Address//Work Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Work Address',
								plural	=> 'Work Addresses');
	else
		update	categories
		   set	name	= 'Work Address',
				plural	= 'Work Addresses'
		 where	category_id = cat_id;
	end if;

	----------------------------------------------------------------------------
	-- Categories for Email Address Objects ------------------------------------
	----------------------------------------------------------------------------
	pcat1_id	:= category.lookup('//Contact Information//Email');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id => pcat0_id,
									name	=> 'Email',
									plural	=> 'Emails');
	else
		update	categories
		   set	name	= 'Email',
				plural	= 'Emails'
		 where	category_id = pcat1_id;
	end if;

	-- reparent 'Email Address' if it exists under '//Contact Information'
	cat_id		:= category.lookup('//Contact Information//Login Email Address');
	if cat_id is not null then
		update	categories
		   set	parent_category_id = pcat1_id
		 where	category_id = cat_id;
	end if;

	-- create 'Email Address' if it does not exist under either '//Contact Information' or '//Contact Information//Email'
	cat_id	:= category.lookup('//Contact Information//Email//Email Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Email Address',
								plural	=> 'Email Addresses');
	else
		update	categories
		   set	name	= 'Email Address',
				plural	= 'Email Addresses'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Email//Personal Email Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Personal Email Address',
								plural	=> 'Personal Email Addresses');
	else
		update	categories
		   set	name	= 'Personal Email Address',
				plural	= 'Personal Email Addresses'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Email//Work Email Address');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Work Email Address',
								plural	=> 'Work Email Addresses');
	else
		update	categories
		   set	name	= 'Work Email Address',
				plural	= 'Work Email Addresses'
		 where	category_id = cat_id;
	end if;

	----------------------------------------------------------------------------
	-- Categories for Phone Number Objects -------------------------------------
	----------------------------------------------------------------------------
	pcat1_id	:= category.lookup('//Contact Information//Phone');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id => pcat0_id,
									name	=> 'Phone',
									plural	=> 'Phones');
	else
		update	categories
		   set	name	= 'Phone',
				plural	= 'Phones'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Phone//Cell-phone Number');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Cell-phone Number',
								plural	=> 'Cell-phone Numbers');
	else
		update	categories
		   set	name	= 'Cell-phone Number',
				plural	= 'Cell-phone Numbers'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Phone//Fax Number');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Fax Number',
								plural	=> 'Fax Numbers');
	else
		update	categories
		   set	name	= 'Fax Number',
				plural	= 'Fax Numbers'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Phone//Home Phone Number');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Home Phone Number',
								plural	=> 'Home Phone Numbers');
	else
		update	categories
		   set	name	= 'Home Phone Number',
				plural	= 'Home Phone Numbers'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//Phone//Work Phone Number');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Work Phone Number',
								plural	=> 'Work Phone Numbers');
	else
		update	categories
		   set	name	= 'Work Phone Number',
				plural	= 'Work Phone Numbers'
		 where	category_id = cat_id;
	end if;

	----------------------------------------------------------------------------
	-- Categories for URL Objects ----------------------------------------------
	----------------------------------------------------------------------------
	pcat1_id	:= category.lookup('//Contact Information//URL');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id => pcat0_id,
									name	=> 'URL',
									plural	=> 'URLs');
	else
		update	categories
		   set	name	= 'URL',
				plural	= 'URLs'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Contact Information//URL//Home Page');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat1_id,
								name	=> 'Home Page',
								plural	=> 'Home Pages');
	else
		update	categories
		   set	name	= 'Home Page',
				plural	= 'Home Pages'
		 where	category_id = cat_id;
	end if;

	----------------------------------------------------------------------------
	-- Personnel Status Categories ---------------------------------------------
	----------------------------------------------------------------------------
	pcat0_id	:= category.lookup('//Personnel Status');
	if pcat0_id is null then
		pcat0_id	:= category.new(name		=> 'Personnel Status',
									plural		=> 'Personnel Status',
									description => 'The status of a personnel in a group.');
	else
		update	categories
		   set	name		= 'Personnel Status',
				plural		= 'Personnel Status',
				description	= 'The status of a personnel in a group.'
		 where	category_id = pcat0_id;
	end if;

	cat_id		:= category.lookup('//Personnel Status//Accepting Patients');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name			=> 'Accepting Patients',
								plural			=> 'Accepting Patients',
								description		=> 'Denotes that a Physician/Medical-care provider is accepting patients at/in this location/group.');
	else
		update	categories
		   set	name		= 'Accepting Patients',
				plural		= 'Accepting Patients',
				description	= 'Denotes that a Physician/Medical-care provider is accepting patients at/in this location/group.'
		 where	category_id = cat_id;
	end if;

	-- @since v2.2
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

	-- @since v2.2
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

	-- @since v2.2
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

	-- @since v2.2
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

	-- @since v2.2
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

	-- @since v2.2
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

	-- @since v2.2
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

	----------------------------------------------------------------------------
	-- Personnel Title Categories ----------------------------------------------
	----------------------------------------------------------------------------
	pcat0_id	:= category.lookup('//Personnel Title');
	if pcat0_id is null then
		pcat0_id	:= category.new(name	=> 'Personnel Title',
									plural	=> 'Personnel Titles');
	else
		update	categories
		   set	name	= 'Personnel Title',
				plural	= 'Personnel Titles'
		 where	category_id = pcat0_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Chair');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Chair',
									plural				=> 'Chairs');
	else
		update	categories
		   set	name	= 'Chair',
				plural	= 'Chairs'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Chair//Executive Vice Chair');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Executive Vice Chair',
								plural				=> 'Executive Vice Chairs');
	else
		update	categories
		   set	name	= 'Executive Vice Chair',
				plural	= 'Executive Vice Chairs'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Chair//Vice Chair');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Vice Chair',
								plural				=> 'Vice Chairs');
	else
		update	categories
		   set	name	= 'Vice Chair',
				plural	= 'Vice Chairs'
		 where	category_id = cat_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Chancellor');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Chancellor',
									plural				=> 'Chancellors');
	else
		update	categories
		   set	name	= 'Chancellor',
				plural	= 'Chancellors'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Chancellor//Assistant Vice Chancellor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Assistant Vice Chancellor',
								plural				=> 'Assistant Vice Chancellors');
	else
		update	categories
		   set	name	= 'Assistant Vice Chancellor',
				plural	= 'Assistant Vice Chancellors'
		 where	category_id = cat_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Chief');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Chief',
									plural				=> 'Chiefs');
	else
		update	categories
		   set	name	= 'Chief',
				plural	= 'Chiefs'
		 where	category_id = pcat1_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Dean');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Dean',
									plural				=> 'Deans');
	else
		update	categories
		   set	name	= 'Dean',
				plural	= 'Deans'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Dean//Associate Dean');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Associate Dean',
								plural				=> 'Associate Deans');
	else
		update	categories
		   set	name	= 'Associate Dean',
				plural	= 'Associate Deans'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Dean//Senior Associate Dean');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Senior Associate Dean',
								plural				=> 'Senior Associate Deans');
	else
		update	categories
		   set	name	= 'Senior Associate Dean',
				plural	= 'Senior Associate Deans'
		 where	category_id = cat_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Director');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Director',
									plural				=> 'Directors');
	else
		update	categories
		   set	name	= 'Director',
				plural	= 'Directors'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Director//Associate Director');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Associate Director',
								plural				=> 'Associate Directors');
	else
		update	categories
		   set	name	= 'Associate Director',
				plural	= 'Associate Directors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Director//Co-Director');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Co-Director',
								plural				=> 'Co-Directors');
	else
		update	categories
		   set	name	= 'Co-Director',
				plural	= 'Co-Directors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Director//Director Emeritus');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Director Emeritus',
								plural				=> 'Directors Emeritus');
	else
		update	categories
		   set	name	= 'Director Emeritus',
				plural	= 'Directors Emeritus'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Director//Interim Director');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Interim Director',
								plural				=> 'Interim Directors');
	else
		update	categories
		   set	name	= 'Interim Director',
				plural	= 'Interim Directors'
		 where	category_id = cat_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Faculty');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Faculty',
									plural				=> 'Faculty');
	else
		update	categories
		   set	name	= 'Faculty',
				plural	= 'Faculty'
		 where	category_id = pcat1_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Instructor');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Instructor',
									plural				=> 'Instructors');
	else
		update	categories
		   set	name	= 'Instructor',
				plural	= 'Instructors'
		 where	category_id = pcat1_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Investigator');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Investigator',
									plural				=> 'Investigators');
	else
		update	categories
		   set	name	= 'Investigator',
				plural	= 'Investigators'
		 where	category_id = pcat1_id;
	end if;

	pcat1_id	:= category.lookup('//Personnel Title//Member');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Member',
									plural				=> 'Members');
	else
		update	categories
		   set	name	= 'Member',
				plural	= 'Members'
		 where	category_id = pcat1_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Physician');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Physician',
									plural				=> 'Physicians');
	else
		update	categories
		   set	name	= 'Physician',
				plural	= 'Physicians'
		 where	category_id = pcat1_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Professor');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Professor',
									plural				=> 'Professors');
	else
		update	categories
		   set	name	= 'Professor',
				plural	= 'Professors'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Adjunct Assistant Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Adjunct Assistant Professor',
								plural				=> 'Adjunct Assistant Professors');
	else
		update	categories
		   set	name	= 'Adjunct Assistant Professor',
				plural	= 'Adjunct Assistant Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Adjunct Associate Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Adjunct Associate Professor',
								plural				=> 'Adjunct Associate Professors');
	else
		update	categories
		   set	name	= 'Adjunct Associate Professor',
				plural	= 'Adjunct Associate Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Adjunct Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Adjunct Professor',
								plural				=> 'Adjunct Professors');
	else
		update	categories
		   set	name	= 'Adjunct Professor',
				plural	= 'Adjunct Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Assistant Adjunct Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Assistant Adjunct Professor',
								plural				=> 'Assistant Adjunct Professors');
	else
		update	categories
		   set	name	= 'Assistant Adjunct Professor',
				plural	= 'Assistant Adjunct Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Assistant Clinical Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Assistant Clinical Professor',
								plural				=> 'Assistant Clinical Professors');
	else
		update	categories
		   set	name	= 'Assistant Clinical Professor',
				plural	= 'Assistant Clinical Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Assistant Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Assistant Professor',
								plural				=> 'Assistant Professors');
	else
		update	categories
		   set	name	= 'Assistant Professor',
				plural	= 'Assistant Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Associate Adjunct Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Associate Adjunct Professor',
								plural				=> 'Associate Adjunct Professors');
	else
		update	categories
		   set	name	= 'Associate Adjunct Professor',
				plural	= 'Associate Adjunct Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Associate Clinical Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Associate Clinical Professor',
								plural				=> 'Associate Clinical Professors');
	else
		update	categories
		   set	name	= 'Associate Clinical Professor',
				plural	= 'Associate Clinical Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Associate Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Associate Professor',
								plural				=> 'Associate Professors');
	else
		update	categories
		   set	name	= 'Associate Professor',
				plural	= 'Associate Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Clinical Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Clinical Professor',
								plural				=> 'Clinical Professors');
	else
		update	categories
		   set	name	= 'Clinical Professor',
				plural	= 'Clinical Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Professor Emeritus');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Professor Emeritus',
								plural				=> 'Professors Emeritus');
	else
		update	categories
		   set	name	= 'Professor Emeritus',
				plural	= 'Professors Emeritus'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Visiting Assistant Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Visiting Assistant Professor',
								plural				=> 'Visiting Assistant Professors');
	else
		update	categories
		   set	name	= 'Visiting Assistant Professor',
				plural	= 'Visiting Assistant Professors'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Professor//Visiting Professor');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Visiting Professor',
								plural				=> 'Visiting Professors');
	else
		update	categories
		   set	name	= 'Visiting Professor',
				plural	= 'Visiting Professors'
		 where	category_id = cat_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Provost');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Provost',
									plural				=> 'Provosts');
	else
		update	categories
		   set	name	= 'Provost',
				plural	= 'Provosts'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Provost//Vice Provost');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Vice Provost',
								plural				=> 'Vice Provosts');
	else
		update	categories
		   set	name	= 'Vice Provost',
				plural	= 'Vice Provosts'
		 where	category_id = cat_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Researcher');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Researcher',
									plural				=> 'Researchers');
	else
		update	categories
		   set	name	= 'Researcher',
				plural	= 'Researchers'
		 where	category_id = pcat1_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Researcher//Assistant Researcher');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Assistant Researcher',
								plural				=> 'Assistant Researchers');
	else
		update	categories
		   set	name	= 'Assistant Researcher',
				plural	= 'Assistant Researchers'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Personnel Title//Researcher//Associate Researcher');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Associate Researcher',
								plural				=> 'Associate Researchers');
	else
		update	categories
		   set	name	= 'Associate Researcher',
				plural	= 'Associate Researchers'
		 where	category_id = cat_id;
	end if;

	pcat1_id		:= category.lookup('//Personnel Title//Staff');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Staff',
									plural				=> 'Staff');
	else
		update	categories
		   set	name	= 'Staff',
				plural	= 'Staff'
		 where	category_id = pcat1_id;
	end if;

	----------------------------------------------------------------------------
	-- Image Categories --------------------------------------------------------
	----------------------------------------------------------------------------
	pcat0_id	:= category.lookup('//Image');
	if pcat0_id is null then
		pcat0_id	:= category.new(name		=> 'Image',
									plural		=> 'Images',
									description	=> 'A set of categorizations for image objects.');
	else
		update	categories
		   set	name		= 'Image',
				plural		= 'Images',
				description	= 'A set of categorizations for image objects.'
		 where	category_id = pcat0_id;
	end if;

	cat_id		:= category.lookup('//Image//Campus');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name		=> 'Campus',
								plural		=> 'Campuses',
								description	=> 'An image depicting the locations of a group of buildings.');
	else
		update	categories
		   set	name		= 'Campus',
				plural		= 'Campuses',
				description	= 'An image depicting the locations of a group of buildings.'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Image//Floorplan');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name		=> 'Floorplan',
								plural		=> 'Floorplans',
								description	=> 'A floorplan of a building.');
	else
		update	categories
		   set	name		= 'Floorplan',
				plural		= 'Floorplans',
				description	= 'A floorplan of a building.'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Image//Map');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name		=> 'Map',
								plural		=> 'Maps',
								description	=> 'A geographic map of a location or route.');
	else
		update	categories
		   set	name		= 'Map',
				plural		= 'Maps',
				description	= 'A geographic map of a location or route.'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Image//Other');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name		=> 'Other',
								plural		=> 'Others');
	else
		update	categories
		   set	name	= 'Other',
				plural	= 'Others'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Image//Portrait');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
								name		=> 'Portrait',
								plural		=> 'Portraits',
								description	=> 'A portrait of a person.');
	else
		update	categories
		   set	name		= 'Portrait',
				plural		= 'Portraits',
				description	= 'A portrait of a person.'
		 where	category_id = cat_id;
	end if;
	----------------------------------------------------------------------------
	-- Certification Categories ------------------------------------------------
	----------------------------------------------------------------------------
	pcat0_id	:= category.lookup('//Certification Type');
	if pcat0_id is null then
		pcat0_id	:= category.new(name => 'Certification Type',
									plural => 'Certification Types');
	else
		update	categories
		   set	name	= 'Certification Type',
				plural	= 'Certification Types'
		 where	category_id = pcat0_id;
	end if;

	pcat1_id		:= category.lookup('//Certification Type//Education');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Education',
									plural				=> 'Educations',
									profiling_weight	=> 7);
	else
		update	categories
		   set	name				= 'Education',
				plural				= 'Educations',
				profiling_weight	= 7
		 where	category_id			= pcat1_id;
	end if;

	pcat2_id		:= category.lookup('//Certification Type//Education//Degree');
	if pcat2_id is null then
		pcat2_id	:= category.new(parent_category_id	=> pcat1_id,
									name				=> 'Degree',
									plural				=> 'Degrees',
									profiling_weight	=> 8);
	else
		update	categories
		   set	name				= 'Degree',
				plural				= 'Degrees',
				profiling_weight	= 8
		 where	category_id			= pcat2_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//B.A.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'B.A.',
								plural				=> 'B.A.''s',
								description			=> 'Bachelor of Arts',
								enabled_p			=> 'f');
	else
		update	categories
		   set	name		= 'B.A.',
				plural		= 'B.A.''s',
				description	= 'Bachelor of Arts',
				enabled_p	= 'f'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//B.S.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'B.S.',
								plural				=> 'B.S.''s',
								description			=> 'Bachelor of Science');
	else
		update	categories
		   set	name		= 'B.S.',
				plural		= 'B.S.''s',
				description	= 'Bachelor of Science'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//Sc.D.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'Sc.D.',
								plural				=> 'Sc.D.''s',
								description			=> 'Scientific Doctorate (sometimes written D.Sc.)');
	else
		update	categories
		   set	name		= 'Sc.D.',
				plural		= 'Sc.D.''s',
				description	= 'Scientific Doctorate (sometimes written D.Sc.)'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//Ed.D.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'Ed.D.',
								plural				=> 'Ed.D.''s',
								description			=> 'Educational Doctorate');
	else
		update	categories
		   set	name		= 'Ed.D.',
				plural		= 'Ed.D.''s',
				description	= 'Educational Doctorate'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//J.D.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'J.D.',
								plural				=> 'J.D.''s',
								description			=> 'Juris Doctorate');
	else
		update	categories
		   set	name		= 'J.D.',
				plural		= 'J.D.''s',
				description	= 'Juris Doctorate'
		 where	category_id = cat_id;
	end if;

	-- make or rename if not properly named
	cat_id		:= category.lookup('//Certification Type//Education//Degree//L.Sc.D.');
	if cat_id is null then
		cat_id	:= category.lookup('//Certification Type//Education//Degree//L.Sc.');		-- rename
	end if;

	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'L.Sc.D.',
								plural				=> 'L.Sc.D.''s',
								description			=> 'Doctorate in the Science of Law');
	else
		update	categories
		   set	name		= 'L.Sc.D.',
				plural		= 'L.Sc.D.''s',
				description	= 'Doctorate in the Science of Law'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//M.A.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.A.',
								plural				=> 'M.A.''s',
								description			=> 'Master of Arts');
	else
		update	categories
		   set	name		= 'M.A.',
				plural		= 'M.A.''s',
				description	= 'Master of Arts'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//M.B.A.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.B.A.',
								plural				=> 'M.B.A.''s',
								description			=> 'Master of Business Administration');
	else
		update	categories
		   set	name		= 'M.B.A.',
				plural		= 'M.B.A.''s',
				description	= 'Master of Business Administration'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//M.P.H.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.P.H.',
								plural				=> 'M.P.H.''s',
								description			=> 'Master of Public Health');
	else
		update	categories
		   set	name		= 'M.P.H.',
				plural		= 'M.P.H.''s',
				description	= 'Master of Public Health'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//M.S.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.S.',
								plural				=> 'M.S.''s',
								description			=> 'Master of Science');
	else
		update	categories
		   set	name		= 'M.S.',
				plural		= 'M.S.''s',
				description	= 'Master of Science'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//M.S.P.H.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.S.P.H.',
								plural				=> 'M.S.P.H.''s',
								description			=> 'Master of Science in Public Health');
	else
		update	categories
		   set	name		= 'M.S.P.H.',
				plural		= 'M.S.P.H.''s',
				description	= 'Master of Science in Public Health'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Degree//Ph.D.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'Ph.D.',
								plural				=> 'Ph.D.''s',
								description			=> 'Philisophical Doctorate');
	else
		update	categories
		   set	name		= 'Ph.D.',
				plural		= 'Ph.D.''s',
				description	= 'Philisophical Doctorate'
		 where	category_id = cat_id;
	end if;

	pcat2_id		:= category.lookup('//Certification Type//Education//Medical Degree');
	if pcat2_id is null then
		pcat2_id	:= category.new(parent_category_id	=> pcat1_id,
									name				=> 'Medical Degree',
									plural				=> 'Medical Degrees',
									profiling_weight	=> 7);
	else
		update	categories
		   set	name				= 'Medical Degree',
				plural				= 'Medical Degrees',
				profiling_weight	= 7
		 where	category_id			= pcat2_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//D.D.S.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'D.D.S.',
								plural				=> 'D.D.S.''s',
								description			=> 'Doctor of Dental Science/Surgery');
	else
		update	categories
		   set	name		= 'D.D.S.',
				plural		= 'D.D.S.''s',
				description	= 'Doctor of Dental Science/Surgery'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//D.M.D.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'D.M.D.',
								plural				=> 'D.M.D.''s',
								description			=> 'Dental Medicine Doctorate');
	else
		update	categories
		   set	name		= 'D.M.D.',
				plural		= 'D.M.D.''s',
				description	= 'Dental Medicine Doctorate'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//D.O.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'D.O.',
								plural				=> 'D.O.''s',
								description			=> 'Doctor of Optometry/Osteopathy');
	else
		update	categories
		   set	name		= 'D.O.',
				plural		= 'D.O.''s',
				description	= 'Doctor of Optometry/Osteopathy'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//D.P.M.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'D.P.M.',
								plural				=> 'D.P.M.''s',
								description			=> 'Doctor of Podiatric/Physical Medicine');
	else
		update	categories
		   set	name		= 'D.P.M.',
				plural		= 'D.P.M.''s',
				description	= 'Doctor of Podiatric/Physical Medicine'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//F.A.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'F.A.',
								plural				=> 'F.A.''s',
								description			=> '');
	else
		update	categories
		   set	name		= 'F.A.',
				plural		= 'F.A.''s',
				description	= ''
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//F.A.C.C.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'F.A.C.C.',
								plural				=> 'F.A.C.C.''s',
								description			=> 'Fellow of the American College of Cardiology');
	else
		update	categories
		   set	name		= 'F.A.C.C.',
				plural		= 'F.A.C.C.''s',
				description	= 'Fellow of the American College of Cardiology'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//F.A.C.S.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'F.A.C.S.',
								plural				=> 'F.A.C.S.''s',
								description			=> 'Fellow of the American College of Surgeons');
	else
		update	categories
		   set	name		= 'F.A.C.S.',
				plural		= 'F.A.C.S.''s',
				description	= 'Fellow of the American College of Surgeons'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//F.R.C.S.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'F.R.C.S.',
								plural				=> 'F.R.C.S.''s',
								description			=> 'Fellow of the Royal College of Surgeons');
	else
		update	categories
		   set	name		= 'F.R.C.S.',
				plural		= 'F.R.C.S.''s',
				description	= 'Fellow of the Royal College of Surgeons'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//M.B.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.B.',
								plural				=> 'M.B.''s',
								description			=> 'Bachelor of Medicine');
	else
		update	categories
		   set	name		= 'M.B.',
				plural		= 'M.B.''s',
				description	= 'Bachelor of Medicine'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//M.B.B.S.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.B.B.S.',
								plural				=> 'M.B.B.S.''s',
								description			=> 'Bachelor of Medicine and Bachelor of Surgery');
	else
		update	categories
		   set	name		= 'M.B.B.S.',
				plural		= 'M.B.B.S.''s',
				description	= 'Bachelor of Medicine and Bachelor of Surgery'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//M.B.Ch.B.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.B.Ch.B.',
								plural				=> 'M.B.Ch.B.''s',
								description			=> 'Bachelor of Medicine and Bachelor of Surgery');
	else
		update	categories
		   set	name		= 'M.B.Ch.B.',
				plural		= 'M.B.Ch.B.''s',
				description	= 'Bachelor of Medicine and Bachelor of Surgery'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//M.D.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.D.',
								plural				=> 'M.D.''s',
								description			=> 'Medical Doctorate');
	else
		update	categories
		   set	name		= 'M.D.',
				plural		= 'M.D.''s',
				description	= 'Medical Doctorate'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//M.S.N.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'M.S.N.',
								plural				=> 'M.S.N.''s',
								description			=> 'Master of Science in Nursing');
	else
		update	categories
		   set	name		= 'M.S.N.',
				plural		= 'M.S.N.''s',
				description	= 'Master of Science in Nursing'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//N.P.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'N.P.',
								plural				=> 'N.P.''s',
								description			=> 'Nurse Practitioner');
	else
		update	categories
		   set	name		= 'N.P.',
				plural		= 'N.P.''s',
				description	= 'Nurse Practitioner'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//Psy.D.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'Psy.D.',
								plural				=> 'Psy.D.''s',
								description			=> 'Psychological Doctorate');
	else
		update	categories
		   set	name		= 'Psy.D.',
				plural		= 'Psy.D.''s',
				description	= 'Psychological Doctorate'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Education//Medical Degree//R.N.');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat2_id,
								name				=> 'R.N.',
								plural				=> 'R.N.''s',
								description			=> 'Registered Nurse');
	else
		update	categories
		   set	name		= 'R.N.',
				plural		= 'R.N.''s',
				description	= 'Registered Nurse'
		 where	category_id = cat_id;
	end if;

	----------------------------------------------------------------------------
	-- Medical Experience ------------------------------------------------------
	----------------------------------------------------------------------------
	-- //Certification Type//Medical Experience
	pcat1_id		:= category.lookup('//Certification Type//Medical Experience');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Medical Experience',
									plural				=> 'Medical Experiences',
									profiling_weight	=> 5);
	else
		update	categories
		   set	name				= 'Medical Experience',
				plural				= 'Medical Experiences',
				profiling_weight	= 5
		 where	category_id			= pcat1_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Medical Experience//Fellowship');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Fellowship',
								plural				=> 'Fellowships',
								profiling_weight	=> 5);
	else
		update	categories
		   set	name				= 'Fellowship',
				plural				= 'Fellowships',
				profiling_weight	= 5
		 where	category_id			= cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Medical Experience//Internship');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Internship',
								plural				=> 'Internships',
								profiling_weight	=> 5);
	else
		update	categories
		   set	name				= 'Internship',
				plural				= 'Internships',
				profiling_weight	= 5
		 where	category_id			= cat_id;
	end if;

	cat_id		:= category.lookup('//Certification Type//Medical Experience//Residency');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat1_id,
								name				=> 'Residency',
								plural				=> 'Residencies',
								profiling_weight	=> 5);
	else
		update	categories
		   set	name				= 'Residency',
				plural				= 'Residencies',
				profiling_weight	= 5
		 where	category_id			= cat_id;
	end if;

	----------------------------------------------------------------------------
	-- Medical Board Certification Categories ----------------------------------
	----------------------------------------------------------------------------
	pcat1_id		:= category.lookup('//Certification Type//Medical Board Certification');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'Medical Board Certification',
									plural				=> 'Medical Board Certifications',
									profiling_weight	=> 4);
	else
		update	categories
		   set	name				= 'Medical Board Certification',
				plural				= 'Medical Board Certifications',
				profiling_weight	= 4
		 where	category_id			= pcat1_id;
	end if;

	----------------------------------------------------------------------------
	-- License Categories ------------------------------------------------------
	----------------------------------------------------------------------------
	pcat1_id		:= category.lookup('//Certification Type//License');
	if pcat1_id is null then
		pcat1_id	:= category.new(parent_category_id	=> pcat0_id,
									name				=> 'License',
									plural				=> 'Licenses',
									profiling_weight	=> 9);
	else
		update	categories
		   set	name				= 'License',
				plural				= 'Licenses',
				profiling_weight	= 9
		 where	category_id			= pcat1_id;
	end if;

	----------------------------------------------------------------------------
	-- Group Categories --------------------------------------------------------
	----------------------------------------------------------------------------
	pcat0_id	:= category.lookup('//Group Type');
	if pcat0_id is null then
		pcat0_id	:= category.new(name	=> 'Group Type',
									plural	=> 'Group Types');
	else
		update	categories
		   set	name	= 'Group Type',
				plural	= 'Group Types'
		 where	category_id = pcat0_id;
	end if;

	cat_id		:= category.lookup('//Group Type//College');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat0_id,
								name				=> 'College',
								plural				=> 'Colleges');
	else
		update	categories
		   set	name	= 'College',
				plural	= 'Colleges'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Group Type//Department');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat0_id,
								name				=> 'Department',
								plural				=> 'Departments',
								profiling_weight	=> 1);
	else
		update	categories
		   set	name				= 'Department',
				plural				= 'Departments',
				profiling_weight	= 1
		 where	category_id			= cat_id;
	end if;

	cat_id		:= category.lookup('//Group Type//Division');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat0_id,
								name				=> 'Division',
								plural				=> 'Divisions',
								profiling_weight	=> 3);
	else
		update	categories
		   set	name				= 'Division',
				plural				= 'Divisions',
				profiling_weight	= 3
		 where	category_id			= cat_id;
	end if;

	cat_id		:= category.lookup('//Group Type//Program');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat0_id,
								name				=> 'Program',
								plural				=> 'Programs',
								profiling_weight	=> 4);
	else
		update	categories
		   set	name				= 'Program',
				plural				= 'Programs',
				profiling_weight	= 4
		 where	category_id			= cat_id;
	end if;

	cat_id		:= category.lookup('//Group Type//Hospital');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat0_id,
								name				=> 'Hospital',
								plural				=> 'Hospitals');
	else
		update	categories
		   set	name	= 'Hospital',
				plural	= 'Hospitals'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Group Type//School');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat0_id,
								name				=> 'School',
								plural				=> 'Schools');
	else
		update	categories
		   set	name	= 'School',
				plural	= 'Schools'
		 where	category_id = cat_id;
	end if;

	cat_id		:= category.lookup('//Group Type//University');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id	=> pcat0_id,
								name				=> 'University',
								plural				=> 'Universities');
	else
		update	categories
		   set	name	= 'University',
				plural	= 'Universities'
		 where	category_id = cat_id;
	end if;

	----------------------------------------------------------------------------
	-- Categories for Resume Objects ------------------------------------------
	----------------------------------------------------------------------------

	pcat0_id	:= category.lookup('//Resume Type');
	if pcat0_id is null then
		pcat0_id	:= category.new(name	=> 'Resume Type',
									plural	=> 'Resume Type');
	else
		update	categories
		   set	name	= 'Resume Type',
				plural	= 'Resume Type'
		 where	category_id = pcat0_id;
	end if;

	cat_id	:= category.lookup('//Resume Type//Curriculum Vitae');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
									name	=> 'Curriculum Vitae',
									plural	=> 'CVs');
	else
		update	categories
		   set	name	= 'Curriculum Vitae',
				plural	= 'CVs'
		 where	category_id = cat_id;
	end if;

	cat_id	:= category.lookup('//Resume Type//NIH Bio');
	if cat_id is null then
		cat_id	:= category.new(parent_category_id => pcat0_id,
									name	=> 'NIH Bio',
									plural	=> 'NIH Bios');
	else
		update	categories
		   set	name	= 'NIH Bio',
				plural	= 'NIH Bios'
		 where	category_id = cat_id;
	end if;

end;
/
show errors;
