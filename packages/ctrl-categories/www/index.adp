<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@name@</property>
<property name="context">Category</property>

<table class="layout">
	<if @category_id@ not nil>
		<!-- instance attributes -->
		<if @parent_category_name@ not nil>
			<tr><th class="label" align="right">Parent Category:</th>	<td class="data"><a href="@parent_category_url@">@parent_category_name@</a></td></tr>
		</if>
		<tr><th class="label" align="left">Name:</th>				<td class="data">@name@</td></tr>
		<tr><th class="label" align="left">Plural:</th>				<td class="data">@plural@</td></tr>
		<tr><th class="label" align="left">Description:</th>		<td class="data">@description@</td></tr>
		<tr><th class="label" align="left">Enabled?:</th>			<td class="data">@enabled_p@</td></tr>
		<tr><th class="label" align="left">Profiling Weight:</th>	<td class="data">@profiling_weight@</td></tr>
	</if>
	<tr><th align="left" valign="top">
			<if @category_id@ not nil>
				Subcategories:
			</if>
		</th>
		<td>
			<!-- an expandable tree of (sub)categories -->
			<if @n_children@ gt 0>
				<include src="tree"
						&="root_category_id"
						&="roots"
						&="show"
						&="hide">
			</if><else>
				<i>None</i><br>
			</else>
		</td>
	</tr>
</table>

<if @can_change_this_category_p@>
	<ul class="action-links">
		<if @subcategory_create_url@ not nil>
			<li><a href="@subcategory_create_url@">
				<if @actual_object_type@ ne "Category">
					Add a Top Level Category
				</if><else>
					Add a Sub-category
				</else>
				</a>
			</li>
		</if>
		<if @category_edit_url@ not nil>
			<li><a href="@category_edit_url@">Edit This Category</a></li>
		</if>
		<if @category_delete_url@ not nil>
			<li><a href="@category_delete_url@">Delete This Category</a></li>
		</if>
		<if @category_permit_url@ not nil>
			<li><a href="@category_permit_url@">Change the Permissions on This @actual_object_type;noquote@</a></li>
		</if>
	</ul>
</if>