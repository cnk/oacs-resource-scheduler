<master>
<property name=title> @page_title;noquote@</property>
<property name=context> @page_context;noquote@</property>

@cnsi_context_bar;noquote@

<table width="100%" border=0 cellpadding=4 cellspacing=0>
<tr><td valign="top">
<fieldset>
<legend>Detailed Room Information</legend>
<table width="100%">
<tr bgcolor=#eeeeee>
  <td align=left><b>Name:</b></td> <td align=right>@room_info.name@</td> <td align=left><b>Description:</b></td> <td align=right>@room_info.description@ </td>
</tr>

<tr bgcolor=#ffffff>
  <td align=left><b>Room:</b></td> <td align=right>@room_info.room@ </td> <td align=left><b>Floor</b></td> <td align=right>@room_info.floor@ </td>
</tr>

<tr bgcolor=#eeeeee>
  <td align=left><b>Capacity:</b></td> <td align=right>@room_info.capacity@</td> <td align=left><b>Dimensions:</b></td> <td align=right>@room_info.width@ x @room_info.length@ x @room_info.height@ </td>
</tr>

<tr bgcolor=#ffffff>
  <td align=left><b>Approval Required?:</b></td> <td align=right> <if @room_info.approval_required_p@ eq 1>Yes</if><else>No</else> </td> <td align=left><b>Property Tag</b></td> <td align=right>@room_info.property_tag@ </td>
</tr>

<tr bgcolor=#eeeeee>
  <td align=left><b>Additional Services:</b></td> <td colspan=3 align=right>@room_info.services@ </td>
</tr>
 <tr><td><b>Room Contact Info:</b></b></td><td> <if @room_info.how_to_reserve@ not nil>@room_info.how_to_reserve@</if><else><i>none available</i></else></td></tr>
</table>
</fieldset>
</td>
<td valign="top">

<fieldset>
<legend>Current Reservations</legend>


<table>
<tr>
<td rowspan=4>
 @calendar;noquote@ 
 @view_monthly_link;noquote@ <br/>
 @view_weekly_link;noquote@ <br/>
 @view_daily_link;noquote@ 
</td>
<td>
   <table>
   <tr><td bgcolor="#ffffff" width="10"><font color="#ffffff">| |</font></td><td> -Free Day</td></tr>
   <tr><td bgcolor="#FF0000" width="10"><font color="#FF0000">| |</font></td><td> -Busy Day</td></tr>
   <tr><td bgcolor="#00FF99" width="10"><font color="#00FF99">| |</font></td><td> -Moderate Day</td></tr>
   <tr><td bgcolor="#F2F29A" width="10"><font color="#F2F29A">| |</font></td><td> -Current Day</td></tr>
   </table>
</td>
</tr>
</table>
</fieldset>

</td>
</tr></table>

<br>

<if @has_address_info_p@ true> 
 <b>Address information:</b><br><br>
 <table>
 <if @address_info.address_line_1@ ne "">
  <tr>
   <td align=left>@address_info.address_line_1@</td> 
  </tr>
 </if>
 <if @address_info.address_line_2@ ne "">
  <tr>
   <td align=left>@address_info.address_line_2@</td> 
  </tr>
 </if>
 <if @address_info.address_line_3@ ne "">
  <tr>
   <td align=left>@address_info.address_line_3@</td> 
  </tr>
 </if>
 <if @address_info.address_line_4@ ne "">
  <tr>
   <td align=left>@address_info.address_line_4@</td> 
  </tr>
 </if>
 <if @address_info.address_line_5@ ne "">
  <tr>
   <td align=left>@address_info.address_line_5@</td> 
  </tr>
 </if>
 <tr>
   <td> @address_info.city@, @address_info.state_name@ @address_info.zipcode@</td> 
 </tr>
 </table>
</if>
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
	<th align=right>Description</th>
	<td><formwidget id="description"/><font color="red"><formerror id="description"></formerror></font></td>
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
<if @edit_p@ eq 0>
<tr>
	<th align=right>Repeating Event:</td>
	<td>
		<formgroup id="repeat_template_p" onClick="setDefaultSettings()">
			@formgroup.widget;noquote@ @formgroup.label;noquote@
		</formgroup>
	</td>
</tr>
</if>
<tr>
	<td> </td>
	<td> <span id="1" style=display:none;>
		<formgroup id="frequency_type" onClick="repeatType()"> 
			@formgroup.widget;noquote@ @formgroup.label;noquote@
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
			<br>&nbsp&nbsp&nbsp&nbsp&nbsp @formgroup.widget;noquote@ @formgroup.label;noquote@ 
		</formgroup>
	</span></td>
</tr>

<tr>
	<td></td>
	<td><span id="Month" style=display:none;>
		<table>
		<tr><td>
			<formgroup id="repeat_month_opt1" onClick="repeatMonthOpt(1)"> 
				@formgroup.widget;noquote@ @formgroup.label;noquote@ &nbsp <formwidget id="specific_dates_of_month_month"/>&nbsp of every &nbsp
				<formwidget id="frequency_month"/>&nbsp month(s) 
				<font color="red"><formerror id="frequency_month"></formerror></font>
				<font color="red"><formerror id="specific_dates_of_month_month"></formerror><br>
			</formgroup>
		</td></tr>
		<tr><td><formgroup id="repeat_month_opt2" onClick="repeatMonthOpt(2)"> 
				@formgroup.widget;noquote@ @formgroup.label;noquote@ &nbsp 
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
	<td> <span id="End" style=display:none;>End: &nbsp
		<table>
		<tr><td>
			<formgroup id="repeat_end_date_opt">
				<br>@formgroup.widget;noquote@ @formgroup.label;noquote@
			</formgroup>
		</td></tr>
		<tr><td><blockquote>
			<formwidget id="repeat_end_date"/></blockquote>
		</td></tr>
		</table>
	</span></td>
