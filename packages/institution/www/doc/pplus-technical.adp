<master>
<property name="title" value="Faculty Editor Technical Documentation"></property>
<h2>Faculty Editor Technical Documentation</h2>
<hr>
<ul>
<li>DataModel: <a href=images/PPlus-Datamodel>http://portal.ctrl.ucla.edu/institution/doc/images/PPlus-Datamodel</a>
</ul>
<h3>Table Descriptions</h3>
<ul>
<li> <b>inst_personnel</b>: Contains basic personnel information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr>	<th>Column</th><th>Column Description</th></tr>
		<td>personnel_id</td> <td> Primary Key</td></tr>
		<tr><td>employee_number</td><td>Personnel's UCLA Employee ID</td></tr>
	<tr><td>first_names</td><td> Personnel's First and Middle Name</td></tr>
	<tr><td>last_name</td><td> Personnel's Last Name</td></tr>
	<tr><td>email</td><td> Personnel's Email </td></tr>
	<tr><td>gender (m/f)</td><td> Personnel's Gender</td></tr>
	<tr><td>date_of_birth</td><td> Personnel's Date of Birth</td></tr>
	<tr><td>bio</td><td> Personnel's Bio</td></tr>
	<tr><td>status (active, inactive, ...)</td><td> Personnel's Current Status</td></tr>
	<tr><td>start_date</td><td> Personnel's Start Date at UCLA</td></tr>
	<tr><td>end_date</td><td> Personnel's End Date at UCLA</td></tr>
	<tr><td>notes</td><td> Any administrative notes on this Personnel.</td></tr>
	<tr><td>faculty_p (t/f)</td><td>Indicates whether this Personnel is a Faculty Member at UCLA.</td></tr>
	<tr><td>physician_p (t/f)</td><td> Indicates whether this Personnel is a Physician at UCLA.</td></tr>
	<tr><td>years_of_practice</td><td> Years of Practice for this Physician. Should only be used if physician_p='t'.</td></tr>
	<tr><td>primary_care_physician_p (t/f)</td><td> Indicates whether this Physician is a Primary Care Physician. Should only be used if physician_p='t'.</td></tr>
	<tr><td>marketable_p (t/f) </td><td> Indicates whether this Physician's profile should be displayed to the public. Should only be used if physician_p='t'.</td></tr>
	<tr><td>typical_patient_description</td><td> Description of this Physician's typical patient. Should only be used if physician_p='t'.</td></tr>
	</table><br>
<li> <b>inst_groups</b>: Contains all departments, programs, divisions, cores, and their basic information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>group_id:</td><td>Primary Key</td></tr>
	<tr><td>parent_group_id:</td><td>Foreign Key to inst_groups.group_id indicating the parent group for this group.</td></tr>
	<tr><td>group_type:</td><td>Indicates whether this group is a program, division, or core.</td></tr>
	<tr><td>group_name:</td><td>Name of the group.</td></tr>
	<tr><td>group_short_name:</td><td>Group Name abbreviation.</td></tr>
	<tr><td>description:</td><td>A Description of the group's purpose and functions.</td></tr>
	<tr><td>depth:</td><td>An integer indicating the level the group is in the heirarchy.</td></tr>
	</table><br>
<li> <b>inst_group_personnel_map</b>: Contains mapping information to show which personnel are in which groups and related information. <br>
	Primary key of this table is (gpm_title_id)
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>gpm_title_id:</td><td>The object-id of this title.</td></tr>
	<tr><td>acs_rel_id:</td><td>Indicates the personnel-group mapping which this title labels.</td></tr>
	<tr><td>title_id:</td><td>Indicates the title (category) this personnel has within this group.</td></tr>
	<tr><td>leader_p:</td><td>Indicates whether the personnel is the leader of the group.</td></tr>
	<tr><td>start_date:</td><td>Personnel's start date within this group.</td></tr>
	<tr><td>end_date:</td><td>Personnel's end date within this group.</td></tr>
	<tr><td>title_priority_number:</td><td>Indicates the order in which the titles for this personnel should be shown for this group.</td></tr>
	</table>
	<br>
<li> <b>inst_research_interests</b>: Contains the default and subsite research interests for personnel.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id</td><td>The Personnel whose research interest this is.</td></tr>
	<tr><td>subsite</td><td>Indicates whether this is a subsite research interest or the default research interest.</td></tr>
	<tr><td>research_interest_lay</td><td>The lay research interest text.</td></tr>
	<tr><td>research_interest_technical</td><td>The technical research interest text.</td></tr>
	</table>
	<br>
