<master>
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">
<span class="primary-header"><a href="@admin_url@">Institution Admin</a>: @page_title@</span>
<br><br>

<table width="100%" bgcolor="#536895" cellpadding="0" cellspacing="0" border="0">
<tr><td>
<table width="100%" cellpadding="4" cellspacing="1" border="0">
        <tr><th align="right" bgcolor="#E5EBEB" class="secondary-header" width="16%">Title:</th><td bgcolor="#FFFFFF">@title@</td></tr>
        <tr><th align="right" bgcolor="#E5EBEB" class="secondary-header">Publication:</th><td bgcolor="#FFFFFF">@publication_name@ </td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header">Authors:</th><td bgcolor="#FFFFFF">@authors@</td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header">Volume:</th><td bgcolor="#FFFFFF">@volume@</td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header">Issue:</th><td bgcolor="#FFFFFF">@issue@</td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header">Year:</th><td bgcolor="#FFFFFF">@year@</td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header"><nobr>Publish Date:</nobr></th><td bgcolor="#FFFFFF">@publish_date@</td></tr>
        <tr><th align="right" bgcolor="#E5EBEB" class="secondary-header">Pages:</th><td bgcolor="#FFFFFF">@page_ranges@</td></tr>
        <tr><th align="right" bgcolor="#E5EBEB" class="secondary-header">URL:</th><td bgcolor="#FFFFFF"><a target="blank" href="@url@">@url@</a></td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header"><nobr>Pubmed Status:</nobr></th><td bgcolor="#FFFFFF">@pubmed_status@</td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header"><nobr>Pubmed Actions:</nobr></th><td bgcolor="#FFFFFF">
	<if @pubmed_action@ eq "search">
	       <a href="search?publication_id=@publication_id@">Search Pubmed for a Match</a>
	</if>
	<else>
	      <a href="search?publication_id=@publication_id@">Search Pubmed again for a Match</a> (Please note that this will delete all current matches in the database.)
	</else>
	</td></tr>
	<tr><th align="right" bgcolor="#E5EBEB" class="secondary-header"><nobr>Personnel:</nobr></th><td bgcolor="#FFFFFF">
	<if @publication_personnel:rowcount@ eq "0"><i>n/a</i></if>
	<else><multiple name="publication_personnel"><a target="blank" href="@personnel_detail_url@">@publication_personnel.last_name@, @publication_personnel.first_names@</a></multiple></else>
	</td></tr>
</table>
</td></tr></table>
<br><br>
<span class="primary-header">Pubmed Matches</span>
<br><br>
<table width="100%" bgcolor="#536895" cellpadding="0" cellspacing="0" border="0">
<tr><td>
<table width="100%" cellpadding="4" cellspacing="1" border="0">
        <tr bgcolor="#E5EBEB">
	<th class="secondary-header">Pubmed ID</th>
	<th class="secondary-header">Data Imported?</th>
	<th class="secondary-header">Pubmed Data</th>
	<th class="secondary-header">Actions</th>
	</tr>
<if @pubmed_data:rowcount@ eq "0">
    <tr bgcolor="#ffffff"><td colspan="4"><i>No pubmed data yet.</i></td></tr>
</if>
<else>
    <multiple name="pubmed_data">
    <tr bgcolor="#FFFFFF">
        <th valign="top">@pubmed_data.pubmed_id@</th>
	<th valign="top">@pubmed_data.data_imported_p@</th>
	<td valign="top">@pubmed_data.pubmed_data_html@</td>
	<td valign="top"><nobr><a href=@pubmed_data.import_url@>Import</a> | <if @pubmed_data:rowcount@ gt 1> <a href=@pubmed_data.flag_url@>Flag</a> | </if> 
		<a href=@pubmed_data.delete_url@>Delete</a></nobr></td>
    </tr>
    </multiple>
</else>
</table>
</td></tr></table>
<br><br>
