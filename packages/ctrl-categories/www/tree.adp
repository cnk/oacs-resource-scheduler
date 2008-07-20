<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @category_tree_view:rowcount@ gt 0>
<table class="layout">
	<tr>
		@emptyrow;noquote@
		<th width="150px">@tree_title@</th>
		<th>Profiling<br>Weight</th>
		<if @category_action_url_exists_p@><th>Action</th></if>
	</tr>

	<multiple name="category_tree_view">
		<!-- output leading space and expand/collapse widget -->
		<if @category_tree_view.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<td align="right" colspan="@category_tree_view.level@">
			<if @category_tree_view.expand_url@ not nil>
				<a href="@category_tree_view.expand_url@" style="font-family:monospace">[@category_tree_view.expand_txt@]</a></if>
			<else><b style="font-family:monospace">[@category_tree_view.expand_txt;noquote@]</b></else></td>

		<!-- output category title/name row(@category_tree_view.rownum@) -->
		<td colspan="@category_tree_view.detail_colspan@">
			<if @category_tree_view.detail_url@ not nil>
				<a href="@category_tree_view.detail_url@">
			</if>
			@category_tree_view.name@
			<if @category_tree_view.detail_url@ not nil>
				</a>
			</if>
		</td>
		<td align="right" style="padding-right: 10px">
			@category_tree_view.profiling_weight@</td>

		<!-- output available actions -->
		<if @category_tree_view.action_url_exists_p@>
			<td><small>
				[
				<if @category_tree_view.create_subcategory_url@ not nil>
					<a href="@category_tree_view.create_subcategory_url@">Add</a>
				</if><else><b style="text-color: grey"><i>Add</i></b></else>
				|
				<if @category_tree_view.edit_url@ not nil>
					<a href="@category_tree_view.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @category_tree_view.delete_url@ not nil>
					<a href="@category_tree_view.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				|
				<if @category_tree_view.permit_url@ not nil>
					<a href="@category_tree_view.permit_url@">Permit</a>
				</if><else><b style="text-color: grey"><i>Permit</i></b></else>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if>
