<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @emails:rowcount@ gt 0>
<table class="layout" width="100%">
	<tr><td align="left" valign="top"><span class="secondary-header">Email Address<if @emails:rowcount@ gt 1>es</if></span> (click email below to view)</td>
		<th class="secondary-header">Description</th>
		<if @email_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="emails">
		<!-- output leading space and expand/collapse widget -->
		<if @emails.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output email title/name row(@emails.rownum@) -->
		<if @emails.detail_url@ not nil>
			<td><a href="@emails.detail_url@">@emails.email@</a></td>
			<td><a href="@emails.detail_url@">@emails.description@</a></td></if>
		<else>
			<td>@emails.email@</td>
			<td>@emails.description@</td>
		</else>

		<!-- output available actions -->
		<if @emails.action_url_exists_p@>
			<td><small>
				[
				<if @emails.edit_url@ not nil>
					<a href="@emails.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @emails.delete_url@ not nil>
					<a href="@emails.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				<if @emails.permit_url@ not nil>
				|
					<a href="@emails.permit_url@">Permit</a>
				</if>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
