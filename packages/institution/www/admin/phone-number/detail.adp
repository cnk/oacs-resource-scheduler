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
	<tr><th class="secondary-header" align="left">Description:</th>		<td class="data">@description@</td></tr>
	<tr><th class="secondary-header" align="left">Type:</th>			<td class="data">@phone_type_name@</td></tr>
	<tr><th class="secondary-header" align="left">Phone Number:</th>	<td class="data">@phone_number@</td></tr>
	<tr><th class="secondary-header" align="left">Priority:</th>		<td class="data">@phone_priority_number@</td></tr>

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

<if @can_change_this_phone_p@>
	<ul>
	<if @phone_edit_url@ not nil>
		<li><a href="@phone_edit_url@">Edit This Phone Number</a></li>
	</if>
	<if @phone_delete_url@ not nil>
		<li><a href="@phone_delete_url@">Delete This Phone Number</a></li>
	</if>
	<if @phone_permit_url@ not nil>
		<li><a href="@phone_permit_url@">Change the Permissions on This Phone Number</a></li>
	</if>
</if>
