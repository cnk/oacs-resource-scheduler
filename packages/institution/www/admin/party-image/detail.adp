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
	<tr><th class="secondary-header" align="left">Image:</th>		<td class="data"><img src="@image_view_url@"/></td></tr>
	<tr><th class="secondary-header" align="left">Description:</th><td class="data">@description@</td></tr>
	<tr><th class="secondary-header" align="left">Type:</th>		<td class="data">@image_type_name@</td></tr>

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

<if @can_change_this_party_image_p@>
	<ul>
	<if @party_image_edit_url@ not nil>
		<li><a href="@party_image_edit_url@">Edit This Party Image</a></li>
	</if>
	<if @party_image_delete_url@ not nil>
		<li><a href="@party_image_delete_url@">Delete This Party Image</a></li>
	</if>
	<if @party_image_permit_url@ not nil>
		<li><a href="@party_image_permit_url@">Change the Permissions on This Party Image</a></li>
	</if>
</if>
