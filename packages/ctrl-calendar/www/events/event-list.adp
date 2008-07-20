<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
<property name="header_stuff">
	<link rel="stylesheet" type="text/css" href="/resources/ctrl-calendar/calendar.css" media="all">
</property>

@header_stuff;noquote@
| <if @package_admin_p@ eq 1><a href="event-ae">Add an Event</a> | </if>
<a href="../profile-ae">Your Notifications</a> 

<include src="../view-option-panel"	&="cal_id"	&="julian_date"	view_option="list" />
<!-- include src="../live-filter"		&="cal_id"	&="julian_date"	view_option="list" / -->

<formtemplate id="event_list">
<table class="layout" cellpadding="0" cellspacing="0" style="border-top: 1px solid #666666; border-bottom: 1px solid #666666; background-color: #b1b3b4; padding-top: 0em" width="100%">
	<tr valign="top">
		<td style="padding-top: 0.45em"><label for="title">Title:</label></td>
		<td style="padding-top: 0.20em"><formwidget id="title" size="16" /></td>
		<td style="padding-top: 0.45em"><label for="mm_yyyy">Date:</label></td>
		<td><formwidget id="mm_yyyy" />
			<formerror id="mm_yyyy">
				<div class="form-error" style="color: red">@formerror.mm_yyyy;noquote@</div>
			</formerror>
		</td>
		<td style="padding-top: 0.45em">
			<formgroup id="archived_p">
			<label for="archived_p">Archived:</label>&nbsp;@formgroup.widget;noquote@&nbsp;@formgroup.label;noquote@
			</formgroup>
		</td>

		<td style="padding-top: 0.45em">
			<label for="calendar_p">Calendars <small>(click to expand)</small>:</label>
			<formgroup id="calendar_p" onClick="setCalendarSettings()">
				@formgroup.widget;noquote@ @formgroup.label;noquote@<br />
			</formgroup>
			<span id="calendar" style="display:none;">
				<formgroup id="calendar">
					@formgroup.widget;noquote@&nbsp;@formgroup.label;noquote@
					<br />
				</formgroup>
			</span>
		</td>
		<td><input type="submit" value="Search" /></td>
	</tr>
</table>
</formtemplate>

<script type="text/javascript" src="../js/layer-procs.js"></script>
<script type="text/javascript">
	function setCalendarSettings () {
	   if (document.forms.event_list.calendar_p.checked) {
		  showHideWidget('calendar','show');
	   } else {
		  showHideWidget('calendar','hide');
	   }
	}
	setCalendarSettings();
</script>

<table class="standard" width="100%">
<tr>
<td class="greycell" align="center" valign="middle">
<b>Legend:</b> 
</td><td class="greycell" align="center" valign="middle">
<img src="../images/outlookdownload" width="20" height="20" border="0" align=top alt="download calendar to Microsoft Outlook" valign=middle>
 Download Event to Microsoft Outlook. 
</td><td class="greycell" align="center" valign="middle">
<img src="../images/icaldownload"  width="20" height="20" border="0" align=top alt="download calendar to iCal" valign=middle>
 Download Event to iCal.
</td>
</tr>
<tr><td colspan="100%">
<if @events:rowcount@ eq 0>
<div class="form-error">
	<i style="color: red">No events found</i>
</div>
</if>
<else>
   <table class="standard" cellpadding="8" cellspacing="4" width="100%" border="0">
   <multiple name="events">
    <tr>
    <td valign="top" width="20%" class="whitecell">
	 <nobr><if @events.current_status@ eq "cancelled"><strike></if>
		<if @events.all_day_p@ eq "t">
	            @events.event_start_date_no_time@
	        </if>
	        <else>
	             @events.event_start_date@
	        </else>
	        <if @events.current_status@ eq "cancelled"></strike></if>
	 </nobr><br /><br />
	 @events.event_image_display;noquote@ <br />
	 @events.event_image_caption;noquote@ <br />
     </td>
     <td width="80%" valign="top" class="whitecell">
	  <if @events.current_status@ eq "cancelled"><b style="color: red">*** PLEASE NOTE: THIS EVENT HAS BEEN CANCELLED ***</b><br /><br /></if>
          <b>@events.event_title;noquote@</b><br />
          <table border="0" width="100%">
	  <if @events.speakers@ not nil><tr><td valign="top" align="right"><b>Speaker(s):</b></td><td valign="top">@events.speakers;noquote@</td></tr></if>
	  <tr><td valign="top" align="right"><b>Calendar(s):</b></td><td valign="top">@events.cal_names;noquote@</td></tr>
	  <tr><td valign="top" align="right"><b>Description:</b></td><td valign="top">@events.event_notes;noquote@</td></tr>
	  <if @events.event_location@ not nil>
		<tr><td valign="top" align="right"><b>Location:</b></td><td valign="top">@events.event_location;noquote@</td></tr>
	  </if>
	  <tr>	<td valign="top" align="right"><b>Date:</b></td>
		<td valign="top"><if @events.current_status@ eq "cancelled"><strike></if>@events.event_start_date;noquote@ to @events.event_end_date;noquote@
		  <if @events.current_status@ eq "cancelled"></strike></if>
		</td></tr>
	  <group column="event_id">
	  </group>
	  <if @events.categories@ ne "">
		<tr><td valign="top" align="right"><b>Categories:</b></td><td valign="top"> @events.categories;noquote@ <br />
   		  [<a href="event-category-add?event_id=@events.event_id@">Add these catgories to my profile</a>]
		</td></tr>
	  </if>
	  <tr><td colspan="2" align="right" valign="bottom">
		<a href="/calendar/vcs/@events.event_id@.vcs"><img src="../images/outlookdownload" width="20" height="20" border="0"  alt="download calendar to Microsoft Outlook"></a>
		<a href="/calendar/ics/@events.event_id@.ics"><img src="../images/icaldownload"  width="20" height="20" border="0"  alt="download calendar to iCal"></a>
	  </td></tr>
	  <if @events.event_admin_p@ eq 1><br />
		<tr><td colspan="2" style="border-top: 1px dotted #cccccc;"><img src="/images/spacer.gif" width=10 height=1></td></tr>
		<tr><td valign="top" colspan="2">
		<b>Administration:</b><br />
		<if @events.digest_posted_list@ not nil>
		  <br /><b>This event is posted on the following digests:</b><br />@events.digest_posted_list;noquote@
		</if>
		<if @events.digest_notposted_list@ not nil>
			<br /><b>Submit this event to:</b><br />@events.digest_notposted_list;noquote@
		</if>
		<br />
		</td></tr>
		<tr><td colspan="2" align="right">@events.edit_link;noquote@ | @events.delete_link;noquote@ | @events.cancel_link;noquote@ </td></tr>
	  </if>
	  </table>
     </td>
     </tr>
     <if @events.rownum@ ne @events:rowcount@>
         <tr bgcolor="white"><td colspan=2 style="border-top: 1px solid #666666;"><img src="/images/spacer.gif" width=10 height=1></td></tr>
     </if>
</multiple>
   </table>
</else>
</td></tr></table>
