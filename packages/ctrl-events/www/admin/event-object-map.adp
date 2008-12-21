<master>
@context_bar@
<br></br>

<include src="event-object-search" event_id=@event_id@ search_name=@search_name@ search_description=@search_description@ search_object_type=@search_object_type@ url="event-object-map">

<h3><li>Select an event object you wish to map @event_title@</li></h3>

<formtemplate id="event_object_map">
<table>
<tr><td>
<font color="red"><formerror id="event_object_id"></formerror></font>
<fieldset> <legend> <b><i>Event Objects</i></b></legend>
<table>
   <formgroup id="event_object_id"> 
      <if @formgroup.rownum@ odd><tr><td>@formgroup.widget@ @formgroup.label@ </td></if>
      <else><td>@formgroup.widget@ @formgroup.label@ </td></tr></else>
   </formgroup>
</table>
</fieldset>
<td></tr>
<tr><td>Tag for the selected event object: <formwidget id="tag"><font color="red"><formerror id="tag"></formerror></font></td></tr>
<tr><td>Group ID for the selected event object: <formwidget id="event_object_group_id"><font color="red"><formerror id="event_object_group_id"></formerror></font></td></tr>
<tr><td><br><formwidget id="submit"></td></tr>
</table>
</formtemplate>
<br>
