<master>
<property name="title">@title@</property>
<property name="context">@context@</property>
<fieldset><legend>Info</legend>
<formtemplate id="request_form">
<table>
<tr align=left><th>Name:</th><td><formwidget id="name"></td></tr>
<tr align=left><th>Description:</th><td><formwidget id="description"></td></tr>   
<tr align=left><th>Status: </th><td><formwidget id="status">&nbsp;
<if @mode@ eq "display">@toggle_status_url;noquote@</if></td></tr>
<tr align=left><th>Requested By: </th><td><fomwidget id="requested_by"></td></tr>
<tr align=left><th>Reserved By: </th><td><formwidget id="reserved_by"></td></tr>
<if @mode@ eq "edit"><tr><td colspan=2><formwidget id="ok_btn"></td></tr></if>
</table>
</formtemplate>
<!--include src="/packages/ctrl-resources/www/panels/request" &request_info=request_info-->
</fieldset>
<br>
<fieldset><legend>Events</legend>
<listtemplate name="event_list_display"></listtemplate>
</fieldset>


