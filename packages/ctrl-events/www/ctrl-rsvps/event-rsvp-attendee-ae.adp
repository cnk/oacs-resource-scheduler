<master>

<property name="title">@page_title@</property>
<center><b>@page_title@</b></center>

<table width=30% align=left hspace=10 cellpadding="3" cellspacing="0" border="1" >
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

<table width=40% align=left>
<formtemplate id="event_rsvp1">
<tr><td align="right">E-mail<font color=red>*</font>:</td><td><formwidget id="email"><br><font color=red><formerror id="email"></formerror></font></td></tr>
<tr><td align="right">First Name<font color=red>*</font>:</td><td><formwidget id="first_name"><br><font color=red><formerror id="first_name"></formerror></font></td></tr>
<tr><td align="right">Last Name<font color=red>*</font>:</td><td><formwidget id="last_name"><br><font color=red><formerror id="last_name"></formerror></font></td></tr>
<if @admin_p@ eq 1>
 <tr><td align="right">Response:</td><td><formwidget id="response_status"></td></tr>
 <tr><td align="right">Approval:</td><td><formwidget id="approval_status"></td></tr>
 <tr>
  <td align="right">Assign Role:</td><td><formwidget id="attendee_role"><a href=@new_rsvp_role_link@><formwidget id="CreateRole"></td>
 </tr>
</if>
<tr>
<td align=right><formwidget id="Submit"></td>
<td>
  <if @page_title@ eq "Edit Event Rsvp Attendee"
   <a href=@delete_rsvp_link@><formwidget id="DeleteYourRSVP">
  </if>
</td>
</tr>
</table>
</formtemplate>

<if @attendee_role_exists_p@ gt 0>
<table width="30%" align=left>
<tr><td><font color=blue>@first_name@ @last_name@</font> Has been assigned for following roles:</td></tr>
<tr>
<th>Role</th>
<th>Action</th>
</tr>
<multiple name="get_attendee_role_name">
<tr>
  <if @get_attendee_role_name.rownum@ odd>
    <tr bgcolor=#eeeeee>
  </if>
  <if @get_attendee_role_name.rownum@ even>
    <tr bgcolor=#ffffff>
  </if>
<td>@get_attendee_role_name.name@</td>
<if @admin_p@ eq 1>
 <td><a href="@get_attendee_role_name.delete_link@"><font color=blue>Delete</font></a></td>
</if>
</tr>
</multiple>
</table>
</if>

