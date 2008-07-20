<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ccffcc">
				<span class="primary-header">@title@</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@">Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

<table class="layout">
	<!-- instance attributes -->
	<tr><th class="secondary-header" align="left">Description:</th><td class="data">@description@</td></tr>
	<tr><th class="secondary-header" align="left">Type:</th><td class="data">@address_type_name@</td></tr>
	<tr><th class="secondary-header" align="left">Building Name:</th>	<td>@building_name@</td></tr>
	<tr><th class="secondary-header" align="left">Room Number:</th>	<td>@room_number@</td></tr>
	<tr><th class="secondary-header" align="left">Address Line 1:</th>	<td>@address_line_1@</td></tr>
	<tr><th class="secondary-header" align="left">Address Line 2:</th>	<td>@address_line_2@</td></tr>
	<tr><th class="secondary-header" align="left">Address Line 3:</th>	<td>@address_line_3@</td></tr>
	<tr><th class="secondary-header" align="left">Address Line 4:</th>	<td>@address_line_4@</td></tr>
	<tr><th class="secondary-header" align="left">Address Line 5:</th>	<td>@address_line_5@</td></tr>
	<tr><th class="secondary-header" align="left">City:</th>			<td>@city@</td></tr>
	<tr><th class="secondary-header" align="left">State:</th>			<td>@state_name@</td></tr>
	<tr><th class="secondary-header" align="left">Zipcode:</th>		<td>@zipcode@</td></tr>
	<tr><th class="secondary-header" align="left">Zipcode Ext:</th>	<td>@zipcode_ext@</td></tr>
	<tr><th class="secondary-header" align="left">Country:</th>		<td>@country_name@</td></tr>

	<if @admin_p@>
		<tr><td class="layout" style="height: 0.75em"></td></tr>
		<tr><th class="secondary-header" align="left">Created on:</th>		<td>@created_on@ <i>at</i> @created_at@</td></tr>
		<if @created_by@ not nil>
			<tr><th class="secondary-header" align="left">Created by:</th>	<td>@created_by@</td></tr>
		</if>
		<tr><th class="secondary-header" align="left">Updated on:</th>		<td>@modified_on@ <i>at</i> @modified_at@</td></tr>
		<if @modified_by@ not nil>
			<tr><th class="secondary-header" align="left">Updated by:</th>	<td>@modified_by@</td></tr>
		</if>
	</if>
</table>

<if @can_change_this_address_p@>
	<ul>
		<if @address_edit_url@ not nil>
			<li><a href="@address_edit_url@">Edit This Address</a></li>
		</if>
		<if @address_delete_url@ not nil>
			<li><a href="@address_delete_url@">Delete This Address</a></li>
		</if>
		<if @address_permit_url@ not nil>
			<li><a href="@address_permit_url@">Change the Permissions on This Address</a></li>
		</if>
	</ul>
</if>
