<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @titles:rowcount@ gt 0>
<table class="layout">
	<tr><th align="left" valign="top" class="secondary-header" colspan="2">
			Title<if @titles:rowcount@ gt 1>s</if>
		</th>
		<if @title_action_url_exists_p@>
			<th class="secondary-header">
				Action
			</th>
		</if>
	</tr>

	<multiple name="titles">
		<!-- output leading space and expand/collapse widget -->
		<if @titles.rownum@ odd>
			<tr bgcolor="#CBDBEC">
		</if><else><tr bgcolor="#FFFFFF"></else>

			<td colspan="2"><a href="@titles.group_url@">@titles.group_name@</a></td>
			<if @titles.action_url_exists_p@>
				<td><small>
					[
					<if @titles.create_url@ not nil>
						<a href="@titles.create_url@">Add</a>
					</if><else><b style="text-color: grey"><i>Add</i></b></else>
					|
					<if @titles.permit_url@ not nil>
						<a href="@titles.permit_url@">Permit</a>
					</if><else><b style="text-color: grey"><i>Permit</i></b></else>
					]
					</small>
				</td>
			</if>

		</tr>

		<group column="group_id">
			<tr><td>&nbsp;&nbsp;</td>
			<!-- output title title/name row(@titles.rownum@) -->
			<td><if @titles.detail_url@ not nil>
					<a href="@titles.detail_url@">
				</if>

				<if @titles.pretty_title@ not nil>
					@titles.pretty_title@ (
				</if>

				@titles.title@
				<if @titles.status@ not nil> &mdash; @titles.status@</if>

				<if @titles.pretty_title@ not nil>
					)
				</if>

				<if @titles.detail_url@ not nil>
					</a>
				</if>
			</td>

			<!-- output available actions -->
			<if @titles.action_url_exists_p@>
				<td><small>
					[
					<if @titles.edit_url@ not nil>
						<a href="@titles.edit_url@">Edit</a>
					</if><else><b style="text-color: grey"><i>Edit</i></b></else>
					|
					<if @titles.delete_url@ not nil>
						<a href="@titles.delete_url@">Delete</a>
					</if><else><b style="text-color: grey"><i>Delete</i></b></else>
					]
					</small>
				</td>
			</if>
			</tr>
		</group>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
