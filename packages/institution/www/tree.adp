<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @group_tree_view:rowcount@ gt 0>
<table class="layout">
	<if @title@ not nil>
		<tr><th  align="left" valign="top" class="secondary-header" colspan="100%">@title@</th></tr>
		<tr class="layout">@emptyrow@<td></td></tr>
	</if><else>
		<tr>@emptyrow@<th align="left" valign="top" class="secondary-header">Group</th></tr>
	</else>

	<multiple name="group_tree_view">
		<!-- output leading space and expand/collapse widget -->
		<if @group_tree_view.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<if @group_tree_view.level@ gt 0>
		<td align="right" colspan="@group_tree_view.level@" class="main-text" valign="top">
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
		<td colspan="@group_tree_view.detail_colspan@" class="main-text" valign="top">
			<if @group_tree_view.detail_url@ not nil>
				<a href="@group_tree_view.detail_url@">
			</if>
			@group_tree_view.short_name@
			<if @group_tree_view.detail_url@ not nil>
				</a>
			</if>
		</td>
		</tr>
	</multiple>
</table>
</if><else>
	<if @title@ not nil>
		<i>None</i>
	</if>
</else>
