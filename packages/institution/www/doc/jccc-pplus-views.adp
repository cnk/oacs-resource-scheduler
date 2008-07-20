<master>
<property name="title" value="PPlus Views for JCCC"></property>
<h2>PPlus Views for JCCC</h2>
<hr>
<ul>
<li>Documentation: <a href=http://portal.ctrl.ucla.edu/institution/doc/jccc-pplus-views>http://portal.ctrl.ucla.edu/institution/doc/jccc-pplus-views</a>
<li>Diagram: <a href=http://portal.ctrl.ucla.edu/institution/doc/images/jccc-views>http://portal.ctrl.ucla.edu/institution/doc/images/jccc-views</a>
<li>Map to JCCC Web Application DB ERD: <a href=http://portal.ctrl.ucla.edu/institution/doc/jccc-pplus-map>http://portal.ctrl.ucla.edu/institution/doc/jccc-pplus-map</a>
</ul>
<h3>Connection Information</h3>
<ul>	
<li>User/Password: jccc_external/*********
<li>Driver: Oracle 8i
<li>Host: mothership.ctrl.ucla.edu
<li>Database: mpprod8
<li>Port: 1521
</ul>
<h3>View Descriptions</h3>
<ul>
<li> <b>jccc_personnel</b>: Contains basic personnel information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr>	<th>Column</th><th>Column Description</th></tr>
		<td>personnel_id</td> <td> Primary Key</td></tr>
		<tr><td>employee_number</td><td>Personnel's UCLA Employee ID</td></tr>
	<tr><td>first_names:</td><td> Personnel's First Name</td></tr>
	<tr><td>middle_name:</td><td> Personnel's Middle Name</td></tr>
	<tr><td>last_name:</td><td> Personnel's Last Name</td></tr>
	<tr><td>email:</td><td> Personnel's Email </td></tr>
	<tr><td>gender (m/f):</td><td> Personnel's Gender</td></tr>
	<tr><td>date_of_birth:</td><td> Personnel's Date of Birth</td></tr>
	<tr><td>status (active, inactive...):</td><td> Personnel's Current Status at UCLA</td></tr>
	<tr><td>start_date:</td><td> Personnel's Start Date at UCLA</td></tr>
	<tr><td>end_date:</td><td> Personnel's End Date at UCLA</td></tr>
	<tr><td>notes:</td><td> Any administrative notes on this Personnel.</td></tr>
	<tr><td>faculty_p (t/f):</td><td>Indicates whether this Personnel is a Faculty Member at UCLA.</td></tr>
	<tr><td>physician_p (t/f):</td><td> Indicates whether this Personnel is a Physician at UCLA.</td></tr>
	<tr><td>years_of_practice:</td><td> Years of Practice for this Physician. Should only be used if physician_p='t'.</td></tr>
	<tr><td>primary_care_physician_p (t/f):</td><td> Indicates whether this Physician is a Primary Care Physician. Should only be used if physician_p='t'.</td></tr>
	<tr><td>accepting_patients_p:</td><td>Indicates whether this physician is accepting new patients. Should only be used if physician_p='t'.</td></tr>
	<tr><td>marketable_p (t/f) :</td><td> Indicates whether this Physician's profile should be displayed to the public. Should only be used if physician_p='t'.</td></tr>
	<tr><td>typical_patient_description:</td><td> Description of this Physician's typical patient. Should only be used if physician_p='t'.</td></tr>
	<tr><td>nci_funding_p:</td><td>Indicates whether personnel is funded by NCI</td></tr>
	<tr><td>expired_p:</td><td>Indicates whether personnel is a member of JCCC or not</td></tr>
	<tr><td>expired_comment:</td><td>If personnel is expired, indicates the reason they were expired</td></tr>
	<tr><td>split_member_p:</td><td>Indicates whether the personnel is a member of more than one JCCC group. ("t" if they are, "f" if they are not)</td></tr>
	<tr><td>core_p:</td><td>Indicates whether the personnel is a JCCC core member. ("t" if they are, "f" if they are not)</td></tr>
	<tr><td>regular_p:</td><td>Indicates whether the personnel is a JCCC regular member. ("t" if they are, "f" if they are not)</td></tr>
	<tr><td>jccc_notes:</td><td>JCCC notes about this personnel.</td></tr>
	<tr><td>last_modified_date:</td><td>Date personnel record was last modified.</td></tr>
	</table><br>
<li> <b>jccc_groups</b>: Contains all the JCCC programs, divisions, cores, and their basic information.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>group_id:</td><td>Primary Key</td></tr>
	<tr><td>parent_group_id:</td><td>Foreign Key to jccc_groups.group_id indicating the parent group for this group.</td></tr>
	<tr><td>group_type:</td><td>Indicates whether this group is a program, division, or core.</td></tr>
	<tr><td>group_name:</td><td>Name of the group.</td></tr>
	<tr><td>group_short_name:</td><td>Group Name abbreviation.</td></tr>
	<tr><td>description:</td><td>A Description of the group's purpose and functions.</td></tr>
	<tr><td>qdb_id:</td><td>Group's ID from the QDB database</td></tr>
	<tr><td>nci_code:</td><td>Groups' 2-digit NCI Code</td></tr>
	<tr><td>last_modified_date:</td><td>Date group record was last modified.</td></tr>
	</table><br>
<li> <b>jccc_group_personnel_map</b>: Contains mapping information to show which personnel are in which groups and related information. <br>
	Primary key of this table is (group_id,personnel_id,title)
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>group_id:</td><td>Indicates the group to which we are mapping.</td></tr>
	<tr><td>personnel_id:</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>title:</td><td>Indicates the title this personnel has within this group.</td></tr>
	<tr><td>leader_p:</td><td>Indicates whether the personnel is the leader of the group.</td></tr>
	<tr><td>start_date:</td><td>Personnel's start date within this group.</td></tr>
	<tr><td>end_date:</td><td>Personnel's end date within this group.</td></tr>
	<tr><td>title_priority_number:</td><td>Indicates the order in which the titles for this personnel should be shown for this group.</td></tr>
	<tr><td>last_modified_date:</td><td>Date title record was last modified.</td></tr>
	</table>
	<br>
<li> <b>jccc_research_interests</b>: Contains the default and JCCC research interests for personnel.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id</td><td>The Personnel whose research interest this is.</td></tr>
	<tr><td>subsite</td><td>Indicates whether this is a JCCC research interest or the default research interest.</td></tr>
	<tr><td>lay_title</td><td>The lay research interest title.</td></tr>
	<tr><td>lay_interest</td><td>The lay research interest text.</td></tr>
	<tr><td>technical_title</td><td>The technical research interest title.</td></tr>	
	<tr><td>technical_interest</td><td>The technical research interest text.</td></tr>
	</table>
	<br>
<li> <b>jccc_publications</b>: All JCCC Publications
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
	<tr><td>last_modified_date:</td><td>Date publication record was last modified.</td></tr>
	</table>
	<br>
<li> <b>jccc_person_publication_map</b>: View which maps a personnel to a publication.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id:</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>publication_id:</td><td>Indicates the publication to which we are mapping.</td></tr>
	<tr><td>mapping_date:</td><td>Date the personnel was mapped to the publication.</td></tr>
	</table>
	<br>
<li> <b>jccc_pub_person_ordering</b>: Contains the order in which a personnel would like his publications
	displayed on a subsite.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>subsite:</td><td>Indicates which subsite the ordering is for.</td></tr>	
	<tr><td>publication_id:</td><td>Indicates the publication being ordered.</td></tr>
	<tr><td>personnel_id:</td><td>Indicates which personnel the ordering is for.</td></tr>
	<tr><td>relative_order:</td><td>Indicates the order of the publication within the subsite for this personnel.</td></tr>
	</table>
	<br>
<li> <b>jccc_personnel_resumes</b>: Contains Personnel Resumes
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>resume_id:</td><td>Primary Key</td></tr>
	<tr><td>personnel_id:</td><td>The Personnel whose resume this is.</td></tr>
	<tr><td>resume_type:</td><td>The type of resume</td></tr>
	<tr><td>description:</td><td>Resume Description</td></tr>
	<tr><td>resume:</td><td>Resume content (Binary data)</td></tr>
	<tr><td>format:</td><td>Resume Format</td></tr>
	<tr><td>creation_date</td><td>Resume Creation Date</td></tr>
	<tr><td>last_modified_date</td><td>Date resume record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_language_codes</b>: View of languages
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>language_id:</td><td>Primary Key</td></tr>
	<tr><td>name:</td><td>Language Name</td></tr>
	</table>
	<br>
<li> <b>jccc_personnel_language_map</b>: Maps Languages to Personnel
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>personnel_id:</td><td>Indicates the personnel to which we are mapping.</td></tr>
	<tr><td>language_id:</td><td>Indicates the language to which we are mapping.</td></tr>
	</table>
	<br>
<li> <b>jccc_certifications</b>: Certifications for personnel and groups. Contains degrees, residency, and other certification information.
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
	<tr><td>last_modified_date</td><td>Date certification record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_urls</b>: URLs for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>url_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>url_type:</td><td>Type of URL.</td></tr>
	<tr><td>description:</td><td>Description of URL.</td></tr>
	<tr><td>url:</td><td>URL</td></tr>
	<tr><td>last_modified_date</td><td>Date URL record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_emails</b>: Emails for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>email_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>email_type:</td><td>Type of Email.</td></tr>
	<tr><td>description:</td><td>Description of Email.</td></tr>
	<tr><td>email:</td><td>Email</td></tr>
	<tr><td>last_modified_date</td><td>Date email record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_phones</b>: Phone Numbers for personnel and groups.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>phone_id:</td><td>Primary Key</td></tr>
	<tr><td>party_id:</td><td>Foreign Key which refers to either a Personnel or a Group.</td></tr>
	<tr><td>phone_type:</td><td>Phone Number Type (e.g. cell, home, work, fax, etc..)</td></tr>
	<tr><td>description:</td><td>Description of Phone Number.</td></tr>
	<tr><td>phone_number:</td><td>Phone Number</td></tr>
	<tr><td>last_modified_date</td><td>Date phone record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_addresses</b>: Addresses for personnel and groups.
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
	<tr><td>address_line_5:</td><td>Address Line 5</td></tr>
	<tr><td>city:</td><td>City</td></tr>
	<tr><td>fips_state_code:</td><td>State</td></tr>
	<tr><td>zipcode:</td><td>Zip Code</td></tr>
	<tr><td>zipcode_ext</td><td>4 digit zip code extension</td></tr>
	<tr><td>fips_country_code:</td><td>Country</td></tr>
	<tr><td>last_modified_date</td><td>Date address record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_events</b>: JCCC Events.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>event_id:</td><td>Primary Key</td></tr>
	<tr><td>event_title:</td><td>Event Title</td></tr>
	<tr><td>event_title_2:</td><td>Second Event Title</td></tr>
	<tr><td>event_description:</td><td>Event Description</td></tr>
	<tr><td>event_location:</td><td>Event Location</td></tr>
	<tr><td>meals_info:</td><td>Meal information about the event.</td></tr>
	<tr><td>other_info:</td><td>Other information about the event.</td></tr>
	<tr><td>start_date:</td><td>Event Start Date & Time</td></tr>
	<tr><td>start_year:</td><td>Event Start Year</td></tr>
	<tr><td>all_day_event_p:</td><td>Indicates whether this is an all day event.</td></tr>
	<tr><td>last_modified_date</td><td>Date event record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_events_group_map</b>: Maps Events to Groups
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>event_id:</td><td>Indicates the event to which we are mapping. (FK to jccc_events)</td></tr>
	<tr><td>group_id:</td><td>Indicates the group to which we are mapping. (FK to jccc_groups)</td></tr>
	</table>
	<br>
<li> <b>jccc_clinical_trials</b>: JCCC Clinical Trials.
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>trial_id:</td><td>Primary Key</td></tr>
	<tr><td>irb_number:</td><td>IRB Number for Trial</td></tr>
	<tr><td>title:</td><td>Trial Title</td></tr>
	<tr><td>lay_title:</td><td>Trial Lay Title</td></tr>
	<tr><td>description:</td><td>Trial Description</td></tr>
	<tr><td>eligibility:</td><td>Trial Eligibility</td></tr>
	<tr><td>principal_investigator_last:</td><td>PI Last Name</td></tr>
	<tr><td>principal_investigator_first:</td><td>PI First Name</td></tr>
	<tr><td>principal_telephone_number:</td><td>PI Phone Number</td></tr>
	<tr><td>organ_system:</td><td>Organ System</td></tr>
	<tr><td>study_type:</td><td>Study Type</td></tr>
	<tr><td>study_status:</td><td>Study Status</td></tr>
	<tr><td>referral_investigator_last:</td><td>Referral Investigator Last Name</td></tr>
	<tr><td>referral_investigator_first:</td><td>Referral Investigator First Name</td></tr>
	<tr><td>referral_investigator_number:</td><td>Referral Investigator Phone Number</td></tr>
	<tr><td>last_modified_date</td><td>Date clinical trial record was last modified</td></tr>
	</table>
	<br>
<li> <b>jccc_ct_group_map</b>: Maps Clinical Trials to Groups
	<br><br>
	<table border=1 cellpadding=2 cellspacing=0>
	<tr><th>Column</th><th>Column Description</th></tr>
	<tr><td>trial_id:</td><td>Indicates the clinical trial to which we are mapping. (FK to jccc_clinical_trials)</td></tr>
	<tr><td>group_id:</td><td>Indicates the group to which we are mapping. (FK to jccc_groups)</td></tr>
	</table>
	<br>
</ul>


