<master>
<property name=title> @title@ </property>
<property name="header_stuff"><link rel="stylesheet" type="text/css" href="/resources/ctrl-calendar/calendar.css" media="all"></property>

<table cellpadding=5 cellspacing=3 border=0>
<if @create_p@ eq 1>
<td style="border: 1px solid #999999; background-color: #EFE1E1;">
<a href="@add_public_link;noquote@">Create Calendar</a>&nbsp;</td>
</if>
<td style="border: 1px solid #999999; background-color: #EFE1E1;"><a href="../events/event-list">Public Calendar Pages</a></td>
<td style="border: 1px solid #999999; background-color: #EFE1E1;"><a href="rss/cal_filter_@user_id@.xml">RSS</a></td>
</tr>
</table>
<br>
<table id="standard" width="100%">
<if @public_cals:rowcount@ eq 0><br>
<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None Defined. </td></tr>
</if><else>
<tr><th align=left style="padding-bottom: 10px;">Calendar Administration</th></tr>
<tr><td>
  <table width="100%" id="mainbody">

  <tr><th id="header" width="20%"> Name </th> 
      <th id="header" width="60%"> Description</th> 
      <th id="header" width="20%"> Options </th></tr>

  <multiple name="public_cals">
       <tr>
     	<td id="datadisplay" align=left valign=middle><a href=@public_cals.view_events@>@public_cals.cal_name;noquote@</a></td>  
 	<td id="datadisplay" align=left valign=middle>@public_cals.description;noquote@</td>  
     	<td id="datadisplay" align=center valign=middle>  <!-- <a href=@public_cals.view_events@> Upcoming Events </a> -->
           <if @public_cals.admin_p@>
	      <nobr>[ <a href=@public_cals.edit_link@> Edit </a> | <a href=@public_cals.delete_link@> Delete</a> | <a href=@public_cals.permission_link@>Permissions</a>]</nobr>
	      <br>
   	      [ <a href=@public_cals.add_event_link@>Add an Event</a> ]
	      <br>
   	      <nobr>[ <a href=@public_cals.view_filter_link@>View filters</a> ] | [ <a href=@public_cals.add_filter_link@>Add a filter</a> ]</nobr>
	      <br><br>
     	   </if>
	   <table width="100%" class="topnavbar">
	    	<tr>
	   	<td colspan="4" class="navcell">
			BROWSE BY:</td>
		</tr>
		<tr>
		<td class="navcell">
		<img src="/resources/ctrl-calendar/images/calendar_view_day.gif" class="topnavbar-icon" alt="DAY" align=middle />
		<a class="small" href=@public_cals.view_day@>DAY</a></td>
		
		<td class="navcell">
		<img src="/resources/ctrl-calendar/images/calendar_view_week.gif" class="topnavbar-icon" alt="WEEK" align=middle />
		<a class="small" href=@public_cals.view_week@>WEEK</a></td>

		<td class="navcell">
		<img src="/resources/ctrl-calendar/images/calendar_view_month.gif" class="topnavbar-icon" alt="MONTH" align=middle />
		<a class="small" href=@public_cals.view_link@>MON</a></td>

		<td class="navcell">
		<img src="/resources/ctrl-calendar/images/rss_feed.gif" class="topnavbar-icon" alt="RSS" align=middle />
		<a class="small" href=@public_cals.rss_feed@>RSS</a></td>
		
		</td></tr>
	    </table>  	
	    <br>
	</td></tr>
  </multiple>
  </table>
</td></tr>
</else>
</table>

<table id="standard" width="100%">
<if @private_cals:rowcount@ eq 0><br>
<tr><td style="padding-bottom: 10px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
</if><else>
<tr><th align=left style="padding-bottom: 10px;">Private Calendar of Events</th></tr>
<tr><td>
  <table width="100%" id="mainbody">
  <tr><th id="header" width="20%"> <b>Name</b> </th> 
      <th id="header" width="60%"> <b>Description</b></th> 
      <th id="header" width="20%"> <b>Options</b> </th></tr>

  <multiple name="private_cals">
     <if @private_cals.rownum@ odd>
       <tr>
     </if><else>
       <tr>
     </else>   
     <td id="datadisplay"><a href=@private_cals.view_link@>@private_cals.cal_name;noquote@</a></td>  
     <td id="datadisplay">@private_cals.description;noquote@</td>
     <td id="datadisplay" align=center valign=top>  <a href=@private_cals.view_events@> View All Events </a> <br>
[ <a href=@private_cals.view_link@>Month</a> | <a href=@private_cals.view_week@>Week</a> | <a href=@private_cals.view_day@>Day</a> ] <br><br>
[ <a href=@private_cals.edit_link@> Edit </a> | <a href=@private_cals.delete_link@> Delete</a> ]
<br>
[ <a href=@public_cals.add_event_link@>Add an Event</a> 
<br>
<nobr>[ <a href=@public_cals.view_filter_link@>View filters</a> ] | [ <a href=@public_cals.add_filter_link@>Add a filter</a> ]</nobr>
</td
</tr>  
  </multiple>
  </table>
</td></tr>
</else>
</table>
