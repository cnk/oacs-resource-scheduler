<master>

<property name="title">@title@</property>

@cnsi_context_bar;noquote@

<formtemplate id="policy_form">
<fieldset>
<table>
<tr><th align="right">Policy name:<font color="red">*<formerror id="policy_name"></formerror></font></th><td align="left"><formwidget id="policy_name"></td></tr>
<tr><th align="right">Reservation end date can not after:<font color="red">*<formerror id="latest_resv_date"></formerror></font></th><td align="left"><formwidget id="latest_resv_date"></td></tr>
<tr><th align="right">Update allowed - time interval after reservation date:<br> </th><td align="left">
     <formwidget id="time_interval_after_resv_date_day"> Day(s)  <formwidget id="time_interval_after_resv_date_hour"> Hour(s) 
<formwidget id="time_interval_after_resv_date_min"> Minute(s) </td></tr>
<tr><td colspan="2" align="center">(Modifications are allowed only if the time interval after registration has not passed)</td></tr>

<tr><th align="right">Update allowed - time interval before start date:</th><td align="left">
     <formwidget id="time_interval_before_start_dte_day"> Day(s)  <formwidget id="time_interval_before_start_dte_hour"> Hour(s) 
<formwidget id="time_interval_before_start_dte_min"> Minute(s) </td></tr>
<tr><td colspan="2" align="center">(Modifications are allowed only if the time interval prior to start date has not passed)</td></tr>
<tr><th align="right">Time period reservation must be made ahead:</th><td>
     <formwidget id="resv_period_before_start_date_day"> Day(s)  <formwidget id="resv_period_before_start_date_hour"> Hour(s) 
<formwidget id="resv_period_before_start_date_min"> Minute(s) </td></tr>

<tr><th align="right">All Day Period Starts From:</th><td><formwidget id="all_day_period_start"></td></tr>
<tr><th align="right">All Day Period Ends At:</th><td><formwidget id="all_day_period_end"></td></tr>

<tr><th align="right">Priority Level:</th><td><formwidget id="priority_level"></td></tr>
<tr><td align="center" colspan="2"><formwidget id="formbutton:ok"> &nbsp;&nbsp;<formwidget id="formbutton:cancel"></td></tr>
</table>
</fieldset>

</formtemplate>
<p>
<fieldset><legend>@resource_title@</legend>
<br />
<if @resource_type@ eq room>
<include src="/packages/ctrl-resources/www/panels/room" &room_info=room_info>
</if><else>
<include src="/packages/ctrl-resources/resources/panes/resv-resource-display" &resv_resource_info=resv_resource_info>
</else>
</fieldset>
</p>
