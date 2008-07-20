<master>
<property name="title" value="PPlus Views for ACCESS Faculty & Departments"></property>
<h2>PPlus Views for Access Faculty & Departments</h2>
<hr>
<ul>
<li>Documentation: <a href=http://portal.ctrl.ucla.edu/institution/doc/access-pplus-views>http://portal.ctrl.ucla.edu/institution/doc/access-pplus-views</a>
<li>Diagram: <a href=http://portal.ctrl.ucla.edu/institution/doc/images/Access-Views>http://portal.ctrl.ucla.edu/institution/doc/images/Access-Views</a>
</ul>
<h3>Connection Information</h3>
<ul>	
<li>User/Password: access_external/*********
<li>Driver: Oracle 8i
<li>Host: zion.ctrl.ucla.edu
<li>Database: stage8
<li>Port: 1521
</ul>
<h3>Materialized Views Refresh</h3>
<ul>
<li> <form name=access_view_referesh method=post action=../admin/external-connections/access-views-refresh><input type=submit name=refresh value="Refresh Materialized Views"></form></li>
</ul>
<h3>View Descriptions</h3>
<ul>
<li> <b>access_personnel</b>: Contains basic personnel information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id</td><td>healthsciences.inst_personnel.personnel_id</td><td> Primary Key</td></tr>
	<tr><td>employee_number</td><td>healthsciences.inst_personnel.employee_number</td><td>Personnel's UCLA Employee ID</td></tr>
	<tr><td>first_names</td><td>healthsciences.persons.first_names</td><td> Personnel's First Name</td></tr>
	<tr><td>middle_name</td><td>healthsciences.persons.middle_name</td><td> Personnel's Middle Name</td></tr>
	<tr><td>last_name</td><td>healthsciences.persons.last_name</td><td> Personnel's Last Name</td></tr>
	<tr><td>preferred_first_name</td><td>healthsciences.inst_personnel.preferred_first_name</td><td> Personnel's Preferred First Name</td></tr>
	<tr><td>preferred_middle_name</td><td>healthsciences.inst_personnel.preferred_middle_name</td><td> Personnel's Preferred Middle Name</td></tr>
	<tr><td>preferred_last_name</td><td>healthsciences.inst_personnel.preferred_last_name</td><td> Personnel's Preferred Last Name</td></tr>
	<tr><td>email</td><td>healthsciences.parties.email</td><td> Personnel's Login Email </td></tr>
	<tr><td>gender (m/f)</td><td>healthsciences.inst_personnel.gender</td><td> Personnel's Gender</td></tr>
	<tr><td>date_of_birth</td><td>healthsciences.inst_personnel.date_of_birth</td><td> Personnel's Date of Birth</td></tr>
	<tr><td>bio</td><td>healthsciences.inst_personnel.bio</td><td> Personnel's Bio</td></tr>
	<tr><td>status (active, inactive...)</td><td>healthsciences.inst_personnel.status</td><td> Personnel's Current Status at UCLA</td></tr>
	<tr><td>start_date</td><td>healthsciences.inst_personnel.start_date</td><td> Personnel's Start Date at UCLA</td></tr>
	<tr><td>end_date</td><td>healthsciences.inst_personnel.end_date</td><td> Personnel's End Date at UCLA</td></tr>
	<tr><td>notes</td><td>healthsciences.inst_personnel.notes</td><td> Any administrative notes on this Personnel.</td></tr>
	<tr><td>faculty_p (t/f)</td><td>Checks for record in healthsciences.inst_faculty</td><td>Indicates whether this Personnel is a Faculty Member at UCLA.</td></tr>
	<tr><td>physician_p (t/f)</td><td>Checks for record in healthsciences.inst_physicians</td><td> Indicates whether this Personnel is a Physician at UCLA.</td></tr>
	<tr><td>years_of_practice</td><td>healthsciences.inst_physicians.years_of_practice</td><td> Years of Practice for this Physician. Should only be used if physician_p='t'.</td></tr>
	<tr><td>primary_care_physician_p (t/f)</td><td>healthsciences.inst_physicians.primary_care_physician_p</td>
			<td> Indicates whether this Physician is a Primary Care Physician. Should only be used if physician_p='t'.</td></tr>
	<tr><td>accepting_patients_p (t/f)</td><td>healthsciences.inst_physicians.accepting_patients_p</td>
			<td>Indicates whether this Physician accepts patients or not. Should only be used if physician_p='t'.</td></tr>
	<tr><td>marketable_p (t/f) </td><td>healthsciences.inst_physicians.marketable_p</td>
			<td> Indicates whether this Physician's profile should be displayed to the public. Should only be used if physician_p='t'.</td></tr>
	<tr><td>typical_patient_description</td><td>healthsciences.inst_physicians.typical_patient</td>
			<td> Description of this Physician's typical patient. Should only be used if physician_p='t'.</td></tr>
	<tr><td>affinity_group_id</td><td>healthsciences.access_personnel.affinity_group_id</td><td>Faculty's access affinity group_id. Foreign key to access_groups.group_id</td></tr>
	<tr><td>selected_pub_1</td><td>healthsciences.access_personnel.selected_pblctn_for_guide_id_1</td>
			<td>Faculty's first selected publication. Foreign key to access_publications.publication_id</td></tr>
	<tr><td>selected_pub_2</td><td>healthsciences.access_personnel.selected_pblctn_for_guide_id_2</td>
	<td>Faculty's second selected publication. Foreign key to access_publications.publication_id</td></tr>
	<tr><td>selected_pub_3</td><td>healthsciences.access_personnel.selected_pblctn_for_guide_id_3</td>
		<td>Faculty's third selected publication. Foreign key to access_publications.publication_id</td></tr>
	<tr><td>photo_p (t/f)</td><td>Checks for record for this personnel in healthsciences.inst_party_images where image_type_id = healthsciences.category.lookup('//Image//ACCESS Portrait')
			<td>Indicates whether this personnel has an access portrait.</td></tr>
	</table><br>
<li> <b>access_groups</b>: Contains all the Access programs, divisions, cores, and their basic information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>group_id:</td><td>healthsciences.inst_groups.group_id</td><td>Primary Key</td></tr>
	<tr><td>parent_group_id:</td><td>healthsciences.inst_groups.parent_group_id</td><td>Foreign Key to access_groups.group_id indicating the parent group for this group.</td></tr>
	<tr><td>group_type:</td><td>healthsciences.category.name(healthsciences.inst_groups.group_type_id)</td><td>Indicates whether this group is a program, division, or core.</td></tr>
	<tr><td>group_name:</td><td>healthsciences.acs_object.name(healthsciences.inst_groups.group_id)</td><td>Name of the group.</td></tr>
	<tr><td>group_short_name:</td><td>healthsciences.inst_groups.short_name</td><td>Group Name abbreviation.</td></tr>
	<tr><td>description:</td><td>healthsciences.inst_groups.description</td><td>A Description of the group's purpose and functions.</td></tr>
	<tr><td>depth:</td><td>healthsciences.inst_groups.depty</td><td>An integer indicating the level the group is in the heirarchy.</td></tr>
	<tr><td>qdb_id:</td><td>healthsciences.inst_groups.qdb_id</td><td>Group's corresponding qdb_id in the QDB database if it has one.</td></tr>
	<tr><td>group_priority_number</td><td>healthsciences.inst_groups.group_priority_number</td><td>Used for sorting groups under one parent_group_id.</td></tr>
	</table><br>
<li> <b>access_group_personnel_map</b>: Contains mapping information to show which personnel are in which groups and related information. <br>
	Primary key of this table is (group_id,personnel_id,title)
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>group_id:</td><td>healthsciences.acs_rels.object_id_one</td><td>Indicates the group to which we are mapping.</td></tr>
	<tr><td>personnel_id:</td><td>healthsciences.acs_rels.object_id_two</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>title:</td><td>healthsciences.category.name(healthsciences.inst_group_personnel_map.title_id)</td><td>Indicates the title this personnel has within this group.</td></tr>
	<tr><td>leader_p:</td><td>healthsciences.inst_group_personnel_map.leader_p</td><td>Indicates whether the personnel is the leader of the group.</td></tr>
	<tr><td>start_date:</td><td>healthsciences.inst_group_personnel_map.start_date</td><td>Personnel's start date within this group.</td></tr>
	<tr><td>end_date:</td><td>healthsciences.inst_group_personnel_map.end_date</td><td>Personnel's end date within this group.</td></tr>
	<tr><td>title_priority_number:</td><td>healthsciences.inst_group_personnel_map.title_priority_number</td>
			<td>Indicates the order in which the titles for this personnel should be shown for this group.</td></tr>
	<tr><td>pretty_title:</td><td>healthsciences.inst_group_personnel_map.pretty_title</td><td>Personnel's title as it should be displayed within this group.</td></tr>
	</table>
	<br>
<li> <b>access_research_interests</b>: Contains the default and Access research interests for personnel.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id</td><td>healthsciences.inst_subsite_pers_res_intrsts.personnel_id</td><td>The Personnel whose research interest this is.</td></tr>
	<tr><td>subsite</td><td>healthsciences.acs_object_name(inst_subsite_pers_res_intrsts.subsite_id)</td>
		<td>Indicates whether this is a Access research interest or the default research interest.</td></tr>
	<tr><td>lay_title</td><td>healthsciences.inst_subsite_pers_res_intrsts.lay_title</td><td>The title for the lay research interest.</td></tr>
	<tr><td>lay_interest</td><td>healthsciences.inst_subsite_pers_res_intrsts.lay_interest</td><td>The lay research interest text.</td></tr>
	<tr><td>technical_title</td><td>healthsciences.inst_subsite_pers_res_intrsts.technical_title</td><td>the title for the technical research interest</td></tr>
	<tr><td>technical_interest</td><td>healthsciences.inst_subsite_pers_res_intrsts.technical_interest</td><td>The technical research interest text.</td></tr>
	</table>
	<br>
<li> <b>access_publications</b>: All Access Publications
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>publication_id</td><td>healthsciences.inst_publications.publication_id</td><td>Primary Key</td></tr>
	<tr><td>title</td><td>healthsciences.inst_publications.title</td><td>Publication Title</td></tr>
	<tr><td>publication_name</td><td>healthsciences.inst_publications.publication_name</td><td>Name of Publication</td></tr>
	<tr><td>url</td><td>healthsciences.inst_publications.url</td><td>Link to Publication</td></tr>
	<tr><td>authors</td><td>healthsciences.inst_publications.authors</td><td>Publication Authors</td></tr>
	<tr><td>volume	</td><td>healthsciences.inst_publications.volume</td><td>Publication Volume</td></tr>
	<tr><td>issue</td><td>healthsciences.inst_publications.issue</td><td>Publication Issue</td></tr>
	<tr><td>page_ranges</td><td>healthsciences.inst_publications.page_ranges</td><td>Page Ranges within Publication</td></tr>
	<tr><td>year</td><td>healthsciences.inst_publications.year</td><td>Year Published</td></tr>
	<tr><td>publish_date</td><td>healthsciences.inst_publications.publish_date</td><td>Date Published</td></tr>
	<tr><td>publisher</td><td>healthsciences.inst_publications.publisher</td><td>Publisher</td></tr>
	<tr><td>publication_type</td><td>healthsciences.inst_publications.publication_type</td><td>Publication Type</td></tr>
	<tr><td>relative_order</td><td>healthsciences.inst_psnl_publ_ordered_subsets.relative_order</td><td>Publication Sort Order</td></tr>
	</table>
	<br>
<li> <b>access_person_publication_map</b>: View which maps a personnel to a publication.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id:</td><td>healthsciences.inst_personnel_publication_map.personnel_id</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>publication_id:</td><td>healthsciences.inst_personnel_publication_map.publication_id</td><td>Indicates the publication to which we are mapping.</td></tr>
	<tr><td>mapping_date:</td><td>healthsciences.inst_personnel_publication_map.mapping_date</td><td>Date the personnel was mapped to the publication.</td></tr>
	</table>
	<br>
<li> <b>access_personnel_resumes</b>: Contains Personnel Resumes
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>resume_id:</td><td>healthsciences.inst_personnel_resumes.resume_id</td><td>Primary Key</td></tr>
	<tr><td>personnel_id:</td><td>healthsciences.inst_personnel_resumes.personnel_id</td><td>The Personnel whose resume this is.</td></tr>
	<tr><td>resume_type:</td><td>healthsciences.category.name(healthsciences.inst_personnel_resumes.resume_type_id)</td><td>The type of resume</td></tr>
	<tr><td>description:</td><td>healthsciences.inst_personnel_resumes.description</td><td>Resume Description</td></tr>
	<tr><td>format:</td><td>healthsciences.inst_personnel_resumes.format</td><td>Resume Format</td></tr>
	</table>
	<br>
<li> <b>access_language_codes</b>: View of languages
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>language_id:</td><td>healthsciences.language_codes.language_id</td><td>Primary Key</td></tr>
	<tr><td>name:</td><td>healthsciences.language_codes.name</td><td>Language Name</td></tr>
	</table>
	<br>
<li> <b>access_personnel_language_map</b>: Maps Languages to Personnel
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id:</td><td>healthsciences.inst_personnel_language_map.personnel_id</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>language_id:</td><td>healthsciences.inst_personnel_language_map.language_id</td><td>Indicates the language to which we are mapping.</td></tr>
	</table>
	<br>
<li> <b>access_certifications</b>: Certifications for personnel and groups. Contains degrees, residency, and other certification information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>certification_id:</td><td>healthsciences.inst_certifications.certification_id</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>healthsciences.inst_certifications.party_id</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>certification_type:</td><td>healthsciences.category.name(healthsciences.inst_certifications.certification_type_id)</td><td>Type of Certification</td></tr>
	<tr><td>certifying_party:</td><td>healthsciences.inst_certifications.certifying_party</td><td>Description of entity which certified the party.</td></tr>
	<tr><td>certification_credential:</td><td>healthsciences.inst_certifications.certification_credential</td><td>Credential received with this certification.</td></tr>
	<tr><td>start_date:</td><td>healthsciences.inst_certifications.start_date</td><td>Start date of attempting to receive the certification.</td></tr>
	<tr><td>certification_date:</td><td>healthsciences.inst_certifications.certification_date</td><td>Date Certification received.</td></tr>
	<tr><td>expiration_date:</td><td>healthsciences.inst_certifications.expiration_date</td><td>Date Certification expires.</td></tr>
	</table>
	<br>
<li> <b>access_urls</b>: URLs for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>url_id:</td><td>healthsciences.inst_party_urls.url_id</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>healthsciences.inst_party_urls.party_id</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>url_type:</td><td>healthsciences.category.name(healthsciences.inst_party_urls.url_type_id)</td><td>Type of URL.</td></tr>
	<tr><td>description:</td><td>healthsciences.inst_party_urls.description</td><td>Description of URL.</td></tr>
	<tr><td>url:</td><td>healthsciences.inst_party_urls.url</td><td>URL</td></tr>
	</table>
	<br>
<li> <b>access_emails</b>: Emails for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>email_id:</td><td>healthsciences.inst_party_emails.email_id</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>healthsciences.inst_party_emails.party_id</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>email_type:</td><td>healthsciences.category.name(healthsciences.inst_party_emails.email_type_id)</td><td>Type of Email.</td></tr>
	<tr><td>description:</td><td>healthsciences.inst_party_emails.description</td><td>Description of Email.</td></tr>
	<tr><td>email:</td><td>healthsciences.inst_party_emails.email</td><td>Email</td></tr>
	</table>
	<br>
<li> <b>access_phones</b>: Phone Numbers for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>phone_id:</td><td>healthsciences.inst_party_phones.phone_id</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>healthsciences.inst_party_phones.party_id</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>phone_type:</td><td>healthsciences.category.name(healthsciences.inst_party_phones.phone_type_id)</td><td>Phone Number Type (e.g. cell, home, work, fax, etc..)</td></tr>
	<tr><td>description:</td><td>healthsciences.inst_party_phones.description</td><td>Description of Phone Number.</td></tr>
	<tr><td>phone_number:</td><td>healthsciences.inst_party_phones.phone_number</td><td>Phone Number</td></tr>
	</table>
	<br>
<li> <b>access_addresses</b>: Addresses for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Corresponding PPlus Table.Column</th><th>Column Description</th></tr>
	<tr><td>address_id:</td><td>healthsciences.inst_party_addresses.address_id</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>healthsciences.inst_party_addresses.party_id</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>address_type:</td><td>healthsciences.category.name(healthsciences.inst_party_addresses.address_type_id)</td><td>Address Type (e.g. home, work, etc..)</td></tr>
	<tr><td>description:</td><td>healthsciences.inst_party_addresses.description</td><td>Address Description</td></tr>
	<tr><td>building_name:</td><td>healthsciences.inst_party_addresses.building_name</td><td>Building Name</td></tr>
	<tr><td>room_number:</td><td>healthsciences.inst_party_addresses.room_number</td><td>Room Number</td></tr>
	<tr><td>address_line_1:</td><td>healthsciences.inst_party_addresses.address_line_1</td><td>Address Line 1</td></tr>
	<tr><td>address_line_2:</td><td>healthsciences.inst_party_addresses.address_line_2</td><td>Address Line 2</td></tr>
	<tr><td>address_line_3:</td><td>healthsciences.inst_party_addresses.address_line_3</td><td>Address Line 3</td></tr>
	<tr><td>address_line_4:</td><td>healthsciences.inst_party_addresses.address_line_4</td><td>Address Line 4</td></tr>
	<tr><td>address_line_5:</td><td>healthsciences.inst_party_addresses.address_line_5</td><td>Address Line 1</td></tr>
	<tr><td>city:</td><td>healthsciences.inst_party_addresses.city</td><td>City</td></tr>
	<tr><td>fips_state_code:</td><td>healthsciences.inst_party_addresses.fips_state_code</td><td>State</td></tr>
	<tr><td>zipcode:</td><td>healthsciences.inst_party_addresses.zipcode</td><td>Zip Code</td></tr>
	<tr><td>zipcode_ext:</td><td>healthsciences.inst_party_addresses.zipcode_ext</td><td>Zip Code Extension</td></tr>
	<tr><td>fips_country_code:</td><td>healthsciences.inst_party_addresses.fips_country_code</td><td>Country</td></tr>
	</table>
	<br>
</ul>



