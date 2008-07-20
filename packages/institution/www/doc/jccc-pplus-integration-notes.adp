<master>
<property name="title" value="JCCC/PPlus Integration Notes</property>
<h2>JCCC/PPlus Integration Notes</h2>
<hr>
<ul>
<li>User-accessable directory:  /web/jccc-dev/
<li>Development URLs: 	<a href=http://neo.ctrl.ucla.edu:9220/>http://neo.ctrl.ucla.edu:9200/</a>
</ul>
<h3>I. Premise</h3>
<ul>
<li> JCCC will be housed at CTRL.
<li> We need to decide how JCCC will be housed.
	<ol><li>We will keep the whole JCCC site a subsite under portal.
	    <li>The JCCC site will be housed as a separate site and will use views to pull in PPlus data.
	</ol>
<li> JCCC would like to keep a research interest for personnel that is only tied to JCCC.
</ul>
<br>
<h3>II. How JCCC will be housed.</h3>
<ul>
<li><b><big>JCCC as a subsite</big></b>
<br><br>
<b>Positives</b>
<ul>
<li> The PPlus data is immediately available.
<li> PPlus Viewing and Administration is on the same server.
<li> Package pages can be customized to show PPlus data.
<li> JCCC can have its own set of public PPlus pages to display and modify.
</ul>
<br><br>
<b>Negatives</b>
<ul>
<li> We have to migrate all the JCCC data to the PPlus server. (Trial Viewer, News, FAQs, Events, SCP)
<li> We have to make sure all the links and image references use "subsite_url"
<li> Even more load on the Portal server.
</ul>
<br><br>
<li><b><big>JCCC as a separate site.</big></b>
<br><br>
<b>Positives</b>
<ul>
<li> We can leave the JCCC data in its own server.
<li> The JCCC pages can remain as is. (No link changes)
<li> Using views, public PPlus pages are modifiable.
</ul>
<br><br>
<b>Negatives</b>
<ul>
<li> Have to build views and import on a regular basis so the public pages can have the latest data.
<li> Still have to build a subsite under Portal for JCCC to allow administrators to modify data.
<li> Administrators/Users have to come to the Portal site to add/edit/delete data.
</ul>
</ul>
<br>
<h3>III. JCCC Research Interests</h3>
<ul>
<li> We have to build a new mapping table (inst_group_personnel_research_interest_map) to allow personnel to have distinct research interests for groups to which they are mapped.
	<ul><li>personnel_id
	    <li>group_id
	    <li>lay_research_interest
	    <li>technical_research_interest
	</ul>
<li> There has to be an easy way to apply research interests for a person to all the groups to which they are mapped.
</ul>

