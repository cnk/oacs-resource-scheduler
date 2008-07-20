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
	<tr><th class="secondary-header" align="left">Description:</th>	<td class="data">@description@</td></tr>
	<tr><th class="secondary-header" align="left">Type:</th>			<td class="data">@email_type_name@</td></tr>
	<tr><th class="secondary-header" align="left">Email Address:</th>	<td class="data">@email@</td></tr>

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

<if @can_change_this_email_p@>
	<ul><if @email_edit_url@ not nil>
			<li><a href="@email_edit_url@">Edit This Email Address</a></li>
		</if>
		<if @email_delete_url@ not nil>
			<li><a href="@email_delete_url@">Delete This Email Address</a></li>
		</if>
		<if @email_permit_url@ not nil>
			<li><a href="@email_permit_url@">Change the Permissions on This Email Address</a></li>
		</if>
	</ul>
</if>
