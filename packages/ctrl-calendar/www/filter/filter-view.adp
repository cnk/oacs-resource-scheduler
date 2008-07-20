<master>
<property name=title>@page_title;noquote@</property>
<property name=context>@page_title;noquote@</property>
<property name="header_stuff"><link rel="stylesheet" type="text/css" href="../resources/ctrl-calendar/calendar.css" media="all"></property>
<include src="view-option-panel" cal_id=@cal_id@ view_option="advanced">

<br><br>
<table width="100%" height=10>                                                                   
<tr><td width="25%" align="left" valign="top"><h1>@date_display_str;noquote@</h1>@weekday_display_str;noquote@</td>
    <td width="75" align="right">@calendar;noquote@</td></tr>
</table>
@day_view;noquote@
