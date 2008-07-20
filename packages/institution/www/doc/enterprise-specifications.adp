<master>
<property name="title" value="PPlus Enterprise Edition Specifications"></property>
<table border=0 cellpadding=0 cellspacing=0 width=100%>
<tr><td>
<h2>PPlus Enterprise Edition Specifications</h2>
<hr>
<ul>
<li>User-accessible directory:  /web/pplus/packages/institution/
<li>Development URLs: 		<a href=http://neo.ctrl.ucla.edu:8800/>http://neo.ctrl.ucla.edu:8800/</a>
<li>Schedule: <a href=enterprise-schedule>http://neo.ctrl.ucla.edu:8800/institution/doc/enterprise-schedule</a>
</ul>
													
<b><big>I. Introduction</big></b>
<br><br>
The David Geffen School of Medicine (DGSOM) at UCLA needs a database-backed web application which will house all faculty information and allow all departments
in the school to access and update this information as necessary. CTRL has built an application called PPlus to meet this need.
PPlus consists of a set of pages which allow the department administrator to search for and edit faculty information 
(photos, resume, publications, address, phone, etc..). 
The department administrator is also able to edit information (photos, description, address, phone) about his department.
<br><br>
Many departments want public pages to view these data within their site or linked to from their site. They want these pages to look like their site.
The PPlus database schema will be the central hub for faculty info within the school. Departments at the DGSOM will be able to 
access these data in one of four ways. 
<br><br>
<b><big>II. Methods</big></b>
<br><br>
<b><big>IIA. Subsites</big></b> (HS,RADONC,OBGYN)
<br><br>
One, each department will be a subsite on the main faculty database server. This will be used
by all departments whose sites will be hosted at CTRL. The PPlus package will be mounted under each subsite.
Having the department as a subsite is a simple solution where we do not have to worry about synchronizing objects between two sites or 
using external authentication such as LDAP to synchronize users between the department site and the main PPlus site.
This method also allows us to give the department optimal control over all aspects of the faculty data which pertains to them through
the ACS Permissions package.
<br><br>
<b><big>IIB. Branding</big></b> (School of Public Health)
<br><br>
Two, departments can use the branding approach where the department's web site will link to 
the generic pplus web site with a skin placed on top of the PPlus generic pages to look like their site. 
This method should only be used for departments that do not need to make any changes to the default PPlus pages
or need PPlus data in any of their own applications. It can be used by departments whose database schemas are at CTRL
or it can be used by departments whose database schemas are located outside of CTRL if they don't want to use DTS scripts
to import the data. The departments using this approach will not be able to update, insert, delete, or view any PPlus information 
from their web site.  They will have to come to the main PPlus site to access their data. They can use their set of branded pages
to view and modify the data.
<br><br>
<b><big>IIC. Instance to Instance: Oracle Views</big></b> (JCCC, Pharmacology, Linus)
<br><br>
The third method consists of providing access to data via an ODBC/JDBC connection to a limited Oracle user account which has views. 
This will be used by departments which house their web sites in a completely separate database instance from 
CTRL and may or may not be using using Oracle. Each client will have an Oracle User created in the faculty tablespace. Their Oracle User will contain
read only views which contain data selected from materialized views created as the faculty user. The materialized views created for the client in the 
faculty user select data from the institution tables which pertain to the client.  
If the client is using OpenACS, they are also given public faculty and department pages which they may house on their server. 
This allows them to modify the pages and add their own information to them. 
<br><br>
<b><big>IID. Instance to Instance: Scheduled DTS Scripts</big></b> (Grant, Martin Funches)
<br><br>
Finally, departments who have sites external to CTRL and do not use Oracle can access the data
using scheduled DTS scripts. The DTS scripts will export the PPlus data in the same table structure as the PPlus schema.
These clients are then free to import the data into their system however they like. They can also use the DTS scripts to receive
updated data.
<br><br>
<b><big>IIE. Summary</big></b>
<br><br>
For the first three ways, the data will always reside in the PPlus schema. Any changes made to the data will occur to this schema.
We had previously discussed having multiple copies of data, but have decided against this. There will only be one copy of the data.
This relieves us from the problems of deciding which database schema / instance has precedence and having to sync the data, but brings up a 
new problem in that we have to migrate existing external data (OBGYN, JCCC, RADONC) into the central PPlus schema. It also relieves us from
having to worry about using LDAP Authentication to manage user accounts on all systems. The fourth way consists of providing the client
with a way to grab the data and put it on their site.  
<br><br>
Let's first discuss the four methods departments can use in accessing the PPlus data in detail and the steps that we need to take
to implement these methods.
<br><br>
<b><big>III. Building a Site for a Client</big></b>
<br><br>
The first step is to create the main PPlus site. The main PPlus site will be the current healthsciences site with a new subsite created for healthsciences.
The PPlus package (institution) will be installed under the root subsite. There will also be a generic file-not-found.adp in the webroot of this site.  
This site will serve as the PPlus administration gateway for any department using either the branding method, creating oracle views, or scheduling DTS scripts. 
The following describes the steps  CTRL will have to take when a client makes a request for PPlus data based on the method the client has chosen.
<br><br>
<b><big>IIIA. Subsites</big></b> (HS,RADONC,OBGYN)
<br><br>
<b><big>Steps</big></b>
<br>
<ul>
<li>First create a subsite for the department
<li>Create a master template so the department has a customized look.
<li>Change the subsite parameter "DefaultMaster" to point to the new master template.
<li>Mount the PPlus package (institution) under the newly created subsite.
<li>Mount any other applications for this department.
<li>Put a customized file-not-found.adp in the subsite webroot (/web/pplus/www/subsite/)
<li>Create a mapping in the site_node table so the department's desired hostname points to the subsite.
</ul>
<br>
<b><big>Drawbacks</big></b>
<br><br>
The only worry about creating a subsite for each department which will be hosted by CTRL is whether the main PPlus server
can handle the load. 
<br><br>
<b><big>Diagram</big></b>
<table width=100% border=0><tr><td align=left><img src=images/Subsite.jpg border="0"></td></tr></table>
<br><br>
<b><big>IIIB. Branding</big></b> (School of Public Health)
<br><br>
<b><big>Steps</big></b>
<br>
<ul>
<li>Possibly use ISIS (LDAP) (an application separate from PPlus) to allow authentication from the client site to the PPlus subsite.
<li>First create a subsite for the department.
<li>Create a master template so the department has a customized look.
<li>Change the subsite parameter "DefaultMaster" to point to the new master template.
<li>Mount the PPlus package (institution) under the newly created subsite.
<li>Put a customized file-not-found.adp in the subsite webroot (/web/pplus/www/subsite/).
<li>Create a mapping in the site_node table so the department's desired hostname for PPlus data points to the subsite.
<li>Give the client the new URL.
</ul>
<br>
<b><big>Drawbacks</big></b>
<br>
<ul>
<li>Links can not be placed on the PPlus pages.
<li>Can not put faculty data on client's web site pages.
<li>Client has to come to the main PPlus site to add, edit, delete, or view any information.
<li>There will be a hostname change evident to end-users when viewing PPlus data. (We could use frames to hide the hostname change from the client.)
</ul>
<br>
<b><big>Diagram</big></b>
<br><br>
<table width=100% border=0><tr><td align=left><img src=images/Branding.jpg border="0"></td></tr></table>
<br><br>
<b><big>IIIC. Instance to Instance: Oracle Views </big></b> (Read only access from CTRL database instance to another Oracle instance.) (JCCC, Pharmacology, Linus)
<br><br>
<b><big>Steps</big></b>
<br> 
<ul> 
<li> CTRL creates materialized views in the faculty tablespace to select the client data.
<li> CTRL then creates a new database user for the client which has select on the client's materialized views.
<li> CTRL then runs grants which allows the new database user access to the materialized views.
<li> CTRL then creates views as the new database user which select all data from the materialized views.
<li> CTRL gives the client connection information to access the new database user's views.
<li> CTRL will set up a subsite with the skin of the client in order to update data.
<li> If the client is running OpenACS, they can then use the stock pages in the pplus-client package and modify them as they wish.
<li> If the client is not running OpenACS, they must create their own pages to view the data.
</ul>
<br>
<b><big>Drawbacks</big></b>
<br>
<ul>
<li> When selecting PPlus data, clients have to put connection_name name before each table name in the queries
<li> Client has to come to the main PPlus site to add, edit, or delete any information
</ul>
<br>
<b><big>Diagram</big></b>
<br><br>
<table width=100% border=0><tr><td align=left><img src=images/OracleViews.jpg border="0"></td></tr></table>
<br><br>
<b><big>IIID. Instance to Instance: Scheduled DTS Scripts</big></b> (Read only access from CTRL database instance to another database instance.) (Grant, Martin Funches)
<br><br>
<b><big>Steps</big></b>
<br>
<ul>
<li> The client notifies CTRL of the server to which the PPlus data needs to be imported.
<li> CTRL schedules the DTS script on a SQLServer instance to export the data to the client's server.
<li> The client then builds pages on his system to view the data in any manner he wishes.
<li> <font color=red>The amount of data received by the client will be constrained. how?</font>
</ul>
<br>
<b><big>Drawbacks</big></b>
<br><br>
<ul>
<li>The scripts have to be run periodically if the client wants have up-to-date data.
<li>Client has to come to the main PPlus site to add, edit, or delete any information
<li>Setup of Permissions/Constraining data
</ul>
<br>
<b><big>Diagram</big></b>
<br><br>
<table width=100% border=0><tr><td align=left><img src=images/DTSScripts.jpg border="0"></td></tr></table>
<br><br>
<b><big>IV. Creation of the PPlus-Client Package</big></b>
<br><br>
<ul><li>CTRL has to create a pplus-client package for the third option (instance to instance: oracle views) for clients. 
		Clients will run the scripts in this package in their database schemas.
    <li>Package installation scripts will create the appropriate views. 
    <li><font color=red>OACS Parameters will determine which data (constraints) will be shown also need to be set at package installation.</font>
