<master>
<property name=title>@page_title@</property>

@context_bar@
<br></br>
<table width="100%"><tr><td>
<include src="event-object-search" event_id=@event_id@ search_name=@search_name@ search_description=@search_description@ search_object_type=@search_object_type@ url="event-object-list">
</td>
<td cellpadding="2" valign="bottom">
<if @add_event_object_link@ ne "">
   <b>Actions: <br></b>
   <li><a href=@add_event_object_link@>Map to a New Event Object</a>
   <li><a href=@map_event_object_link@>Map to an Existing Event Object</a>
   <if @event_objects:rowcount@ ne 0><li><a href=@unmap_objects_link@>Unmap Event Objects</a></if>
   <br></br><a href=@view_all_link@>View All Event Objects</a>
</if>
</td></tr>
</table>

<p align="center"><h2>Event Objects @event_title@</h2></p>
<table width="100%">
   <tr><td width=70% valign="top">@pagination_nav_bar@</td>
   <td align="right" valign="top"><if @add_event_object_link@ eq ""><a href=@add_link@>Add an Event Object</a></if></td></tr>
   <tr><td colspan=2><br></td></tr>
</table>
<table width="100%" bgcolor="#74949F" valign="top" cellpadding="0" cellspacing="0" border="0">
<tr><td valign="top">
  <table width="100%" valign="top" cellpadding="4" cellspacing="1" border="0">
     <tr bgcolor="#BBCAD1">
     <th>Name</th>
     <th>Object Type</th>
     <th>Description</th>
     <th>URL</th>
     <if @add_event_object_link@ ne ""><th>Tag</th><th>Group Id</th></if>
     <th>Actions</th>
     </tr>
     <if @event_objects:rowcount@ eq 0>
        <tr bgcolor=#ffffff>
	<if @add_event_object_link@ ne ""><td align=left colspan=7><i>No Event Objects @event_title@</i></td></if>
	<else><td align=left colspan=5><i>No Event Objects</i></td></else>
	</tr>
     </if>
     <else>
     <multiple name="event_objects">
     <if @event_objects.rownum@ odd><tr bgcolor="#ffffff"></if>
     <else><tr bgcolor="#eeeeee"></else>

     <td><a href=@event_objects.view_link@>@event_objects.name@</a></td>
     <td>@event_objects.object_type@</td>
     <td>@event_objects.description@</td>
     <td><a href=@event_objects.url_link@>@event_objects.url@</a></td>
     <if @add_event_object_link@ ne ""><td>@event_objects.tag@</td><td>@event_objects.event_object_group_id@</td></if>
     <td align="center"><a href=@event_objects.edit_link@>Edit</a> |
         <a href=@event_objects.delete_link@>Delete</a>
	 <if @add_event_object_link@ ne "">| <a href=@event_objects.remove_link@>Unmap</a></if>
     </td>

     </tr>
     </multiple>
     </else>
   </table>
</td></tr></table>
<br>
