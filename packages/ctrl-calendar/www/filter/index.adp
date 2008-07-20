<master>

<include src="../view-option-panel" &="cal_id" &="julian_date" view_option="advanced" />
<br /><br />

<table>
	<tr><td><h3>Actions:</h3>
			<ul><li><a href="@filter_url;noquote@">Add a filter</a></li></ul>
			<br />
		</td>
	</tr>
	<tr><td><table>
				<tr><th id="header">Name</th>
					<th id="header">Description</th>
					<th id="header">Actions</th>
				</tr>
				<if @get_cal_filters:rowcount@ eq 0>
					<tr><td id="datadisplay" colspan="100"><i>No Filters</i></td></tr>
				</if>

				<multiple name="get_cal_filters">
				<tr><td id="datadisplay">@get_cal_filters.filter_name;noquote@</td>
					<td id="datadisplay">@get_cal_filters.description;noquote@</td>
					<td id="datadisplay">@get_cal_filters.view_link;noquote@
						| @get_cal_filters.edit_link;noquote@
						| @get_cal_filters.delete_link;noquote@
					</td>
				</tr>
				</multiple>
			</table>
		</td>
	</tr>
	<tr><td><h3>Actions:</h3>
			<ul><li><a href="@filter_url;noquote@">Add a filter</a></li></ul>
			<br />
		</td>
	</tr>
</table>