</ul>
<br>
<b><big>V. Creation of PPlus DTS Scripts</big></b>
<br><br>
<ul>
<li>CTRL has to create a set of DTS scripts to export data from the PPlus schema to a client's server.
<li><font color=red>The DTS scripts will contain the constrained data/permissions.</font>
</ul>
<br>
<b><big>VI. Permissions and Limiting Data Accessed</big></b>
<br><br>
Another issue that we will have to take into account is permissions. Data has to be able to be constrained in 
any method the client decides to use. For methods one (subsites) and two (branding), permissions is easy because
the PPlus package (institution) is already subsite aware. Administrators of the departments can delegate permissions to their department
and any subdepartment or faculty within these departments using the acs_permissions package.
<br><br>
For Oracle Views, permissions will be taken care of in the customized views for each client.
<br><br>
For the DTS Scripts, permissions will be taken care of in the scripts themselves. <font color=red>How to do this in the most efficient way?</font>

<br><br>
<b><big>VII. Getting existing data into the PPlus schema.</big></b>
<br><br>
The next big task is getting existing data into the PPlus database schema. 
<ul>
<li>I think the best thing to do is make HealthSciences the new PPlus site. 
<li>We then move the HealthSciences site into a subsite.
<li>Then we should create the remaining sites (JCCC, RADONC, OBGYN) in the PPlus site as subsites starting with the easiest.
<li>For each site, we should check if their faculty and groups already exist in the main PPlus site. If they don't, we add them manually. 
<font color=red>Is this the best way?</font> 
<li>We then bring over any applications the sites might have into their new subsite along with any data. 
<li>Change the IP of the old site to point to the new PPlus site and add a host-subsite node to point the hostname to the subsite.
</ul>
<br>
<b><big>VIII. Full Design</big></b>
<br><br>
<table width=100% cellpadding=0 cellspacing=0 border=0><tr><td align=left><img src=images/PPlus-Enterprise.jpg border="0"></td></tr></table>
<br>
<ul><li><a href=images/PPlus-Enterprise-Old.jpg>Previous Design</a></ul>
<br><br>
<b><big> IX. Revision History </big></b>
<br><br>
<table cellpadding=2 cellspacing=2 width=90% bgcolor=#efefef>
<tr bgcolor=#e0e0e0>
  <th width=10%>Document Revision #</th>
  <th width=50%>Action Taken, Notes</th>
  <th class="secondary-header">When?</th>
  <th class="secondary-header">By Whom?</th>
</tr>
<tr>
  <td>1.0</td>
  <td>Creation</td>
  <td>July 20-27, 2004</td>
  <td>Avni Khatri</td>
</tr>
<tr>
  <td>1.1</td>
  <td>Edits from meeting with Buddy, Andy, and Khy. Updated Schedule.</td>
  <td>August 4, 2004</td>
  <td>Avni Khatri</td>
</tr>
<tr>
  <td>1.2</td>
  <td>Updated IIC. and IIIC. to include JDBC/ODBC connections to non-Oracle databases. Updated Diagrams for C and entire enterprise. Updated Schedule.</td>
  <td>September 29, 2004</td>
  <td>Avni Khatri</td>
</tr>
</table>


