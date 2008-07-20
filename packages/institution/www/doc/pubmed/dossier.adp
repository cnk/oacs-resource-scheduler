<master>
<property name="title" value="Dossier Database"></property>
<h2>Dossier Database - Analysis of the Datamodel</h2>
<hr>
<h3>I. Introduction</h3>
The Dossier Database is an independent database at UCLA which houses faculty, grant,
and publications data for the purpose of supporting advancement decisions.
CTRL has decided to transfer publication data between the Dossier Database and the new Faculty Database (FDB).
<p>
This document describes in detail how the exchange will take place. It describes the fields
that are shared among the two databases and the fields which contain data that needs to be transferred
between the databases.
<p>
There are set of fields that CTRL has decided need to be kept in the FDB for faculty.
If these fields exist in the Dossier database and not in the FDB, they will be created and the corresponding
data brought over into the FDB.
Likewise, CTRL will make the FDB publications data available to the Dossier Database.
<p>
<br>
<h3>II. Next Steps</h3>
<ol><li>CTRL needs to determine which fields they would like to import from the Dossier Database.</li>
	<li>Page Ranges - CTRL needs to determine if they want to parse inst_publications.page_ranges to be start_page and end_page</li>
	<li>Decide where/how to store external IDs in FDB data model</li>
	<li>Finalize this document and make sure it is accurate.</li>
</ol>

<br><br>
<h3>III. Publication Fields that exist in both the FDB and the  Dossier Database</h3>

<table border="1" cellpadding="2" cellspacing="0">
<tr><th>FDB Table and Column</th><th>Corresponding Dossier Database Table and Column</th><th>Notes</th></tr>
<tr><td>inst_publications.publication_id</td><td>t_d_pub.pub_id</td><td></td></tr>
<tr><td>inst_publications.title</td><td>t_d_pub.title</td><td></td></tr>
<tr><td>inst_publications.publication_name</td><td>t_d_pub.pub_info</td>
	<td><code>t_d_pub.pub_info</code> contains the name of the Journal in which the faculty member's publication appears, except in the case of books (where it is probably the title of the book)</td></tr>
<tr><td>inst_publications.authors</td><td>t_d_pub.authors</td><td></td></tr>
<tr><td>inst_publications.volume</td><td>t_d_pub.volume</td><td></td></tr>
<tr><td>inst_publications.issue</td><td>t_d_pub.issue</td><td></td></tr>
<tr><td>inst_publications.publish_date</td><td>t_d_pub.pub_date</td><td></td></tr>
<tr><td>inst_publications.publication_type</td><td>t_d_pub.pub_category</td><td></td></tr>
<tr><td>acs_objects.creation_date</td><td>t_d_pub.entry_date</td><td></td></tr>
<tr><td>acs_objects.last_modified</td><td>t_d_pub.last_update</td><td></td></tr>
<tr><td>inst_personnel_publication_map.personnel_id</td><td>t_d_pub.emp_id</td>
	<td>The publication and the mapping to a faculty member is kept in the same table in the Dossier Database.</td></tr>
<tr><td>inst_personnel_publication_map.mapping_date</td><td>t_d_pub.entry_date</td><td></td></tr>
<tr><td>inst_psnl_publ_ordered_subsets.relative_order</td><td>t_d_pub_profile.sort_order</td><td></td></tr>
</table>

<br><br>
<h3>IV. Publication Fields that exist in the FDB but not in the Dossier Database</h3>
<table border="1" cellpadding="2" cellspacing="0">
<tr><th>FDB Table and Column</th><th>Notes</th></tr>
<tr><td>inst_publications.url</td><td></td></tr>
<tr><td>inst_publications.year</td><td></td></tr>
<tr><td>inst_publications.publication</td><td></td></tr>
<tr><td>inst_publications.page_ranges</td><td></td></tr>
<tr><td>inst_publications.publisher</td><td></td></tr>
<tr><td>acs_objects.creation_user</td><td></td></tr>
<tr><td>acs_objects.creation_ip</td><td></td></tr>
<tr><td>acs_objects.modifying_user</td><td></td></tr>
<tr><td>acs_objects.modifying_ip</td><td></td></tr>
</table>

<br><br>
<h3>V. Publication Fields that exist in the Dossier Database but not in the FDB</h3>
<table border="1" cellpadding="2" cellspacing="0">
<tr><th>Dossier Database Table and Column</th><th>Notes</th></tr>
<tr><td>t_d_pub.pub_type</td><td>P == published</td></tr>
<tr><td>t_d_pub.org_code</td><td></td></tr>
<tr><td>t_d_pub.editors</td><td><font color="red">probably want this</font></td></tr>
<tr><td>t_d_pub.start_page</td><td><font color="red">probably want this</font></td></tr>
<tr><td>t_d_pub.end_page</td><td><font color="red">probably want this</font></td></tr>
<tr><td>t_d_pub.page_refs</td><td></td></tr>
<tr><td>t_d_pub.total_pages</td><td></td></tr>
<tr><td>t_d_pub.contrib</td><td>extent to which the faculty member was actually involved in the creation of the publication</td></tr>
<tr><td>t_d_pub.comments_include</td><td></td></tr>
<tr><td>t_d_pub.comments</td><td></td></tr>
<tr><td>t_d_pub.work_in_prog_status</td><td><small>(used to manage the Dossier work flow)</small></td></tr>
<tr><td>t_d_pub.converted_to_id</td><td><small>(used to manage the Dossier work flow)</small></td></tr>
<tr><td>t_d_pub.new_since_last_review</td><td><small>(used to manage the Dossier work flow)</small></td></tr>
<tr><td>t_d_pub.assoc_action</td><td><small>(used to manage the Dossier work flow)</small></td></tr>
<tr><td>t_d_pub.login_id</td><td></td></tr>
<tr><td>t_d_pub_profile.profile_id</td><td></td></tr>
<tr><td>t_d_pub_profile.pub_category</td><td>How is this different from t_d_pub.pub_category?</td></tr>
<tr><td>t_d_pub_profile.inventory_disp</td><td></td></tr>
<tr><td>t_d_pub_profile.work_in_prog_status</td><td>How is this different from t_d_pub.work_in_prog_status?</td></tr>
<tr><td>t_d_pub_profile.converted_to_id</td><td>How is this different from t_d_pub.converted_to_id?</td></tr>
<tr><td>t_d_pub_profile.new_since_last_review</td><td>How is this different from t_d_pub.new_since_last_review?</td></tr>
<tr><td>t_d_pub_profile.display_in_cv</td><td></td></tr>
<tr><td>t_d_pub_profile.assoc_action</td><td>How is this different from t_d_pub.assoc_action</td></tr>
<tr><td>t_d_pub_profile.include_fl</td><td></td></tr>
<tr><td>t_d_pub_profile.login_id</td><td></td></tr>
</table>
<br><br>
<h3>VI. Revision History</h3>
<blockquote>
	<table border="1" cellpadding="2">
		<tr><th>Document Revision #</th>
			<th>Action Taken, Notes</th>
			<th>When?</th>
			<th>By Whom?</th>
		</tr>
		<tr><td>1.0</td>
			<td>Initial</td>
			<td>2005/07/25</td>
			<td>Avni Khatri</td>
		</tr>
		<tr><td>1.1</td>
			<td>Incorporated some info from
				<a href="http://cvw.ctrl.ucla.edu/general-comments/view-one?comment_id=9875&item=Faculty%20Database%20%28FDB%29">
					notes from an earlier meeting with Martin</a>
			</td>
			<td>2005/07/26</td>
			<td>Andrew Helsley</td>
		</tr>
	</table>
</blockquote>

