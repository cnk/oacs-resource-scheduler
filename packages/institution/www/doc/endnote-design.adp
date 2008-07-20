<html>
<head>EndNote Export Design</head>
<body bgcolor="white">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
<h2>EndNote Export Design</h2>
<hr>
<ul>
<li><a href="endnote-requirements">Requirements Doc</a>
<li>User-accessable directory: <%= [acs_root_dir] %>/packages/<%= [ad_conn package_key] %>/www/publication/endnote-import
<li>Development URL: <a href="<%= [ad_conn package_url] %>publication/endnote-import"><%= [ad_conn location][ad_conn package_url] %>publication/endnote-import</a>
<li>AOLServer config file: /home/nsadmin/nsd.pplus.tcl
<li>Current web site:<a href="<%= [ad_conn package_url] %>publication/endnote-import"><%= [ad_conn location][ad_conn package_url] %>publication/endnote-import</a>
</ul>
<br><br>
<b><big>I. Introduction</big></b>
<br><br>
This application will allow users and administrators to upload their publication references in bulk groups that are directly exported from EndNote version 7 in XML. 
Users will have their publications directly associated with them upon upload, while administrators may select as many current personnel as they wish to associate to the uploaded publications.
<br><br>
<b><big>II. Other Consideratios and Design Tradeoffs</big></b>
<br><br>
<b> EndNote Versions and their export capabilities. </b>
<br><br>
While EndNote is used by many personnel to update their publications, only the most current version of EndNote (version 7) exports the publication references 
in XML and this version was released in June of 2003. Since many personnel will still use versions 6 or older, another text format upload will have to be designed 
if we wish to support those users as well, but future versions of EndNote should continue to export in XML.
<br><br>
<b> User and Admin Permissions. </b>
<br><br>
Admin (either super admin, or departmental admin) will be able to assoicate any uploaded publication to any personnel object they have admin or create permissions on. 
Users will only be able to associate their publications to themselves (or any other personnel object they have create permissions on). 
This leaves the problem where one user uploads one or more publication(s) that need to be assoicated with more than just the current user, but the current user 
cannot map that publication to anyone else. 
<br><br>
<b> Multiple Publication Creations </b>
<br><br>
Currently, no design functionality has been created to avoid the creation of multiple publications. This could be from either manually adding publications to the system more than once, 
or two users uploading the same publication shared by both EndNote lists. To avoid clutering the system and forcing the user to check whether or not their publications are already 
uploaded, a system must be implemented to remove redundant publications.
<br><br>
<b><big>III. API</big></b>
<br><br>
******NEED TO DISCUSS FUNCTION TO BE CALLED THAT RUNS THE XML OR TEXT SCRIPTS DETERMINED BY USER CHECKBOX***************
<font color="red">
<ul>
<li> Use the tdom API for parsing the XML files
<li> Write our own API which parses the text scripts
</ul>
</font>
<br>
<b><big>IV. Data Model Discussion</big></b>
<br><br>
<font color="red">We need to add a field (xml_record) to the inst_publications table to store the publication record as given from EndNote.</font>
<br><br>
Currently, no other changes to the Institution Datamodel are needed. However, looking at the list of possible EndNote XML tags, the inst_publications table can be 
expanded to store more information exported by EndNote on the various reference formats. <font color="red">By keeping one field which stores the record data, we can add more publication 
fields and data at a later date if needed.</font>
<br><br>
<b><big>V. User Interface</big></b>
<br><br>
The user interface will consist of a web page where you can upload an XML file to the system and select from a list of allowed personnel which one(s) they wish to associate 
the publications with. The page then reports the results (either success or failure) to the user.
<br><br>
<b><big>VI. Future Improvements/Likely Areas of Change</big></b>
<br><br>
If we wish to support text format uploads as well, the user interface must be updated to call the appropriate script once the file has been uploaded. This can be accomplished 
by placing a select box in the upload form for the user to select which type of file they are uploading and then calling the correct procedure based on that information.
<br><br>
EndNote exports in various text formats as far back as version 3, each with its own set of field delimitors. Careful consideration is needed to choose the format to make for the easiest, least ambiguous parsing.
<br><br>
Note that version 3 to version 6 all export the same text formats, and version 7 supports those as well. The difference between the versions is the reference fields. Version 3 exports a smaller subset of fields than version 7, but this should cause no problems since they remain backword complaint.
 
<br><br>
<b><big>VI. Configurations/Parameters</big></b>
<br><br>
<b><big> VI. Revision History </big></b>
<br><br>
<table cellpadding="2" cellspacing="2" width="90%" bgcolor="#efefef">
<tr bgcolor="#e0e0e0">
    <th width="10%">Document Revision #</th>
    <th width="50%">Action Taken, Notes</th>
    <th class="secondary-header">When?</th>
    <th class="secondary-header">By Whom?</th>
</tr>
<tr>
  <td>0.1</td>
  <td>Creation</td>
  <td>April 13, 2004</td>
  <td>Nick Young</td>
  <td>nick@ucla.edu</td>
</tr>
</table>

</td></tr></table>
<hr>
<a href="mailto:avni@ctrl.ucla.edu"><i>avni@ctrl.ucla.edu</i></a>
</body>
</html>
