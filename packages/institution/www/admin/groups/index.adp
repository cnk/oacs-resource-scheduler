<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<!-- an expandable tree of (sub)groups -->
<include src="tree"
		&="subsite_id"
		&roots="subsite_trunks"
		&="show"
		&="hide">

<if @can_change_this_group_p@>
	<ul><if @subgroup_create_url@ not nil>
			<li><a href="@subgroup_create_url@">
				<if @actual_object_type@ ne "Group">
					Add a Top Level Group
				</if><else>
					Add a Sub-group
				</else>
				</a>
			</li>
		</if>
		<if @group_edit_url@ not nil>
			<li><a href="@group_edit_url@">Edit This Group</a></li>
		</if>
		<if @group_permit_url@ not nil>
			<li><a href="@group_permit_url@">Change the Permissions on This @actual_object_type@</a></li>
		</if>
		<if @group_delete_url@ not nil>
			<li><a href="@group_delete_url@">Delete This Group</a></li>
		</if>
	</ul>
</if>