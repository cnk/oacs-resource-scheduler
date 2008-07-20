/*****
 * CTRL Event Repetition Proc Helpers
 *
 *
 **/

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
