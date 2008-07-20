<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@action@ <q>@category_name@</q></property>
<property name="context">@action@</property>

<formtemplate id="add_edit"></formtemplate>

<table class="layout">
	<tr><th align="left" valign="top">
			Subcategories:
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

<if @action@ eq "Edit">
	<if @can_delete_or_permit_p@>
		<ul class="action-links">
			<if @category_delete_url@ not nil>
				<li><a href="@category_delete_url@">Delete This Category</a></li>
			</if>
			<if @category_permit_url@ not nil>
				<li><a href="@category_permit_url@">Change the Permissions on This Category</a></li>
			</if>
		</ul>
	</if>
</if>