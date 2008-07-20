<master>
<property name="title" value="Mapping of JCCC Web Application DB ERD to PPlus Views"></property>
<h2>Mapping of JCCC Web Application DB ERD to PPlus Views</h2>
<hr>
The following is a list of the tables listed in the JCCC Web Application DB ERD, Model_2 by Li. The first column
in each table contains a column in the JCCC ERD table. The second column contains the corresponding PPlus view and column in the format <i>"view_name.column_name"</i>.
The third column in each table contains notes, if necessary, to clarify the column.
<ul>
<li><b>division</b>: This table data is housed in jccc_groups. There are currently no divisions in the view right now. 
<br><br>
<table border=1 cellpadding=2 cellspacing=0>
<tr><th>JCCC ERD Column</th><th>PPlus View and Column</th><th>Notes</th></tr>
<tr><td>division_id</td><td>jccc_groups.group_id</td><td>Primary Key</td></tr>
<tr><td>division_name</td><td>jccc_groups.group_name</td><td></td></tr>
<tr><td>leadership</td><td>jccc_group_personnel_map</td><td>There is a view called "jccc_group_personnel_map" which contains a mapping of groups to personnel. 
		This view also has a field called "title" which contains the personnel's title within the group.</td></tr>
<tr><td>desc</td><td>jccc_groups.description</td><td></td></tr>
</table><br>

<li><b>Program Area</b>: This table data is housed in jccc_groups. Use the query "select * from jccc_groups where group_type='Program'" to see all Programs.
<br><br>
<table border=1 cellpadding=2 cellspacing=0>
<tr><th>JCCC ERD Column</th><th>PPlus View and Column</th><th>Notes</th></tr>
<tr><td>prog_code</td><td>jccc_groups.group_id</td><td>Primary Key</td></tr>
<tr><td>prog_area_name</td><td>jccc_groups.group_name</td><td></td></tr>
<tr><td>leadership</td><td>jccc_group_personnel_map</td><td>There is a view called "jccc_group_personnel_map" which contains a mapping of groups to personnel. 
		This view also has a field called "title" which contains the personnel's title within the group.</td></tr>
<tr><td>division_id</td><td>jccc_groups.parent_group_id</td><td>Foreign Key which contains the parent group of this group.</td></tr>
</table><br>
	
<li><b>shared resource</b>: This table data is housed in jccc_groups. Use the query "select * from jccc_groups where group_type='Shared Resource'" to see all Shared Resources.
<br><br>
<table border=1 cellpadding=2 cellspacing=0>
<tr><th>JCCC ERD Column</th><th>PPlus View and Column</th><th>Notes</th></tr>
<tr><td>id</td><td>jccc_groups.group_id</td><td>Primary Key</td></tr>
<tr><td>name</td><td>jccc_groups.group_name</td><td></td></tr>
<tr><td>leadership</td><td>jccc_group_personnel_map</td><td>There is a view called "jccc_group_personnel_map" which contains a mapping of groups to personnel. 
		This view also has a field called "title" which contains the personnel's title within the group.</td></tr>
<tr><td>location</td><td>jccc_party_addressses</td><td>Use the query "select * from jccc_party_addresses where party_id = <i>group_id</i>" to get all location information about this group.</td></tr>
<tr><td>contact</td><td></td><td>not needed</td></tr>
<tr><td>services</td><td></td><td>not needed</td></tr>
<tr><td>serv rate</td><td></td><td>not needed</td></tr>
</table><br>

<li><b>JCCC Member</b>: This table data is housed in jccc_personnel. Use the query "select * from jccc_personnel".
<br><br>
<table border=1 cellpadding=2 cellspacing=0>
<tr><th>JCCC ERD Column</th><th>PPlus View and Column</th><th>Notes</th></tr>
<tr><td>member_id</td><td>jccc_personnel.personnel_id</td><td>Primary Key</td></tr>
<tr><td>last_name</td><td>jccc_personnel.last_name</td><td></td></tr>
<tr><td>first_name</td><td>jccc_personnel.first_names</td><td></td></tr>
<tr><td>mid_initial</td><td>jccc_personnel.middle_name</td><td></td></tr>
</table><br>

<li><b>JCCC Members</b>: This table data is housed in jccc_personnel, jccc_party_addresses, jccc_party_phones, jccc_party_emails, jccc_party_urls, jccc_research_interests, 
				and jccc_group_personnel_map
