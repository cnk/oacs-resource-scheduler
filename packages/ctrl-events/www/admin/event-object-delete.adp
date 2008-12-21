<master>
<property name=title> @page_title@ </property>
@context_bar@
<br></br>

<center><H1>@page_title@</H1></center>
<formtemplate id="delete_event_object">

<table width=60% bgcolor="#74849F" align=center hspace=8 cellpadding=3 cellspacing=1 border=0>
<tr><td align=right bgcolor=#BBCAD1><b>Name:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="name"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Object Type:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="object_type"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Description:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="description")</td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>URL:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="url"></td></tr>
<tr><td align=right bgcolor=#BBCAD1><b>Image:&nbsp;&nbsp;</b></td><td bgcolor=#eeeeee><formwidget id="image"></td></tr>
</table>

<p align="center"><formwidget id="delete_btn"></p>

</formtemplate>
<if @get_mapped_events:rowcount@ eq 0>
<center><h1><i>No Events Associated with this Event Object</i></h1></center>
</if>
<else>
<br>
<center><h1>All Associated Events</h1></center>
<table width=90% bgcolor="#74849F" align=center hspace=8 cellpadding=3 cellspacing=1 border=0>
<tr><th>Event Title</th><th>Event Location</th><th>Category</th><th>Start Time</th><th>End Time</th><th>Tag</th><th>Group ID</th></tr>
<multiple name="get_mapped_events">
 <if @get_mapped_events.rownum@ odd>
        <tr bgcolor="#ffffff">
 </if>
 <else>
        <tr bgcolor="#eeeeee">
 </else>
 <td>@get_mapped_events.title@</td>
 <td>@get_mapped_events.location@</td>
 <td>@get_mapped_events.name@</td>
 <td>@get_mapped_events.start_date@</td>
 <td>@get_mapped_events.end_date@</td>
 <td>@get_mapped_events.tag@</td>
 <td>@get_mapped_events.event_object_group_id@</td>
 </tr>
</multiple>
</table>
</else>
<br>
