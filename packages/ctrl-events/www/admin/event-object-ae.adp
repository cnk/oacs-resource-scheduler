<master>
<property name=title> @page_title@ </property>
@context_bar@
<br></br>
<formtemplate id="add_edit_event_object">
<table>
<tr><td align="right">Object Type: </td><td><formwidget id="object_type_id" onClick="displayLastName()"/><font color="red"><formerror id="object_type_id"></formerror></font></td></tr>
<tr><td align="right">Name: </td><td><formwidget id="name"/><font color="red"><formerror id="name"></formerror></font></td></tr>

<tr><td align="right"><span id="LastNameLabel" style=display:none;>Last Name: </span></td>
    <td><span id="LastNameWidget" style=display:none;><formwidget id="last_name"/>
	 <font color="red"><formerror id="last_name"></formerror></font>
    </span></td>
</tr>

<tr><td align="right">Description: </td><td><formwidget id="description"/><font color="red"><formerror id="description"></formerror></font></td></tr>
<tr><td align="right">URL: </td><td><formwidget id="url"/><font color="red"><formerror id="url"></formerror></font></td></tr>
<if @current_image@ ne "">
  <tr><td align="right">Current Image: </td><td><formwidget id="current_image"/><font color="red"><formerror id="current_image"></formerror></font></td></tr>
  <tr><td></td><td>@delete_image_link@</td></tr>
</if>
<tr><td align="right">Upload Image: </td><td><formwidget id="image"/><font color="red"><formerror id="image"></formerror></font></td></tr>
<if @event_id_p@ eq 1>
<tr><td align="right">Tag: </td><td><formwidget id="tag"/><font color="red"><formerror id="tag"></formerror></font></td></t>
<tr><td align="right">Group ID: </td><td><formwidget id="event_object_group_id"/><font color="red"><formerror id="event_object_group_id"></formerror></font></td></tr>
</if>
<tr><td colspan=2 align="center"><br><formwidget id="submit"/></td></tr>
</table>
</formtemplate>

<script type="text/javascript" src="../js/layer-procs.js"></script>
<script type="text/javascript">

displayLastName ();

function displayLastName () {
	
	if (document.forms.add_edit_event_object.object_type_id.value==document.forms.add_edit_event_object.speaker_name_cat_id.value) {
		showHideWidget('LastNameLabel','show');
		showHideWidget('LastNameWidget','show');
	} else {
		showHideWidget('LastNameLabel','hide');
		showHideWidget('LastNameWidget','hide');
		document.forms.add_edit_event_object.last_name.value="";
	}
}

</script>
