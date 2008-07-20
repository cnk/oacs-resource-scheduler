<master>
<property name="title" value="Steps for Adding a Subsite to PPlus Enterprise"></property>
<h2>Steps for Adding a Subsite to PPlus Enterprise</h2>
<hr>
<table border=0 cellpadding=2 cellspacing=2>
<tr><td valign=top align=right><b>URLs:</b> </td><td align=left>
<ul>
<li>DEV: http://neo.ctrl.ucla.edu:8800/
<li>STAGING: http://staging.ctrl.ucla.edu:8800/
<li>PRODUCTION: http://portal.ctrl.ucla.edu/
</ul></td></tr>
<tr><td valign=top align=right><b>WebRoot:</b></td><td> <ul><li>/web/ucla/</ul></td></tr>
<tr><td valign=top align=right><b>Steps:</b></td><td>
<ul>
<li> Create a user account on dev/staging/production for the person creating the subsite and make them a site administrator.
<li> Create a new ACS Subsite under the root subsite on dev/staging/production though the sitemap naming it appropriately.
	(e.g. Radiation Oncology)
<li> Put any package code in /web/ucla/packages/.
<li> Install packages through /acs-admin/apm/
<li> Mount package under this subsite using the sitemap on dev/staging/production.
<li> Migrate/Enter in data for the applications on dev/staging/production.
<li> Create a subsite folder under /web/ucla/www/ for the new subsite on dev.
<li> Copy over files for this subsite into the new subsite folder on dev.
<li> Remove any CVS files that were in the files you just copied over.
<li> Create an institution folder in the new subsite folder on dev if one doesn't exist.
<li> Copy over the public institution code from the release server. Modify for this site as necessary.
<li> Copy over the file-not-found files from the release server. Modify for this site as necessary.
<li> Create an images folder in the new subsite folder on dev if one doesn't exist.
<li> Copy over the photo-not-available image from the release server for the institution package.
<li> Copy over the file-not-found images from the release server.
<li> CVS all new files.
<li> Add site-node host mappings on dev/staging/production as necessary.
<li> Test site and fix links as necessary.
</ul>
</td></tr></table>