</tr>

<if @default_equipment_display@ ne "">
 <tr>
   <th valign="top">Fixed Equipment:</th>
   <td>
       @default_equipment_display@
     <br>
     <br>
  </td>
 </tr>
</if>


<if @room_has_eq_p@>
 <tr>
   <th valign="top">Reservable equipment(s):</th>
   <td>
     <formgroup id=room_eq_check>
       @formgroup.widget;noquote@ @formgroup.label@ <br>
     </formgroup>
     <br>
     <br>
  </td>
 </tr>
</if>

<!--
 <tr>
   <th valign="top">Other general equipment that may be reserved :</th>
   <td>
     <formgroup id=gen_eq_check>
       @formgroup.widget;noquote@ @formgroup.label@ <br>
     </formgroup>
  </td>
 </tr>
-->
<if @get_repeat_reservation:rowcount@ ne 0>
<tr><td colspan=2 align="center"><formwidget id="update_future_p"></td></tr>
</if>
<tr><td>&nbsp;</td><td><formwidget id="submit"/></td>
</tr>


</table>
</fieldset>

<if @get_repeat_reservation:rowcount@ ne 0>
<center><h3>All Related Reservations</h3></center>
<table>
<th>Title</th>
<th>Start Date</th>
<th>End Date</th>
<th>Status</th>
<multiple name="get_repeat_reservation">
<tr>
<td><a href="@edit_link@">@get_repeat_reservation.title@</a></td>
<td>@get_repeat_reservation.start_date@</td>
<td>@get_repeat_reservation.end_date@</td>
<td>@get_repeat_reservation.status@</td>
</tr>
</multiple>
</table>
</if>

</formtemplate>
</td>

<td valign="top"><include src="/packages/ctrl-resources/www/images-display" resource_id="@room_id@" action="display">
</td>

</tr>
</table>

<script type="text/javascript" src="js/layer-procs.js"></script>
<script type="text/javascript" src="js/radio-button-operations.js"></script>

<script type="text/javascript">

	setDefaultSettings();

	function setDefaultSettings () {
		if (document.forms.add_edit_event.repeat_template_p.checked) {
			showHideWidget('1','show');
			repeatType();
		} else {
			showHideWidget('1','hide');
			showHideWidget('Day','hide');
			showHideWidget('Week','hide');
			showHideWidget('Month','hide');
			showHideWidget('Year','hide');
			showHideWidget('End','hide');			
		}
	}

	function repeatType() {
		if (getSelectedRadioValue(document.forms.add_edit_event.frequency_type) == 'daily') {
			showHideWidget('Day','show');
			showHideWidget('Week','hide');
			showHideWidget('Month','hide');
			showHideWidget('Year','hide');

			showHideWidget('End','show');
		}
		else if (getSelectedRadioValue(document.forms.add_edit_event.frequency_type) == 'weekly') {
			showHideWidget('Week','show');
			showHideWidget('Day','hide');	
			showHideWidget('Month','hide');
			showHideWidget('Year','hide');	

			showHideWidget('End','show');
		}
		else if (getSelectedRadioValue(document.forms.add_edit_event.frequency_type) == 'monthly') {
			showHideWidget('Month','show');
			showHideWidget('Day','hide');
			showHideWidget('Week','hide');	
			showHideWidget('Year','hide');		
		
			showHideWidget('End','show');
		}	
		else if (getSelectedRadioValue(document.forms.add_edit_event.frequency_type) == 'yearly') {
			showHideWidget('Year','show');
			showHideWidget('Day','hide');
			showHideWidget('Week','hide');	
			showHideWidget('Month','hide');		
		
			showHideWidget('End','show');
		} 
		else {
			showHideWidget('Year','hide');
			showHideWidget('Day','hide');
			showHideWidget('Week','hide');	
			showHideWidget('Month','hide');		
		
			showHideWidget('End','hide');
		}
	}

	function repeatMonthOpt(opt) {
		if (opt == 1) {
			document.forms.add_edit_event.repeat_month_opt2.checked = false;
		}
		else if (opt  == 2) {
			document.forms.add_edit_event.repeat_month_opt1.checked = false;
		}

	}
</script>

<script type="text/javascript">
  @js_code@


  function dateShow() {

   var radioButton=document.forms.form_ae.all_day_p;
   var radioValue=getSelectedRadioValue(radioButton);

   if (radioValue == 0) {
      showHideWidget("label_0");
      showHideWidget("widget_0");
      var edit_section = document.getElementById("label_1").style.display='none';
      var edit_section = document.getElementById("widget_1").style.display='none';
   } else {
      showHideWidget("label_1");
      showHideWidget("widget_1");
      var edit_section = document.getElementById("label_0").style.display='none';
      var edit_section = document.getElementById("widget_0").style.display='none';
   }
  }

  function propogate() {
       var from_year=document.form_ae["from_date.year"].value;
       var from_day=document.form_ae["from_date.day"].value;
       var from_month=document.form_ae["from_date.month"].value;

       var to_year=document.form_ae["to_date.year"].value;
       var to_day=document.form_ae["to_date.day"].value;
       var to_month=document.form_ae["to_date.month"].value;

       if (to_year < from_year) {
	      document.form_ae["to_date.year"].value=from_year;
	}

	if ( to_month <  from_month && to_year == from_year ) {
           document.form_ae["to_date.month"].value=from_month;
	}

	if (to_month==from_month && to_day < from_day) {
      	      document.form_ae["to_date.day"].value=from_day;
	}
  }
</script>








