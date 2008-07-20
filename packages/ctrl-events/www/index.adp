<master>
<property name=title> @page_title@ </property>
@context_bar;noquote@<br></br>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">

<br>
<center><b>@page_title@</b></center>
<table width="100%">
<tr><th align="left" valign="top"><formtemplate id="search_form"></formtemplate></th></tr>
<tr><th align="left">Go @pagination_nav_bar;noquote@</th>
<th align="right"><b>Action:</b> @event_add_link;noquote@</th></tr>
</table>

<if @get_events_data:rowcount@ eq 0>
	<tr bgcolor=#ffffff><td align=center colspan=7><i>No Events Currently</td></tr>
</if>
<else>

<table width="100%" bgcolor="#74949F" valign="top" cellpadding="0" cellspacing="0" border="0">

<tr><td valign="top">
	<table width=100% cellpadding="4" cellspacing="1" border="0"> <tr bgcolor="#BBCAD1">

<th id="admin"><nobr>Event Name
<a href="index?order_by=title&order_dir=asc&color_red=titlea"><font color=blue><if @color_red@ eq titlea><font color=red></if> ^</font></a>
<a href="index?order_by=title&order_dir=desc&color_red=titled"><font color=blue><if @color_red@ eq "titled"><font color=red></if> v</font></a>
</nobr></th>
<th id="admin"><nobr>Object
<a href="index?order_by=event_object&order_dir=asc&color_red=objecta"><font color=blue><if @color_red@ eq objecta><font color=red></if> ^</font></a>
<a href="index?order_by=event_object&order_dir=desc&color_red=objectd"><font color=blue><if @color_red@ eq objectd><font color=red></if> v</font></a>
</nobr></th>
<th id="admin"><nobr>Start Date
<a href="index?order_by=start_date_sort&order_dir=asc&color_red=sdatea"><font color=blue><if @color_red@ eq sdatea><font color=red></if> ^</font></a>
<a href="index?order_by=start_date_sort&order_dir=desc&color_red=sdated"><font color=blue><if @color_red@ eq sdated><font color=red></if> v</font></a>
</nobr></th>
<th id="admin"><nobr>End Date
<a href="index?order_by=end_date_sort&order_dir=asc&color_red=edatea"><font color=blue><if @color_red@ eq edatea><font color=red></if> ^</font></a>
<a href="index?order_by=end_date_sort&order_dir=desc&color_red=edated"><font color=blue><if @color_red@ eq edated><font color=red></if> v</font></a>
</nobr></th>
<if @admin_p@ eq 1>
<th id="admin"><nobr>Options</nobr></th>
</if>
<!--
<th id="admin"><nobr><font color=green>RSVP</font></nobr></th>
-->
</tr>

<multiple name="get_events_data">
<if @get_events_data.rownum@ odd>
    <tr bgcolor=#eeeeee>
</if>
<else>
    <tr bgcolor=#ffffff>
</else>

<td valign=top>
<a href="@get_events_data.view_link@"> @get_events_data.title@ </a>
</td>
<td valign=top>@get_events_data.event_object@</td>
<td valign=top>@get_events_data.start_date@</td>
<td valign=top>@get_events_data.end_date@</td>

<if @admin_p@ eq 1>
<td>
 <a href="@get_events_data.edit_link@"><font color=blue>Edit</font></a>
 <a href="@get_events_data.delete_link@"><font color=blue>Delete</font></a>
</td>
</if>

<!--
<td valign=top>
<if @get_events_data.rsvp@ eq N/A>
   @get_events_data.rsvp@
</if>
<elseif @get_events_data.rsvp@ eq Full>
 <a href="@get_events_data.rsvp_link@"><font color=orange><b>@get_events_data.rsvp@</b></font></a>
</elseif>
<else>
 <a href="@get_events_data.rsvp_link@"><font color=red>@get_events_data.rsvp@</font></a>
</else>
</td>
-->
</tr>
</multiple>

</else>
</table>
</td></tr></table>
</div>
