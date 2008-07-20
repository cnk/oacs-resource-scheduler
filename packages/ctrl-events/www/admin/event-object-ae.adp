<master>
<property name=title> @page_title@ </property>
@context_bar@
<br></br>
<formtemplate id="add_edit_event_object">
<table>
<tr><td align="right">Name: </td><td><formwidget id="name"/><font color="red"><formerror id="name"></formerror></td></tr>
<tr><td align="right">Object Type: </td><td><formwidget id="object_type_id"/><font color="red"><formerror id="object_type_id"></formerror></td></tr>
<tr><td align="right">Description: </td><td><formwidget id="description"/></td></tr>
<tr><td align="right">URL: </td><td><formwidget id="url"/></td></tr>
<if @current_image@ ne "">
  <tr><td align="right">Current Image: </td><td><formwidget id="current_image"/></td></tr>
  <tr><td></td><td>@delete_image_link@</td></tr>
</if>
<tr><td align="right">Upload Image: </td><td><formwidget id="image"/></td></tr>
<if @event_id_p@ eq 1><tr><td align="right">Tag: </td><td><formwidget id="tag"/><font color="red"><formerror id="tag"></formerror></font></td></tr></if>
<tr><td colspan=2 align="center"><br><formwidget id="submit"/></td></tr>
</table>
</formtemplate>
