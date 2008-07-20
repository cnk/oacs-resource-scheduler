<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffffcc">
				<span class="primary-header">@title@</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research-info">Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

<table class="layout">
	<!-- instance attributes -->
	<tr><th class="secondary-header" align="left">Type:</th>						<td class="data">@certification_type_name@</td></tr>
	<tr><th class="secondary-header" align="left">Certifying Party:</th>			<td class="data">@certifying_party@</td></tr>
	<tr><th class="secondary-header" align="left">Certification Credential:</th>	<td class="data">@certification_credential@</td></tr>
	<tr><th class="secondary-header" align="left">Effective Date:</th>				<td class="data">@start_date@</td></tr>
	<tr><th class="secondary-header" align="left">Certification Date:</th>			<td class="data">@certification_date@</td></tr>
	<tr><th class="secondary-header" align="left">Expiration Date:</th>			<td class="data">@expiration_date@</td></tr>

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

<if @can_change_this_certification_p@>
	<ul><if @certification_edit_url@ not nil>
			<li><a href="@certification_edit_url@">Edit This Certification</a></li>
		</if>
		<if @certification_delete_url@ not nil>
			<li><a href="@certification_delete_url@">Delete This Certification</a></li>
		</if>
		<if @certification_permit_url@ not nil>
			<li><a href="@certification_permit_url@">Change the Permissions on This Certification</a></li>
		</if>
	</ul>
</if>
