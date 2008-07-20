<master>
<property name=title> @page_title@ </property>

<formtemplate id="add_edit_event">
<table>
<tr>
	<td align="right">Title:</td>
	<td><formwidget id="title"/><font color="red"><formerror id="title"></formerror></font></td>
</tr>

<tr>
	<td align="right">Category:</td>
	<td><formwidget id="category_id"/></td>
</tr>

<tr>
	<td align="right">Start Date:</td>
	<td><formwidget id="start_date"/><font color="red"><formerror id="start_date"></formerror></font>
	</td>
</tr>

<tr>
	<td align="right">End Date:</td>
	<td><formwidget id="end_date"/><font color="red"><formerror id="end_date"></formerror></font></td>
</tr>

<tr>
	<td align="right">All Day Event:</td>
	<td><formgroup id="all_day_p">@formgroup.widget;noquote@ @formgroup.label@</formgroup></td>
</tr>

<tr>
	<td align="right">Location:</td>
	<td><formwidget id="location"/><font color="red"><formerror id="location"></formerror></font>
	</td>
</tr>

<tr>
	<td align="right">Description:</td>
	<td><formwidget id="notes"/><font color="red"><formerror id="notes"></formerror></font></td>
</tr>

<tr>
	<td align="right">Capacity:</td>
	<td><formwidget id="capacity"/><font color="red"><formerror id="capacity"></formerror></font></td>
</tr>
<if @current_image@ ne "">
   <tr>
	<td align="right">Current Image:</td>
	<td><formwidget id="current_image"/></td>
    </tr>
    <if @edit_p@ eq 1 and @current_image@ ne "">
    <tr><td></td><td>@delete_image_link;noquote@</td></tr>
    </if>
</if>
<tr>
	<td align="right">Upload Event Image:</td>
	<td><formwidget id="event_image"/><font color="red"><formerror id="event_image"></formerror></font></td>
</tr>
<tr>
	<td align="right">Image Caption:</td>
	<td><formwidget id="event_image_caption"/><font color="red"><formerror id="event_image_caption"></formerror></font></td>
</tr>
<if @edit_p@ eq 0>
<tr>
	<td align="right">Repeating Event: </td>
	<td>
		<formgroup id="repeat_template_p" onClick="setDefaultSettings()">
			@formgroup.widget;noquote@ @formgroup.label@
		</formgroup>
	</td>
</tr>
</if>
<else><if @repeat_template_id@ ne "">
<tr>
<td align="right"></td>
<td><formgroup id="update_all_future_events_p">@formgroup.widget;noquote@</formgroup></td>
</tr>
</if>
</else>
</if>
<tr>
	<td> </td>
	<td> <span id="1" style=display:none;>
		<formgroup id="frequency_type" onClick="repeatType()"> 
			@formgroup.widget;noquote@ @formgroup.label@
		</formgroup>
	</span></td>
	
</tr>

<tr>	
	<td> </td>
	<td> <span id="Day" style=display:none;>Every &nbsp<formwidget id="frequency_day"/> &nbsp day(s) 
		<font color="red"><formerror id="frequency_day"></formerror><br>
	</span> </td>
	
</tr>

<tr>
	<td> </td>
	<td> <span id="Week" style=display:none;>Every &nbsp<formwidget id="frequency_week"/> &nbsp week(s) on
		<formgroup id="specific_days_week">
			<br>&nbsp&nbsp&nbsp&nbsp&nbsp @formgroup.widget;noquote@ @formgroup.label@ 
		</formgroup>				
	</span></td> 
</tr>

<tr>
	<td></td>
	<td><span id="Month" style=display:none;>
		<table>
		<tr><td>
			<formgroup id="repeat_month_opt1" onClick="repeatMonthOpt(1)"> 
				@formgroup.widget;noquote@ @formgroup.label@ &nbsp <formwidget id="specific_dates_of_month_month"/>&nbsp of every &nbsp
				<formwidget id="frequency_month"/>&nbsp month(s) 
				<font color="red"><formerror id="frequency_month"></formerror></font>
				<font color="red"><formerror id="specific_dates_of_month_month"></formerror><br>
			</formgroup>
		</td></tr>
		<tr><td><formgroup id="repeat_month_opt2" onClick="repeatMonthOpt(2)"> 
				@formgroup.widget;noquote@ @formgroup.label@ &nbsp 
			<formwidget id="specific_day_frequency"/>
			<formwidget id="specific_days_month"/></formgroup></td>
		</tr>
		</table>
	</span></td>
</tr>

<tr>
	<td></td>
	<td><span id="Year" style=display:none;>
		Every &nbsp <formwidget id="specific_months"/> <formwidget id="specific_dates_of_month_year"/> 
		<font color="red"><formerror id="specific_dates_of_month_year"></formerror></font>
	</span></td>
</tr>

<tr>
	<td></td>
	<td> <span id="End" style=display:none;><br>End: &nbsp
		<table>
		<tr><td>
			<formgroup id="repeat_end_date_opt">
				<br>@formgroup.widget;noquote@ @formgroup.label@
			</formgroup>
		</td></tr>
		<tr><td><blockquote>
			<formwidget id="repeat_end_date"/></blockquote>
		</td></tr>
		</table>
	</span></td>
</tr>
<tr><td>&nbsp;</td><td valign="left"><formwidget id="submit"/></td>
</tr>
</table>
<formwidget id="event_object_id" />
<formwidget id="event_id" />
</formtemplate>

<script type="text/javascript" src="../js/layer-procs.js"></script>
<script type="text/javascript" src="../js/radio-button-operations.js"></script>
<script type="text/javascript" src="../js/repetition-procs.js"></script>

<script type="text/javascript">
	setDefaultSettings();
</script>
