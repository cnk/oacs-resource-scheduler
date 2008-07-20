<master src="view-option-panel">
<property name="title">@page_title;noquote@</property>
<property name="context">@context@</property>
<property name="cal_id">@cal_id@</property>
<property name="julian_date">@julian_date@</property>
<property name="view_option">viewall</property>

<table border=0 cellpadding=2 cellspacing=2 width="60%" align=center> 
<if @admin_p@><tr><td align=right>@event_ae_link;noquote@</td></tr></if>
<if @all_events:rowcount@ eq 0>
<tr><td align=center><i>No upcoming events for this calendar.<p></i></td></tr>
</if><else>
<multiple name="all_events">
<tr><td><table bgcolor=white width="100%">
    <tr><td id="calendar-hdr"><h2>@all_events.title@</h2></td></tr>
    <tr><td><B>From:&nbsp;</B>@all_events.start_date@</td></tr>
    <tr><td><B>To:&nbsp;</B>@all_events.end_date@<p></td></tr>
    <tr><th align=left>Note:&nbsp;</th></tr>
    <tr><td>@all_events.notes@<p></td></tr>
    <tr><td><B>Location:&nbsp;</B>@all_events.location@<p></th></tr>
    <tr><td><B>Capacity:&nbsp;</B>@all_events.capacity@<p></th></tr>
    <tr><td><B>Options:&nbsp;</B>@all_events.vcs_link;noquote@&nbsp;|&nbsp;@all_events.ics_link;noquote@&nbsp;<if @admin_p@>|&nbsp;@all_events.edit_link;noquote@&nbsp;|&nbsp;@all_events.delete_link;noquote@&nbsp;</if></th></tr>
</table></td></tr>
</multiple>
</else>
</table>


<p>
