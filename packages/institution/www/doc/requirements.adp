<master>
<property name="title">FDB Requirements</property>
<b><big>FDB Requirements</big></b>
<br><br>
<table border=0 cellpadding=0 cellspacing=0 width=100%>
<tr><td>
<ul>
<li>User-accessible directory: /web/ucla/packages/institution/www/
<li>Administrator directory: /web/ucla/packages/institution/www/admin/
<li>Development URLs: 
	<ul><li><a href=http://neo.crump.ucla.edu:8800/institution/>http://neo.crump.ucla.edu:8800/healthcare/institution/</a>
	    <li><a href=http://neo.crump.ucla.edu:8800/categories/>http://neo.crump.ucla.edu:8800/categories/</a></ul>
<li>AOLServer config file: /home/nsadmin/nsd.ucla.tcl
<li>Current Faculty Editor Site: <a href=http://www.research.medsch.ucla.edu/faculty/facultyeditlogin.cfm>http://www.research.medsch.ucla.edu/faculty/facultyeditlogin.cfm</a> (mtabbal/accessmt)
</ul>
<b><big>I. Introduction</big></b>
<br><br>
We need to build a system capable of housing all the faculty / staff at UCLA (most importantly the personnel in the healthsciences departments
and the school of medicine).  The system will contain personnel information, their photos, publications, emails, phone #s, urls, and 
the departments they are in. It will also contain cores / labs and the services they provide. We want to be able to import the 
data from other databases and also provide a method for other systems to access the data in P+. 
<br><br>
There are four main goals we want to accomplish with FDB. The first is to replace the current Faculty Editor being used by 
the healthsciences departments. Much like the Faculty Editor, there has to be an administration interface for the system. 
Department administrators have to be able to add, edit, delete personnel within their department. Administrators also have to be
able to modify any data such as publications, phones, and emails associated with their personnel.
<br><br>
The second goal is to be able to import data from external sources. As the format in which we receive the data is usually different
from each source, there are only a few ways to try to standardize this process. One is to have an XML format for which we have scripts to bring the data into our database. 
We then offer outside sources (from which we're importing data) this format.  This causes a moderate amount of work on the data provider's end and I can't see 
it being adopted easily.  This method also requires quite a bit of work on our end because we have to write scripts which take the XML and import the data into
our database. The advantages to this method, however, are that there is a standardized format which both the outside source and us have to follow. Most data errors
will be caught.
<br><br>
A second way is to have outside sources give us read-only access to views of the data we need. We then use DTS's to import the data from the external database
to our database. This is the method we have employed for the Morrissey Database of Physicians and the RAD News Datasource. This method is easy to set up and requires
minimal effort on the part of the data provider.  With this method, there is still a significant amount of work which has to be done on our end.  Scripts have to be
written to import the data into our architecture.  There has to be error handling when we process the data to go from the ourtside source's data to ours
<br><br>
The third goal is to offer P+ Data to outside departments / people and even ourselves in a standardized format.
We're going to use SOAP/XML as the format to communicate the data. More to come later....
<br><br>
The fourth goal is to display the data over the web. All public data should be searchable by users. 
<br><br>
<br><br>
<b><big>II. Vision Statement</big></b>
<br><br>

<b><big>III. System Overview</big></b>
<br><br>

<br><br>
		
<b><big>IV. Use Cases</big></b>
<br><br>
<b><big>IVA. Department Administrator</big></b>
<br><br>
<b><big>IVB. Programmer in charge of an external system</big></b>
<br><br>
<b><big>IVC. Regular User</big></b>
<br><br>
<b><big>V. Requirements</big></b>
<br><br>
<b>10.10.00 Categories</b><br>
10.10.05 View Categories<br>
10.10.10 Add A  Category<br>
10.10.15 Edit A Category<br>
10.10.20 Delete A Category<br>
10.10.25 Modify Category Hierarchy<br>
10.10.30 Sorting the categories within one parent
<br><br>
<b>10.20.00 Personnel</b><br>
10.20.05 View Personnel<br>
10.20.10 Search for a Personnel<br>
10.20.15 Add A Personnel<br>
10.20.20 Edit Personnel<br>
10.20.25 Delete Personnel<br>
<br><br>
<b>10.30.00 Departments</b><br>
10.30.05 View Departments<br>
10.30.10 Search for a Department<br>
10.30.20 Add Personnel to a Department<br>
10.30.25 Search for Personnel in a Department<br>
10.30.30 Add A Department<br>
10.30.35 Edit Department<br>
10.30.40 Delete Department
<br><br>
<b>10.40.00 Core Services</b>
<br><br>
<b>10.50.00 Party Information</b>
<br><br>
<b>10.60.00 Permissions</b>
<br><br>
<b><big>VI. Revision History</big></b>
<br><br>
<blockquote>
	<table border="1" cellpadding="2">
		<tr>
			<th class="secondary-header">Document Revision #</th>
			<th class="secondary-header">Action Taken, Notes</th>
			<th class="secondary-header">When?</th>
			<th class="secondary-header">By Whom?</th>
		</tr>

		<tr>
			<td>0.0</td>
			<td>Initial</td>
			<td>2003/12/01</td>
			<td>Avni</td>
		</tr>
	</table>
</blockquote>
</td></tr></table>
