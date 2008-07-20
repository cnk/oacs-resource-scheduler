<master>
<property name=title>@title@</property>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">
<br>
<center><b>@title@</b></center><br>
<table width="100%">
<tr><th align="left" valign="top"><formtemplate id="object_type_list">Object Type: <formwidget id="object_type_id"><formwidget id="submit_filter"></formtemplate></th>
<th align="right" valign="middle">@object_add_link@</th></tr>
</table>
<table width="100%" bgcolor="#74949F" valign="top" cellpadding="0" cellspacing="0" border="0">
    <tr><td valign="top">
	<table width=100% cellpadding="4" cellspacing="1" border="0"> <tr bgcolor="#BBCAD1">
	<th>Name</th>
	<th>Object Type</th>
	<th>Descrption</th>
	<if @object_list:rowcount@ eq 0>
		<tr bgcolor=#ffffff><td align=center colspan=7><i>No @object_type_name@ Objects Currently</td></tr>
	</if>
	<else>
		<multiple name="object_list">
		<if @object_list.rownum@ odd>
			<tr bgcolor="#ffffff">	
		</if>
		<else>
			<tr bgcolor="#eeeeee">
		</else>
		<td valign=top>@object_list.title@</td>
		<td valign=top><nobr>@object_list.object_type@</nobr></td>
		<td valign=top><nobr>@object_list.description@</nobr></td>
		<td valign=top align=center><nobr><a href=event-ae?event_id=@object_list.event_id@>Edit</a> 
		| <a href=event-delete?event_id=@object_list.event_id@>Delete</a>
		</nobr></td></tr>
		</multiple>
	</else>
</table>
</td></tr></table>
<table width=100%><tr><th align=right><br>@object_add_link@</th></tr></table>
<br><br>
</div>


