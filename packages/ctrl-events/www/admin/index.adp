<master>
<property name=title>@page_title@</property>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">
<br>
<center><b>@page_title@</b></center><br>

<table width="100%">
<tr><th align="left" valign="top"><formtemplate id="event_category_list">Category: <formwidget id="category_id"> <formwidget id="submit_filter"></formtemplate></nobr></th>
<tr><th align="left">@pagination_nav_bar;noquote@ </nobr></th>
<th align="right" valign="middle">@event_add_link;noquote@</nobr></th></tr>
</table>
<table width="100%" bgcolor="#74949F" valign="top" cellpadding="0" cellspacing="0" border="0">
    <tr><td valign="top">
	<table width=100% cellpadding="4" cellspacing="1" border="0"> <tr bgcolor="#BBCAD1">

<th><nobr>Event Title
<a href="index?order_by=title&order_dir=asc&color_red=titlea"><font color=blue><if @color_red@ eq titlea><font color=red></if>^</font></a>
<a href="index?order_by=title&order_dir=desc&color_red=titled"><font color=blue><if @color_red@ eq titled><font color=red></if>v</font></a>
</nobr></th>

<th><nobr>Category 
<a href="index?order_by=category_name&order_dir=asc&color_red=categorya"><font color=blue><if @color_red@ eq categorya><font color=red></if>^</font></a>
<a href="index?order_by=category_name&order_dir=desc&color_red=categoryd"><font color=blue><if @color_red@ eq categoryd><font color=red></if>v</font></a>
</nobr></th>

<th><nobr>Start Date 
<a href="index?order_by=start_date_sort&order_dir=asc&color_red=sdatea"><font color=blue><if @color_red@ eq sdatea><font color=red></if>^</font></a>
<a href="index?order_by=start_date_sort&order_dir=desc&color_red=sdated"><font color=blue><if @color_red@ eq sdated><font color=red></if>v</font></a>
</nobr></th>

<th><nobr>End Date 
<a href="index?order_by=end_date_sort&order_dir=asc&color_red=edatea"><font color=blue><if @color_red@ eq edatea><font color=red></if>^</font></a>
<a href="index?order_by=end_date_sort&order_dir=desc&color_red=edated"><font color=blue><if @color_red@ eq edated><font color=red></if>v</font></a>
</nobr></th>

<th><nobr>Location 
<a href="index?order_by=location&order_dir=asc&color_red=locationa"><font color=blue><if @color_red@ eq locationa><font color=red></if>^</font></a>
<a href="index?order_by=location&order_dir=desc&color_red=locationd"><font color=blue><if @color_red@ eq locationd><font color=red></if>v</font></a>
</nobr></th>

<th><nobr>Actions</nobr></th>
</tr>

<if @event_list:rowcount@ eq 0>
  <tr bgcolor=#ffffff><td align=center colspan=7><i>No Events</td></tr>
</if>
<else>
<multiple name="event_list">
 <if @event_list.rownum@ odd>
	<tr bgcolor="#ffffff">
 </if>
 <else>
	<tr bgcolor="#eeeeee">
 </else>

 <td><a href="@package_url@event-view?event_id=@event_list.event_id@">@event_list.title@</a></td>
 <td>@event_list.category_name@</td>
 <td>@event_list.start_date@</td>
 <td>@event_list.end_date@</td>
 <td>@event_list.location@</td>
 <td>
	<nobr>
	<a href="event-ae?event_id=@event_list.event_id@">Edit</a>
	<a href="event-delete?event_id=@event_list.event_id@">Delete</a>
	<a href="event-object-list?event_id=@event_list.event_id@">Event Object</a>
	<a href="/ctrl-events/tasks/admin?event_id=@event_list.event_id@">Tasks</a>
	<a href="event-signin?event_id=@event_list.event_id@">Sign-In</a>
	
	<a href="event-rsvp-ae?rsvp_event_id=@event_list.event_id@">
	 <if @event_list.rsvp_ok@ eq 0><font color=red></if>
	 RSVP
	</a>
	</nobr>
 </td>
 </tr>
</multiple>
</else>

</table>
</td></tr></table>

</div>


