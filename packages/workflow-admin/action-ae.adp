<master>
<property name=title> @title@ </property>
<property name=context> @context@ </property>


<formtemplate id=add_edit>

	<table>
		<tr> <td> Short Name:</td>  	 	<td><formwidget id=short_name></td> </tr>
		<tr> <td> Pretty Name: </td>	 	<td><formwidget id=pretty_name></td></tr>
		<tr> <td> Pretty Past Tense: </td>	<td><formwidget id=pretty_past_tense></td></tr>
		<tr> <td> Description: </td>		<td><formwidget id=description></td> </tr>
		<tr> <td> Trigger type: </td>	<td><formwidget id=trigger_type></td> </tr>
		<tr> <td> Timeout Seconds only applicable for timer trigger type: </td>	<td><formwidget id=timeout_seconds></td> </tr>
		<tr> <td> New State: </td>		<td><formwidget id=new_state_id></td> </tr>

		<tr> 	<td> Insert or remove callbacks. Put a new callback on a seperate line: </td>		
			<td><formwidget id=callbacks></td> </tr>
		<tr> <td> Always Enabled?</td>	
			<td>
				<table>
					<tr><td>
						<formgroup id=always_enabled_p onClick=showSelected(document.add_edit.always_enabled_p);>
							@formgroup.widget;noquote@ @formgroup.label@ <br>
						</formgroup>
					</td></tr>
				</table>
			</td>
		</tr>
			

		<tr>    

			<td>   <span id=1 style=display:none;> Enabled States </span>  </td>
			<td>
				<span id=2 style=display:none;>
				<table>
					<tr><td>
						<formgroup id=enabled_states>
							@formgroup.widget;noquote@ @formgroup.label@ <br>
						</formgroup>
					</td></tr>
				</table>
				</span>
			</td>
		</tr>

		<tr> <td> <span id=3 style=display:none;> Assigned States </span>  </td>
			<td>
				<span id=4 style=display:none;>
					<table>
						<tr><td>
							<formgroup id=assigned_states>
								@formgroup.widget;noquote@ @formgroup.label@ <br>
							</formgroup>
						</td></tr>
					</table>
				</span>
			</td>
		</tr>
	</table>
	<center> <formwidget id=sub></center>
</formtemplate>


<script language="javascript" src="layer-procs.js"></script>
<script language="javascript">

showSelected(document.add_edit.always_enabled_p);

function showSelected(buttonGroup) {
	var edit_section = document.getElementById(1).style.display='none';
	var edit_section = document.getElementById(2).style.display='none';
	var edit_section = document.getElementById(3).style.display='none';
	var edit_section = document.getElementById(4).style.display='none';

	buttonValue = getSelectedRadioValue(buttonGroup);
	if (buttonValue == 'f') {
		showHideWidget(1);
		showHideWidget(2);
		showHideWidget(3);
		showHideWidget(4);
	}
}

function getSelectedRadio(buttonGroup) {
   // returns the array number of the selected radio button or -1 if no button is selected
   if (buttonGroup[0]) { // if the button group is an array (one button is not an array)
      for (var i=0; i<buttonGroup.length; i++) {
         if (buttonGroup[i].checked) {
            return i
         }
      }
   } else {
      if (buttonGroup.checked) { return 0; } // if the one button is checked, return zero
   }
   // if we get to this point, no radio button is selected
   return -1;
} // Ends the "getSelectedRadio" function


function getSelectedRadioValue(buttonGroup) {
   // returns the value of the selected radio button or "" if no button is selected
   var i = getSelectedRadio(buttonGroup);

   if (i == -1) {
      return "";
   } else {
      if (buttonGroup[i]) { // Make sure the button group is an array (not just one button)
         return buttonGroup[i].value;
      } else { // The button group is just the one button, and it is checked
         return buttonGroup.value;
      }
   }
} // Ends the "getSelectedRadioValue" function


</script>
