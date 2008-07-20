<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @phones:rowcount@ gt 0>
<table class="layout" width="100%">
	<tr><td align="left" valign="top"><span class="secondary-header">Phone Number<if @phones:rowcount@ gt 1>s</if></span> (click # below to view)</td>
		<th class="secondary-header">Description</th>
		<if @phone_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="phones">
		<!-- output leading space and expand/collapse widget -->
		<if @phones.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output phone-number title/name row(@phones.rownum@) -->
		<if @phones.detail_url@ not nil>
			<td><a href="@phones.detail_url@">@phones.phone_number@</a></td>
			<td><a href="@phones.detail_url@">@phones.description@</a></td></if>
		<else>
			<td>@phones.phone_number@</td>
			<td>@phones.description@</td>
		</else>

		<!-- output available actions -->
		<if @phones.action_url_exists_p@>
			<td><small>
				[
				<if @phones.edit_url@ not nil>
					<a href="@phones.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @phones.delete_url@ not nil>
					<a href="@phones.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				<if @phones.permit_url@ not nil>
				|
					<a href="@phones.permit_url@">Permit</a>
				</if>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
