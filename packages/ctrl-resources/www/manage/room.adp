<master>
<property name="title">@title@</property>
<property name="context">@context@</property>
<property name="header_stuff"><link rel="stylesheet" type="text/css" href="/resources/ctrl-calendar/calendar.css" media="all"></property>

@cnsi_context_bar;noquote@

<table width=750>
<tr><td valign="top" width=570>
<fieldset><legend>Room ::
                       <a href="room-ae?room_id=@room_id@">Edit</a> ::
                       <a href="room-delete?room_id=@room_id@">Delete</a> ::
                       <a href="image-add?resource_id=@room_id@">Add an Image</a> ::
		       <a href="/permissions/one?object_id=@room_id@">Permissions</a> ::
                       <a href="advance?room_id=@room_id@">Advanced</a></legend>
<include src="/packages/ctrl-resources/www/panels/room" &room_info=room_info>
<if @calendar_exists_p@ eq 1>
    <table>
    <tr><th>Calendar:&nbsp;</th><td><a href="@calendar_link@">@cal_name@ - @description@</a></td></tr>
    </table>
</if>
</fieldset>

<br />
<fieldset><legend> Policy [<a href='@policy_edit_url@'>Edit</a> | <a href='@policy_assign_url@'>Assignment</a>] </legend>
<include src="/packages/ctrl-resources/resources/panes/resv-policy-display" &policy_info=policy_info>
</fieldset>


<br>
<fieldset><legend>Equipment ::
                            <a href="@href_add_resource_non_reservable@">Add a Fix Equipment</a> ::
                            <a href="@href_add_resource_reservable@">Add a Reservable Equipment</a></legend>
<listtemplate name="resource_list_display"></listtemplate>
</fieldset>

<br>
<fieldset><legend>Requests</legend>
<listtemplate name="request_list_display"></listtemplate>
</fieldset>
</td>

<td valign="top" width="180">
<if @calendar_exists_p@ eq 1><fieldset><legend>Month View</legend>
<include src="/packages/ctrl-calendar/www/view-month-small" base_url="?room_id=@room_id@" date="@date_for_month_widget@" view="day"></fieldset></if>
<br>
<br>
<include src="/packages/ctrl-resources/www/images-display" resource_id="@room_id@" action="display" manage_p=1 subdir="">
</td></tr>
</table>
<br/>
<a href="../">Return to Administration Index</a>
<br/><br/>
