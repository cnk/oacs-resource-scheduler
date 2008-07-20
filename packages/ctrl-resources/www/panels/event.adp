<formtemplate id="add_edit_event">
<table>
    <tr>
	<th align=right>Title:</th>
	<td><formwidget id="title"/><font color="red"><formerror id="title"></formerror></font></td>
    </tr>

    <tr><th align=right>Resource Type <font color=red>*<formerror id="resource_type"></formerror></font></th>
        <td align=left>
                <formwidget id="resource_type" onChange="javascript:libraryChange(document.forms.add_edit_event.resource_type,document.forms.add_edit_event.resource);">
       </td>
    </tr>

    <tr><th align=right>Resource <font color=red>* <formerror id="resource"></formerror></font></th>
        <td align=left>
	  <formwidget id="resource">
       </td>
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
	<th align=right>Location:</td>
	<td><formwidget id="location"/><font color="red"><formerror id="location"></formerror></font>
	</td>
</tr>

<tr>
	<th align=right>Notes:</td>
	<td><formwidget id="notes"/><font color="red"><formerror id="notes"></formerror></font></td>
</tr>

<tr>
	<th align=right>Capacity:</td>
	<td><formwidget id="capacity"/><font color="red"><formerror id="capacity"></formerror></font></td>
</tr>

<tr>
	<th align=right>Repeating Event:</td>
	<td>
		<formgroup id="repeat_template_p" onClick="setDefaultSettings()">
			@formgroup.widget;noquote@ @formgroup.label;noquote@
		</formgroup>
	</td>
</tr>

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
<tr><td colspan=2 align="center"><formwidget id="submit"/></td>
</tr>


</table>
</formtemplate>

<script type="text/javascript" src="js/layer-procs.js"></script>
<script type="text/javascript" src="js/radio-button-operations.js"></script>
<script type="text/javascript" src="js/select-transfer-options.js"> </script>

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
