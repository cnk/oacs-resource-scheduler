<master>
<property name="title">@page_title@</property>
<center><h1>@page_title@</h1></center>

<formtemplate id="event_rsvp_ae">
<table align=center border>
<tr><td>Title: <formwidget id=title></td></tr>
<tr><td>Category: <formwidget id=category></td></tr>
<tr><td>Start Date: <formwidget id=start_date></td></tr>
<tr><td>End Date: <formwidget id=end_date></td></tr>
<tr><td>Location: <formwidget id=location></td></tr>
<tr><td>Approval Required: 
	<formgroup id="approval_required_p" onClick="repeatType()"> 
			@formgroup.widget;noquote@ @formgroup.label@
	</formgroup>
</td></tr>
<tr><td>Registration Start: <formwidget id=registration_start></td></tr>
<tr><td>Registration End: <formwidget id=registration_end></td></tr>
<tr><td>Capacity Consideration: 
	<formgroup id="capacity_consideration_p" onClick="repeatType()"> 
			@formgroup.widget;noquote@ @formgroup.label@
	</formgroup>
</td></tr>
<tr><td>Capacity: <formwidget id=capacity></td></tr>
</table>
<br>
<center>
 <formwidget id="Submit">
 <if @page_title@ eq "Edit RSVP Setup">
  <formwidget id="Delete">
 </if>
</center>


<if @event_rsvp_attendees:rowcount@ ne 0>
<br><br>
<table width=75% align=center border=1 cellpadding=0 celspacing=0>
<tr><th colspan=4><H2>All Attendees</H2></th></tr>
<br>
<tr>
<th id="admin" align=left>Last Name</th>
<th id="admin" align=left>First Name</th>
<th id="admin" align=left>Email</th>
<th id="admin" align=left>Sign-in Date</th>
</tr>
<multiple name="event_rsvp_attendees">
<tr>
<td id="admindata">@event_rsvp_attendees.last_name@</td>
<td id="admindata">@event_rsvp_attendees.first_name@</td>
<td id="admindata">@event_rsvp_attendees.email@</td>
<td id="admindata">@event_rsvp_attendees.signin_date@ &nbsp;</td>
</tr>
</multiple>
</table>
<br><br>
</if>
<else>
</else>
</formtemplate>