<br><br>
<table border=1 cellpadding=2 cellspacing=0>
<tr><th>JCCC ERD Column</th><th>PPlus View and Column</th><th>Notes</th></tr>
<tr><td>member_id</td><td>jccc_personnel.personnel_id</td><td>Primary Key</td></tr>
<tr><td>regular_member</td><td>jccc_personnel.regular_p</td><td></td></tr>
<tr><td>core_member</td><td>jccc_personnel.core_p</td><td></td></tr>
<tr><td>nci_funding</td><td>jccc_personnel.nci_funding_p</td><td></td></tr>
<tr><td>expired</td><td>jccc_personnel.expired_p</td><td></td></tr>
<tr><td>split_member</td><td>jccc_personnel.split_member_p</td><td></td></tr>
<tr><td>title1</td><td>jccc_group_personnel_map</td><td>Use jccc_group_personnel_map to see personnel's title within the group.</td></tr>
<tr><td>title_2</td><td>jccc_group_personnel_map</td><td>Use jccc_group_personnel_map to see personnel's title within the group.</td></tr>
<tr><td>dept</td><td>jccc_group_personnel_map</td><td>Use jccc_group_personnel_map to see departments the user is mapped to.</td></tr>
<tr><td>prog_code</td><td>jccc_group_personnel_map</td><td>Use jccc_group_personnel_map to see departments the user is mapped to.</td></tr>
<tr><td>phone_num</td><td>jccc_party_phones</td><td>Use jccc_party_phones to see personnel's phone numbers. Use the field "phone_type" to see the type of phone number it is.</td></tr>
<tr><td>fax_num</td><td>jccc_party_phones</td><td>Use jccc_party_phones to see personnel's phone numbers. Select based on where phone_type='fax'.</td></tr>
<tr><td>address1</td><td>jccc_party_addresses.address_line_1</td><td>Use the query "select * from jccc_party_addresses where party_id=<i>personnel_id</i>" to see a personnel's addresses.</td></tr>
<tr><td>address2</td><td>jccc_party_addresses.address_line_2</td><td>Use the query "select * from jccc_party_addresses where party_id=<i>personnel_id</i>" to see a personnel's addresses.</td></tr>
<tr><td>address3</td><td>jccc_party_addresses.address_line_3</td><td>Use the query "select * from jccc_party_addresses where party_id=<i>personnel_id</i>" to see a personnel's addresses.</td></tr>
<tr><td>key_interest</td><td>jccc_research_interests</td><td></td></tr>
<tr><td>lay_desc</td><td>jccc_research_interests.research_interest_lay</td><td></td></tr>
<tr><td>scientific_desc</td><td>jccc_research_interests.research_interest_techinical</td><td></td></tr>
<tr><td>photo</td><td></td><td>not needed</td></tr>
<tr><td>publication</td><td>jccc_publications</td><td>The jccc_publications view houses all publication data. The view jccc_person_publication_map maps personnel to the publications.</td></tr>
<tr><td>birth_dt</td><td>jccc_personnel.date_of_birth</td><td></td></tr>
<tr><td>admin_assist_name</td><td></td><td>coming soon</td></tr>
<tr><td>admin_assist_phone</td><td></td><td>coming soon</td></tr>
<tr><td>admin_assist_email</td><td></td><td>coming soon</td></tr>
</table><br>

<li><b>Program Area Activity</b>: This table data is houses in jccc_events and jccc_events_group_map. Use the queries "select * from jccc_events" and
	"select * from jccc_events_group_map".
<br><br>
<table border=1 cellpadding=2 cellspacing=0>
<tr><th>JCCC ERD Column</th><th>PPlus View and Column</th><th>Notes</th></tr>
<tr><td>activity_id</td><td>jccc_events.event_id</td><td>Primary Key</td></tr>
<tr><td>sponsor_name</td><td>jccc_events.event_description</td><td></td></tr>
<tr><td>location</td><td>jccc_events.event_location</td><td></td></tr>
<tr><td>date_time</td><td>jccc_events.start_date & jccc_events.end_date</td><td></td></tr>
<tr><td>speaker</td><td>jccc_events.event_description</td><td></td></tr>
<tr><td>news title</td><td>not needed</td><td></td></tr>
<tr><td>prog_code</td><td>jccc_events_group_map</td><td></td></tr>
</table><br>

</ul>

