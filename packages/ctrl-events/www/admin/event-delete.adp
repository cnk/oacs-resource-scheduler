<master>

<property name=title> @page_title@ </property>
<property name=context> @context@ </property>

<center><H1>Delete Event</H1></center>
<formtemplate id="delete_event">

<table width=60% bgcolor="#74849F" align=center hspace=8 cellpadding=3 cellspacing=1 border=0>
<tr><td align=right bgcolor=#BBCAD1><b>Event Title:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="title"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Event Object:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="event_object_id"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Category:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="category_id")</td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Event Start Date:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="event_start_date"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Event End Date:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="event_end_date"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Location:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="location"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Notes:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="notes"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Capacity:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="capacity"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Image:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="event_image"></td></tr>
</table>

<table align=center border=0>
<if @get_repeat_event_data:rowcount@ ne 0>
<tr>
 <td></td>
 <td><formgroup id="event_delete_opt"> @formgroup.widget;noquote@ @formgroup.label@ &nbsp</formgroup></td>
</tr>
</if>
<tr><td colspan=2 align="center"><br><formwidget id="delete_btn"></td></tr>
</table>

<if @get_repeat_event_data:rowcount@ ne 0>
<tr><td colspan=2 align="center">
<br>
<p align="center"><b>All Associated Event(s)</b></p>
<table id="standard" align="center">
<tr>
<th id="admin">Event Name</th>
<th id="admin">Object</th>
<th id="admin">Start Date</th>
<th id="admin">End Date</td>
</tr>
<multiple name="get_repeat_event_data">
<tr>
<td id="admindata">@get_repeat_event_data.title@</td>
<td id="admindata">@get_repeat_event_data.object@</td>
<td id="admindata">@get_repeat_event_data.repeat_start_date@</td>
<td id="admindata">@get_repeat_event_data.repeat_end_date@</td>
</tr>
</multiple>
</table>
</if>

</formtemplate>
