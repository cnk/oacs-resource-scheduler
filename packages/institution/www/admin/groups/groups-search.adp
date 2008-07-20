<master>
<property name="title">@page_title@</property>
<link rel="stylesheet" href="../cnsi-forms.css">

<h2>@page_title@ (please specify partial or full group name, blank for all groups)</h2>

<formtemplate id="group">
  <table width="645" border="0" cellspacing="4" cellpadding="2">
  <tr><td>Search for Group: <formwidget id="group_name"> <formwidget id="search"></td></tr>
</formtemplate>

    <tr>
    <td class="value" valign="top">
  	<table width=100% border="1" cellspacing="2" cellpadding="5" bgcolor="#ffffff">
	<nobr>@pagination_nav_bar@
	<tr>
    	<td class="label-shaded" valign="top"><center>Group Name</td>
    	<td class="label-shaded" valign="top"><center>Short Name</td>
    	<td class="label-shaded" valign="top"><center>Description</td>
    	<td class="label-shaded" valign="top"><center>Action</td>
	</tr>

	<if @groups_search:rowcount@ ne 0>
      <multiple name="groups_search">
	<tr>
	  <td class="value-shaded" valign="top"><a href="detail?group_id=@groups_search.group_id@">@groups_search.group_name@</td>
	  <td class="value-shaded" valign="top">@groups_search.short_name@</td>
	  <td class="value-shaded" valign="top">@groups_search.description@</td>
	  <td class="value-shaded" valign="center"><nobr>
	  <a href="add-edit?group_id=@groups_search.group_id@">Edit</a> | 
	  <a href="detail?group_id=@groups_search.group_id@">View</a></nobr></td>
	 </tr>
      </multiple>
	</if>

    	</table>
     </td>
     </tr>
</table>

<br><br>
[ <a href="../">Institution Administration Index</a> ]
<br><br>
