<html>
<head>EndNote Export Requirements</head>
<body bgcolor=white>
<table border=0 cellpadding=0 cellspacing=0 width=100%>
<tr><td>
<h2>EndNote Export Requirements</h2>
<hr>
<ul>
<li><a href=endnote-design>Design Doc</a>
<li>User-accessable directory: /web/pplus/packages/institution/www/publication/endnote-import
<li>Development URL: <a href=http://neo.ctrl.ucla.edu:9900/institution/publication/endnote-import>http://neo.ctrl.ucla.edu:9900/institution/publication/endnote-import </a>
<li>AOLServer config file: /home/nsadmin/nsd.pplus.tcl
<li>Current web site:<a href=http://neo.ctrl.ucla.edu:9900/institution/publication/endnote-import>http://neo.ctrl.ucla.edu:9900/institution/publication/endnote-import </a>
</ul>
<b><big>I. Introduction</big></b>
<br><br>
We want to build a page that allows users (admin) to upload their publication references exported in XML from EndNote and then to parse that information to create 
new columns in the inst_publication table. The page should also allow the user to select which personnel from the inst_personnel table they wish to associate to the newly created publications. 
<font color=red>Older versions of EndNote don't support exporting in XML. Since the majority of users still use EndNote 6, we should also support importing the text format which EndNote 6 exports.</font>
<br><br>
<b><big>II. EndNote XML Tags </big></b>
<p>Below is a list if all possible xml tags exported by EndNote. => refers to the matching column name in inst_publications table
<ul>
<li> RECORDS
<li> RECORD
<li> REFERENCE_TYPES
<li> REFERENCE_TYPE
<li> REFNUM
<li> AUTHORS
<li> AUTHOR  => authors
<li> YEAR  => year
<li> TITLE => title
<li> SECONDARY_AUTHORS
<li> SECONDARY_AUTHOR
<li> SECONDARY_TITLE  => publication_name
<li> PLACE_PUBLISHED
<li> PUBLISHER  => publisher
<li> VOLUME  => volume
<li> NUMBER_OF_VOLUMES
<li> NUMBER => issue
<li> PAGES  => page_ranges
<li> SECTION
<li> TERTIARY_AUTHORS
<li> TERTIARY_AUTHOR
<li> TERTIARY_TITLE
<li> EDITION
<li> DATE  => date
<li> TYPE_OF_WORK
<li> SUBSIDIARY_AUTHORS
<li> SUBSIDIARY_AUTHOR
<li> SHORT_TITLE
<li> ALTERNATE_TITLE
<li> ISBN
<li> ORIGINAL_PUB
<li> REPRINT_EDITION
<li> REVIEWED_ITEM
<li> CUSTOM1
<li> CUSTOM2
<li> CUSTOM3
<li> CUSTOM4
<li> CUSTOM5
<li> CUSTOM6
<li> ACCESSION_NUMBER
<li> CALL_NUMBER
<li> LABEL
<li> KEYWORDS
<li> KEYWORD
<li> ABSTRACT
<li> NOTES
<li> URL  => url
<li> AUTHOR_ADDRESS
<li> IMAGE
<li> CAPTION
</ul>
<br>
<b><big>III. EndNote Reference Types capable of support</big></b
<ul>
<li> 0 | Journal Article       
<li> 1 | Book                  
<li> 2 | Thesis                
<li> 3 | Conference Proceedings
<li> 4 | Personal Communication
<li> 5 | Newspaper Article     
<li> 6 | Computer Program      
<li> 7 | Book Section          
<li> 8 | Magazine Article      
<li> 9 | Edited Book           
<li>10 | Report                
<li>11 | Map                   
<li>12 | Audiovisual Material  
<li>13 | Artwork               
<li>14 | (not defined)
<li>15 | Patent                
<li>16 | Electronic Source     
<li>17 | Bill                  
<li>18 | Case                  
<li>19 | Hearing               
<li>20 | Manuscript            
<li>21 | Film or Broadcast     
<li>22 | Statute               
<li>23 | (not defined)
<li>24 | (not defined)
<li>25 | Figure                
<li>26 | Chart or Table        
<li>27 | Equation              
<li>28 | (not defined)
<li>29 | (not defined)
<li>30 | (not defined)
<li>31 | Generic  
</ul>
<b><big>IV. Admin Requirements</big></b>
<ul>
<li> Upload XML file into the Institution DB
<li> Create a new row in the inst_publication and inst_personnel_publication_map tables for each record.
<li> Select any number of personnel to associate the publications to from a list of all personnel.

</ul>
<b><big>V. User Requirements</big></b>
<ul>
<li> Users can only associate publications to themselves (this is done automatically on the user level).
</ul>

<b><bif> VI. Revision History </big></b>
<br><br>
<table cellpadding=2 cellspacing=2 width=90% bgcolor=#efefef>
<tr bgcolor=#e0e0e0>
    <th width=10%>Document Revision #</th>
    <th width=50%>Action Taken, Notes</th>
    <th class="secondary-header">When?</th>
    <th class="secondary-header">By Whom?</th>
</tr>
<tr>
  <td>0.1</td>
  <td>Creation</td>
  <td>April 13, 2004</td>
  <td>Nick Young</td>
</tr>
</table>

</td></tr></table>
<hr>
<a href=mailto:nick@ucla.edu><i>nick@ucla.edu</i></a>
</body>
</html>
