<master>

<property name=title> @page_title@ </property>

<if @admin_p@>
<ul><h2>Actions:</h2>
<li><a href="@event_delete_link;noquote@">Delete this event</a></li>
<li><a href="@event_edit_link;noquote@">Edit this event</a></li>
</if>
</ul>
</if>

<center><H1>@page_title@</H1></center>
<table width=60% bgcolor="#74949F" align=center hspace=8 cellpadding="3" cellspacing="1" border="0">
<formtemplate id="view_event">
<tr><td align="right" bgcolor=#BBCAD1>Title:</td><td bgcolor=#eeeeee><formwidget id="title"></td></tr>
<tr><td align="right" bgcolor=#BBCAD1>Event Object:</td><td bgcolor=#eeeeee><formwidget id="event_object_id"></td></tr>
<tr><td align="right" bgcolor=#BBCAD1>Category:</td><td bgcolor=#eeeeee><formwidget id="category_id"> &nbsp;</td></tr>
<tr><td align="right" bgcolor=#BBCAD1>Start Date:</td><td bgcolor=#eeeeee><formwidget id="event_start_date"></td></tr>
<tr><td align="right" bgcolor=#BBCAD1>End Date:</td><td bgcolor=#eeeeee><formwidget id="event_end_date"></td></tr>
<tr><td align="right" bgcolor=#BBCAD1>Location:</td><td bgcolor=#eeeeee><formwidget id="location"> &nbsp;</td></tr>
<tr><td align="right" bgcolor=#BBCAD1>Notes:</td><td bgcolor=#eeeeee><formwidget id="notes"></td> &nbsp;</tr>
<tr><td align="right" bgcolor=#BBCAD1>Capacity:</td><td bgcolor=#eeeeee><formwidget id="capacity"> &nbsp;</td></tr>
<tr><td align="right" bgcolor=#BBCAD1>Image:</td><td bgcolor=#eeeeee><formwidget id="event_image"> &nbsp;</td></tr>
</formtemplate>
</table>

<br><br>
<table width=75% align=center>
<center><h2>All Associated Events:</h2></center>
<if @get_repeat_event_data:rowcount@ ne 0>
<tr><td colspan=2 align="center">
 <tr>
 <th>Event Name</th>
 <th>Object</th>
 <th>Start Date</th>
 <th>End Data</th>
 </tr>
 <multiple name="get_repeat_event_data">
 <tr>
 <td>@get_repeat_event_data.title@</td>
 <td>@get_repeat_event_data.object@</td>
 <td>@get_repeat_event_data.repeat_start_date@</td>
 <td>@get_repeat_event_data.repeat_end_date@</td>
 </tr>
 </multiple>
</td></tr>
</if>
<else>
<center><h3>No Event Found</h3></center>
</else>
</table>

<br><br>
<table>
<center><h2>All Associated Tasks:</h2></center>
<if @event_tasks:rowcount@ eq 0>
  <center><h3>No Task Found</h3></center>
</if>
<else>
 <tr bgcolor="#BBCAD1">
  <formtemplate id="event_tasks">
  <th>Title</th>
  <th>Task</th>
  <th>Assign By</th>
  <th>Due date</th>
  <th>Priority</th>
  <th>Start Date</th>
  <th>End Date</th>
  <th>Done</th>
<if @admin_p@ eq 1>
  <th>Action</th>
</if>
 </tr>

 <multiple name="event_tasks">
 <if @event_tasks.rownum@ even>
    <tr bgcolor=#eeeeee>
 </if>
 <else>
    <tr bgcolor=#ffffff>
 </else>

  <td>@event_tasks.title@</td>
  <td>@event_tasks.task_name@</td>
  <td>@event_tasks.name@</td>
  <td>@event_tasks.due_date@</td>
  <td>@event_tasks.priority@</td>
  <td>@event_tasks.start_date@</td>
  <td>@event_tasks.end_date@</td>
  <td>@event_tasks.percent_completed@ %</td>

<if @admin_p@ eq 1>
 <td valign=top align=center>
 <nobr>
  <a href="@event_tasks.task_ae_link;noquote@"><u>Edit</u></a>
  <a href="@event_tasks.task_delete_link;noquote@"><u>Delete</u></a>
 </nobr>
 </td>
</if>

 </tr>
 </multiple>
</formtemplate>
</else>

</table>

</formtemplate>
