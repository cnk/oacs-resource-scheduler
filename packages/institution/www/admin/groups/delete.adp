<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>
<span class="primary-header">Institution Admin: Please confirm that you want to delete the group "@group_name@".</span>
<br><br>
<span class="secondary-header">Please note the deletion of this group will also delete any associations the group may have.</span>
<br><br>
<formtemplate id="delete"></formtemplate>

<include src="tree"
		&="allow_action_p"
		&="tree_title"
		&="root_group_id"
		&="roots"
		&="show"
		&="hide">

<if @can_change_this_group_p@>
	<ul>
	<if @group_edit_url@ not nil>
		<li><a href="@group_edit_url@">Edit This Group</a></li>
	</if>
	<if @group_permit_url@ not nil>
		<li><a href="@group_permit_url@">Change the Permissions on This Group</a></li>
	</if>
	</ul>
</if>
