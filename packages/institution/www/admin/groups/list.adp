<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @groups:rowcount@ gt 0>
<table class="layout">
	<tr><th align="left" valign="top" class="secondary-header">Group<if @groups:rowcount@ gt 1>es</if></th>
		<th class="secondary-header">Description</th>
		<if @group_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="groups">
		<!-- output leading space and expand/collapse widget -->
		<if @groups.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output group title/name row(@groups.rownum@) -->
		<if @groups.detail_url@ not nil>
			<td><a href="@groups.detail_url@">@groups.group@</a></td>
			<td><a href="@groups.detail_url@">@groups.description@</a></td></if>
		<else>
			<td>@groups.group@</td>
			<td>@groups.description@</td>
		</else>

		<!-- output available actions -->
		<if @groups.action_url_exists_p@>
			<td><small>
				[
				<if @groups.edit_url@ not nil>
					<a href="@groups.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @groups.delete_url@ not nil>
					<a href="@groups.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				|
				<if @groups.titles_report_url@ not nil>
					<a href="@groups.titles_report_url@">Titles</a>
				</if><else><b style="text-color: grey"><i>Titles</i></b></else>
				|
				<if @groups.permit_url@ not nil>
					<a href="@groups.permit_url@">Permit</a>
				</if><else><b style="text-color: grey"><i>Permit</i></b></else>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
