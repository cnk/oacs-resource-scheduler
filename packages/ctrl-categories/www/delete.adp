<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@action@ <q>@name@</q></property>
<property name="context">@action@</property>

<formtemplate id="delete"></formtemplate>

<include src="tree"
		&="allow_action_p"
		&="tree_title"
		&="root_category_id"
		&="roots"
		&="show"
		&="hide">

<if @can_change_this_category_p@>
	<ul class="action-links">
		<if @category_edit_url@ not nil>
			<li><a href="@category_edit_url@">Edit This Category</a></li>
		</if>
		<if @category_permit_url@ not nil>
			<li><a href="@category_permit_url@">Change the Permissions on This Category</a></li>
		</if>
	</ul>
</if>
