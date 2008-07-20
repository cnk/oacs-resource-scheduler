<master>
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>
<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px"> 

<formtemplate id="search_personnel">
	<table width="100%" border="0">
		<tr><th colspan="100%" align="center">
			<span class="bluebold">
				Select Personnel that match <formwidget id="combine_method"/>of
					the criteria below.</span><br><br></th>
		</tr>

		<tr><th colspan="100%" align="center">@letter_index@<br><br></th></tr>
	</table>

	<table width="100%" border="0" cellpadding="2" cellspacing="2">

		<tr><th class="secondary-header" align="right"><nobr>First Name:</nobr></th>
			<td class="data-io"><formwidget id="first_name"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Last Name:</nobr></th>
			<td class="data-io"><formwidget id="last_names"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>UCLA Employee ID:</nobr></th>
			<td class="data-io"><formwidget id="employee_id"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Deptartment:</nobr></th>
			<td class="data-io"><formwidget id="dept"/></td>
		</tr>


		<tr><th class="secondary-header"></th><td align="left">
			<br><formwidget id="search"/><br><br></td>
		</tr>		
		
	</table>
</formtemplate>
</div>
