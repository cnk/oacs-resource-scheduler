<master>
<property name="title">@title@</property>
<property name="context">@context@</property>
<table>
<tr><td valign="top">
<fieldset><legend>Info</legend>
<include src="/packages/ctrl-resources/www/panels/room" &room_info=room_info>
<if @calendar_view:rowcount@ ne 0>
<table>
<multiple name="calendar_view">
<tr>
 <th>Calendar:&nbsp;</th><td><a href="@calendar_view.calendar_link@">@calendar_view.cal_name@ - @calendar_view.description@</a></li></ul></td>
</tr>
</multiple>
</table>
</if>
</fieldset>
<br>
<fieldset><legend>Resources</legend>
<listtemplate name="resource_list_display"></listtemplate>
</fieldset>
<br>
<fieldset><legend>Request</legend>
<listtemplate name="request_list_display"></listtemplate>
</fieldset>
</td></tr><tr><td valign="top">
<include src="/packages/ctrl-resources/www/images-display" resource_id="@room_id@" action="display">
</td></tr>
</table>