<li> <b>inst_publications</b>: All Publications
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>publication_id</td><td>Primary Key</td></tr>
	<tr><td>title</td><td>Publication Title</td></tr>
	<tr><td>publication_name</td><td>Name of Publication</td></tr>
	<tr><td>url</td><td>Link to Publication</td></tr>
	<tr><td>authors</td><td>Publication Authors</td></tr>
	<tr><td>volume	</td><td>Publication Volume</td></tr>
	<tr><td>issue</td><td>Publication Issue</td></tr>
	<tr><td>page_ranges</td><td>Page Ranges within Publication</td></tr>
	<tr><td>year</td><td>Year Published</td></tr>
	<tr><td>publish_date</td><td>Date Published</td></tr>
	<tr><td>publisher</td><td>Publisher</td></tr>
	<tr><td>publication_type</td><td>Publication Type</td></tr>
	</table>
	<br>
<li> <b>inst_personnel_publication_map</b>: Table which maps a personnel to a publication.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id:</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>publication_id:</td><td>Indicates the publication to which we are mapping.</td></tr>
	<tr><td>mapping_date:</td><td>Date the personnel was mapped to the publication.</td></tr>
	</table>
	<br>
<li> <b>inst_personnel_resumes</b>: Contains Personnel Resumes
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>resume_id:</td><td>Primary Key</td></tr>
	<tr><td>personnel_id:</td><td>The Personnel whose resume this is.</td></tr>
	<tr><td>resume_type:</td><td>The type of resume</td></tr>
	<tr><td>description:</td><td>Resume Description</td></tr>
	<tr><td>resume:</td><td>Resume text</td></tr>
	<tr><td>format:</td><td>Resume Format</td></tr>
	</table>
	<br>
<li> <b>inst_language_codes</b>: Table of languages
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>language_id:</td><td>Primary Key</td></tr>
	<tr><td>name:</td><td>Language Name</td></tr>
	</table>
	<br>
<li> <b>inst_personnel_language_map</b>: Maps Languages to Personnel
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id:</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>language_id:</td><td>Indicates the language to which we are mapping.</td></tr>
	</table>
	<br>
<li> <b>inst_certifications</b>: Certifications for personnel and groups. Contains degrees, residency, and other certification information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>certification_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>certification_type:</td><td>Type of Certification</td></tr>
	<tr><td>certifying_party:</td><td>Description of certified the party.</td></tr>
	<tr><td>certification_credential:</td><td>Credential received with this certification.</td></tr>
	<tr><td>start_date:</td><td>Start date of attempting to receive the certification.</td></tr>
	<tr><td>certification_date:</td><td>Date Certification received.</td></tr>
	<tr><td>expiration_date:</td><td>Date Certification expires.</td></tr>
	</table>
	<br>
<li> <b>inst_party_urls</b>: URLs for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>url_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>url_type:</td><td>Type of URL.</td></tr>
	<tr><td>description:</td><td>Description of URL.</td></tr>
	<tr><td>url:</td><td>URL</td></tr>
	</table>
	<br>
<li> <b>inst_party_emails</b>: Emails for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>email_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>email_type:</td><td>Type of Email.</td></tr>
	<tr><td>description:</td><td>Description of Email.</td></tr>
	<tr><td>email:</td><td>Email</td></tr>
	</table>
	<br>
<li> <b>inst_party_phones</b>: Phone Numbers for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>phone_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>phone_type:</td><td>Phone Number Type (e.g. cell, home, work, fax, etc..)</td></tr>
	<tr><td>description:</td><td>Description of Phone Number.</td></tr>
	<tr><td>phone_number:</td><td>Phone Number</td></tr>
	</table>
	<br>
<li> <b>inst_party_addresses</b>: Addresses for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>address_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>address_type:</td><td>Address Type (e.g. home, work, etc..)</td></tr>
	<tr><td>description:</td><td>Address Description</td></tr>
	<tr><td>building_name:</td><td>Building Name</td></tr>
	<tr><td>room_number:</td><td>Room Number</td></tr>
	<tr><td>address_line_1:</td><td>Address Line 1</td></tr>
	<tr><td>address_line_2:</td><td>Address Line 2</td></tr>
	<tr><td>address_line_3:</td><td>Address Line 3</td></tr>
	<tr><td>address_line_4:</td><td>Address Line 4</td></tr>
	<tr><td>address_line_5:</td><td>Address Line 1</td></tr>
	<tr><td>city:</td><td>City</td></tr>
	<tr><td>fips_state_code:</td><td>State</td></tr>
	<tr><td>zipcode:</td><td>Zip Code</td></tr>
	<tr><td>fips_country_code:</td><td>Country</td></tr>
	</table>
	<br>
</ul>


