<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @group_tree_view:rowcount@ gt 0>
<table class="layout">
	<if @title@ not nil>
		<tr><th  align="left" valign="top" class="secondary-header" colspan="100%">@title@</th></tr>
		<tr>@emptyrow@<td></td></tr>
	</if><else>
		<tr>@emptyrow@
			<th align="left" valign="top" class="secondary-header">Group</th>
			<if @group_action_url_exists_p@><th class="secondary-header">Action</th></if>
		</tr>
	</else>

	<multiple name="group_tree_view">
		<!-- output leading space and expand/collapse widget -->
		<if @group_tree_view.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<if @group_tree_view.level@ gt 0>
		<td align="right" colspan="@group_tree_view.level@">
			<if @group_tree_view.expand_url@ not nil>
				<a href="@group_tree_view.expand_url@" style="font-family:monospace;">[@group_tree_view.expand_txt@]</a>
			</if>
			<else>
				<if @maxdepth@ nil>
					<b style="font-family:monospace;">[&nbsp;]</b>
				</if>
			</else>
		</td>
		</if>

		<!-- output group title/name row(@group_tree_view.rownum@) -->
		<td colspan="@group_tree_view.detail_colspan@" title="@group_tree_view.group_type@">
			<if @group_tree_view.detail_url@ not nil>
				<a href="@group_tree_view.detail_url@">
			</if>
			@group_tree_view.short_name@
			<if @group_tree_view.detail_url@ not nil>
				</a>
			</if>
		</td>

		<!-- output available actions -->
		<if @group_tree_view.action_url_exists_p@>
			<td><small>[
				<if @group_tree_view.create_subgroup_url@ not nil>
					<a href="@group_tree_view.create_subgroup_url@">Add</a>
				</if><else>											Add</else>		|
				<if @group_tree_view.edit_url@ not nil>
					<a href="@group_tree_view.edit_url@">			Edit</a>
				</if><else>											Edit</else>		|
				<if @group_tree_view.delete_url@ not nil>
					<a href="@group_tree_view.delete_url@">			Delete</a>
				</if><else>											Delete</else>	|
				<if @group_tree_view.titles_report_url@ not nil>
					<a href="@group_tree_view.titles_report_url@">	Titles</a>
				</if><else>											Titles</else>	|
				<if @group_tree_view.permit_url@ not nil>
					<a href="@group_tree_view.permit_url@">			Permit</a>
				</if><else>											Permit</else>
				]</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else>
	<i>None</i>
</else>
