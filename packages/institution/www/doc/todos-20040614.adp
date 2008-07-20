<master>
<property name="title">Faculty Editor Administration Interface Todos</property>
<table class="layout" bgcolor="#595F72" width="100%"><tr><td>

<br>

<b>Last Updated 06/14/2004</b>
<br><br>
<b><big>Nick</big></b>
<br>
<ul>
<li>Fix deleting a personnel from the system, so that it doesn't error if they have privilages.<b>(done)</b>
<li>Validate employee number; Make sure it's a 9 digit # and unique if they put it in. <b>(done)</b>
<li>Make sure default_date is set by using [template::util::date::today] <b>(done)</b>
<li>/personnel/personnel-ae: English should be checked by default for languages spoken <b>(done)</b>
<li>/personnel/personnel-search: Should use %$search_param% in the search query <b>(done) </b>
<li>/personnel/: Remove UCLA Employee ID from search field <b>(done)</b>
<li>Remove unused files <b>(done)- left files in personnel directory that I did not create.</b>
<li>Import publications from EndNote (Discuss with Buddy, Avni)
	<ul><li>Write Requirements Doc
	    <li>Write Design Doc
	    <li>Make any necessary data model changes
	    <li>Write pageflow
	    <li>Code import pages
	</ul>
<li>ad_testing <b> MOSTLY DONE </b>
<li>Add more real data on PPlus
<li>Permissions Documentation (with Andy)
<li>API Documentation (with Andy) <b>(done)</b>
</ul>
<br>
<b><big>Andy</big></b>
<ul>
<li>/groups/detail: remove URL + Email <b>(done)</b></li>
<li>/groups/detail: Parent group name should link to the detail of that group <b>(done)</b></li>
<li>/groups/group-ae: Group name should be unique with respect to parent_group_id <b>(done)</b></li>
<li>Make sure default_date is set by using [template::util::date::today] <b>(done)</b></li>
<li>Remove unused files <b>(done)</b></li>
<li>groups/detail: display subgroups ordered by type</li>
<li>Groups API - to display on /pvt/home</li>
<li>Categories: Fix titles</li>
<li>Categories: Add return_url param to add-edit <b>(done, <code>return_url</code> was already there)</b></li>
<li>Put inst_ in front of PL/SQL Packages</li>
<li>Move DML from pages to procs</li>
<li>Validate all unique fields in ad_forms <b>(done -- do more things need to be made unique?)</b></li>
<li>Performance Issues: Being able to handle large amounts of data (with Avni) <b>(improved ~5x for index and groups/index, still needs work)</b></li>
<li>ad_testing</li>
<li>Permissions Documentation (with Nick)</li>
<li>API Documentation (with Nick)</li>
<li>Subsite-for-party Interface</li>
<li>Party Category Map Interface
	<ul><li>Disease Matrix</li>
	    <li>Department Specialties</li>
	</ul></li>
</ul>
<br>
<b><big>Marc</big></b>
<ul>
<li>UI Facelift
<li>Reformat Search pages to be more elegant
</ul>
<br>
<b><big>Avni</big></b>
<ul>
<li><strike>Create server to test installing and uninstalling package</strike>
<li><strike>Install latest categories on pplus</strike>
<li>Make institution dependant on categories in the apm interface
<li>Performance Issues: Being able to handle large amounts of data (with Andy)
<li>Code Public Pages
	<ul><li>Public Profile Page
	    <li>Public Group Detail Page
	</ul>
<li>Look into CVS tagging and releasing
<li>Review All Objects and ad_testing
</ul>
<br>
<b><big>Coming Soon</big></b>
<ul>
<li>Upload multiple publications at one time (Are we still doing this?)
<li>Web Service
<li>Making personnel into acs users
	<ul>
	<li>It errors on obgyn production when trying to make an already existing personnel a user
	<li>If personnel already has a login email address, when you are converting the personnel to a user, the email field should be populated with login email address
	</ul>
</ul>

<br><br>

</td></tr></table>
