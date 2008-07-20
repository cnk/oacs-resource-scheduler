<formtemplate id="live_filter">
<table class="layout" cellpadding="0" cellspacing="0" style="border-top: 1px solid #666666; border-bottom: 1px solid #666666; background-color: #b1b3b4; padding-top: 0em" width="100%">
	<tr valign="top">
		<td style="padding-top: 0.45em"><label for="title">Title:</label></td>
		<td style="padding-top: 0.20em"><formwidget id="title" size="16" /></td>
		<td style="padding-top: 0.45em"><label for="mm_yyyy">Date:</label></td>
		<td><formwidget id="mm_yyyy" />
			<formerror id="mm_yyyy">
				<div class="form-error" style="color: red">@formerror.mm_yyyy;noquote@</div>
			</formerror>
		</td>
		<td style="padding-top: 0.45em">
			<formgroup id="archived_p">
			<label for="archived_p">Archived:</label>&nbsp;@formgroup.widget;noquote@&nbsp;@formgroup.label;noquote@
			</formgroup>
		</td>

		<td style="padding-top: 0.45em">Calendars <small>(click to expand)</small>:
			<formgroup id="calendar_p" onClick="setCalendarSettings()">
				@formgroup.widget;noquote@ @formgroup.label;noquote@<br />
			</formgroup>
			<span id="calendar" style="display:none;">
				<formgroup id="calendar">
					@formgroup.widget;noquote@&nbsp;@formgroup.label;noquote@
					<br />
				</formgroup>
			</span>
		</td>
		<td><input type="submit" value="Search" /></td>
	</tr>
</table>
</formtemplate>

<script type="text/javascript" src="../js/layer-procs.js"></script>
<script type="text/javascript">
	function setCalendarSettings () {
	   if (document.forms.live_filter.calendar_p.checked) {
		  showHideWidget('calendar','show');
	   } else {
		  showHideWidget('calendar','hide');
	   }
	}
	setCalendarSettings();
</script>
