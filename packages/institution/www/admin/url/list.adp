<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @urls:rowcount@ gt 0>
<table class="layout"  width="100%">
	<tr><td align="left" valign="top"><span class="secondary-header">URL<if @urls:rowcount@ gt 1>s</if></span> (click url below to view)</td>
		<th class="secondary-header">Description</th>
		<if @url_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="urls">
		<!-- output leading space and expand/collapse widget -->
		<if @urls.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output url title/name row(@urls.rownum@) -->
		<if @urls.detail_url@ not nil>
			<td><a href="@urls.detail_url@">@urls.url@</a></td>
			<td><a href="@urls.detail_url@">@urls.description@</a></td></if>
		<else>
			<td>@urls.url@</td>
			<td>@urls.description@</td>
		</else>

		<!-- output available actions -->
		<if @urls.action_url_exists_p@>
			<td><small>
				[
				<if @urls.edit_url@ not nil>
					<a href="@urls.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @urls.delete_url@ not nil>
					<a href="@urls.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				<if @urls.permit_url@ not nil>
				|
					<a href="@urls.permit_url@">Permit</a>
				</if>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
