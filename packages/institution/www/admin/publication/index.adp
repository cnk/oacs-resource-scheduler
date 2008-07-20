<master>
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">
<table cellpadding=0 cellspacing=0 border=0 width="100%">
 <tr>
    <td align="left" valign="top"><span class="primary-header">Institution Admin: @title@ </span></td>
    <td align="right">
        <table width="100%" bgcolor="#536895" cellpadding="0" cellspacing="0" border="0">
                <tr><td>
		         <table width="100%" cellpadding="4" cellspacing="1" border="0">
			   <tr><td bgcolor="#FFFFFF">
		  	   <formtemplate id="search_form"></formtemplate>
			  </td></tr></table>
		</td></tr>
	</table>
 </tr>
</table>
<br><br>
<p class="secondary-header">Count: @total_count@</p>
@navigation_display@
<p>
<table width="100%" bgcolor="#536895" cellpadding="0" cellspacing="0" border="0">
<tr><td>
<table width="100%" cellpadding="4" cellspacing="1" border="0">
        <tr bgcolor="#E5EBEB">
	<th class="secondary-header">ID</th>
	<th class="secondary-header">Publication</th>
	<th class="secondary-header">Actions</th>
	</tr>
<if @results:rowcount@ eq "0">
    <tr bgcolor="#ffffff"><td colspan="3"><i>@no_row_message@</i></td></tr>
</if>
<else>
   <multiple name="results">
       <tr bgcolor="#ffffff">
           <td align="middle"><a href="detail?publication_id=@results.publication_id@">@results.publication_id@</a></td>
	   <td>@results.publication_title@</td>
	   <td><nobr>
	          <a href="pubmed/?publication_id=@results.publication_id@&admin_url=@admin_url@">Pubmed</a> |
	          <a href="publication-ae?publication_id=@results.publication_id@&personnel_id=0">Edit</a> |
	          <a href="publication-delete?publication_id=@results.publication_id@">Delete</a></nobr></td>
	</tr>
   </multiple>
</else>

</table>
</td></tr></table>

<br>
<table width="100%" border="0">
<tr><th align="left" class="secondary-header">Actions</th></tr>
<tr><td align="left">
<ul>
<li> <a href="endnote-upload-info"> Click Here To Upload Publications From EndNote.</a> </li>
<li> <a href="pubmed/search">Search Pubmed for all unmatched publications.</a> (Only run at non-peak hours)</li>
<li> <a href="publication-ae">Add A Publication Manually</a></li>
</ul>
</td></tr>
</table>
</div>
