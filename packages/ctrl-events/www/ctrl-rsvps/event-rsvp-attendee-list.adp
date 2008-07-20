<master>
<property name="title">@page_title@</property>
<table width=100%>
<tr align=center><td><b>@page_title@</b>
<if @rsvp@ ne "Full" or @admin_p@ eq 1 or @user_id@ eq 0>
 -> Click<a href=@ae_link@><font color=red> here</font></a> to Register for This Event
</if>
<if @rsvp@ eq "Full">
 <font color=blue> (Full House)</font>
</if>
</td></tr>
</table>

<table width=25% align=left hspace=8 cellpadding="3" cellspacing="0" border="1">
<formtemplate id="event_rsvp">
<tr><td align="right">Title:</td><td><formwidget id="title"></td></tr>
<tr><td align="right">Event Object:</td><td><formwidget id="event_object_id"></td></tr>
<tr><td align="right">Category:</td><td><formwidget id="category_id"></td></tr>
<tr><td align="right">Start Date:</td><td><formwidget id="event_start_date"></td></tr>
<tr><td align="right">End Date:</td><td><formwidget id="event_end_date"></td></tr>
<tr><td align="right">Location:</td><td><formwidget id="location"></td></tr>
<tr><td align="right">Notes:</td><td><formwidget id="notes"></td></tr>
<tr><td align="right">Capacity:</td><td><formwidget id="capacity"></td></tr>
<tr><td align="right">Image:</td><td><formwidget id="event_image"></td></tr>
</formtemplate>
</table>


<!-- only admin can see RSVP name list -->
<if @get_event_attendee:rowcount@ ne 0>

<table id="standard" width="75%">
<tr>
<th>First Name<br>
<a href=@fnamea_link@><font color=blue><if @color_red@ eq fnamea><font color=red></if> ^</font></a>
<a href=@fnamed_link@><font color=blue><if @color_red@ eq fnamed><font color=red></if> v</font></a>
</th>
<th>Last Name<br>
<a href=@lnamea_link@><font color=blue><if @color_red@ eq lnamea><font color=red></if> ^</font></a>
<a href=@lnamed_link@><font color=blue><if @color_red@ eq lnamed><font color=red></if> v</font></a>
</th>
<th>E-mail<br>
<a href=@emaila_link@><font color=blue><if @color_red@ eq emaila><font color=red></if> ^</font></a>
<a href=@emaild_link@><font color=blue><if @color_red@ eq emaild><font color=red></if> v</font></a>
</th>
<th>Response</th>
<th>Approval</th>
<th>Has Role</th>
<th>Options</th>
</tr>

<multiple name="get_event_attendee">
<if @get_event_attendee.rownum@ odd>
   <tr bgcolor=#eeeeee>
</if>
<else>
    <tr bgcolor=#ffffff>
</else>
<td>@get_event_attendee.first_name@ </a></td>
<td>@get_event_attendee.last_name@ </a></td>
<td>@get_event_attendee.email@</td>
<td><a href=@responsef_link@'@get_event_attendee.response@'> @get_event_attendee.response@ </a></td>
<td><a href=@approvalf_link@'@get_event_attendee.approval@'> @get_event_attendee.approval@ </a></td>
<td align=center> @get_event_attendee.has_role@</td>
<td>
 <a href=@get_event_attendee.edit_link@><font color=blue>Edit</font></a>
 <a href=@get_event_attendee.delete_link@><font color=blue>Delete</font></a>
 <a href=@get_event_attendee.new_rsvp_role_link@><font color=blue>CreateRoles</font></a>
</td>
</tr>
</multiple>

</if>
<else>
<ul><li><font color=orange>no reservation found found</font></li></ul>
</else>
</table>



