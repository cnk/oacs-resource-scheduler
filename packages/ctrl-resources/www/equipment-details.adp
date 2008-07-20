<master>
<property name=title> @page_title@</property>
<property name=context> @page_context@</property>

@cnsi_context_bar;noquote@

<table width="100%" border=0 cellpadding=4 cellspacing=0>
<tr><td valign="top">
<fieldset>
<legend>Detailed Equipment Information</legend>
<table width="100%">
<tr bgcolor=#eeeeee width=25%> <td align=left><b>Name:</b></td>        <td width=75%>@equipment_info.name@</td>         </tr>
<tr bgcolor=#ffffff> <td align=left><b>Description:</b></td> <td>@equipment_info.description@ </td> </tr>
<if @equipment_info.how_to_reserve@ not nil><tr bgcolor=#eeeeee><td align=left><b>How to Reserve:</b></td><td>@equipment_info.how_to_reserve@</td></tr></if>
<tr bgcolor=#eeeeee><td align=left><b>Location:</b></td><td>
<if @equipment_info.address_line_1@ not nil>@equipment_info.address_line_1@<br></if>
<if @equipment_info.address_line_2@ not nil>@equipment_info.address_line_2@<br></if>
<if @equipment_info.address_line_3@ not nil>@equipment_info.address_line_3@<br></if>
<if @equipment_info.building@ not nil>Building: @equipment_info.building@<br></if>
<if @equipment_info.floor@ not nil>Floor: @equipment_info.floor@<br></if> <if @equipment_info.room@ not nil>Room: @equipment_info.room@<br></if>
</td></tr>
<tr bgcolor=#ffffff><td align=left><b>Owner:</b></td><td>@equipment_info.owner@</td></tr>
</table>
</fieldset>
</td>
<td valign="top"><include src="/packages/ctrl-resources/www/images-display" resource_id="@resource_id@" action="display">
</td>
</tr></table>

<br><br>

<table width="100%" border=0 cellpadding=4 cellspacing=0>
<tr><td valign="top">
<formtemplate id="add_edit_event">
<fieldset>
<legend>Reservation Details</legend>
<table>
   <tr>
      <th align=right>Title <font color="red">*</font></th>
      <td><formwidget id="title"/><font color="red"><formerror id="title"></formerror></font></td>
   </tr>
<tr>
        <th align=right>Start Date:</td>
        <td><formwidget id="start_date"/><font color="red"><formerror id="start_date"></formerror></font>
        </td>
</tr>

<tr>
        <th align=right>End Date:</td>
        <td><formwidget id="end_date"/><font color="red"><formerror id="end_date"></formerror></font></td>
</tr>

<tr>
        <th align=right>All Day Event:</td>
        <td><formgroup id="all_day_p">@formgroup.widget;noquote@ @formgroup.label;noquote@</formgroup></td>
</tr>
<tr>
        <th align=right>Repeating Event:</td>
        <td>
                <formgroup id="repeat_template_p" onClick="setDefaultSettings()">
                        @formgroup.widget;noquote@ @formgroup.label;noquote@
                </formgroup>
        </td>
</tr>

<tr><td>&nbsp;</td><td><formwidget id="submit"/></td> </tr>

</table>
</fieldset>
</formtemplate>
</td>
</tr>
</table>
