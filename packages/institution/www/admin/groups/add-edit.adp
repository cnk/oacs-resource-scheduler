<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<formtemplate id="add_edit"></formtemplate>

<if @action@ eq "Edit">
	<if @can_delete_or_permit_p@>
		<ul>
		<if @group_delete_url@ not nil>
			<li><a href="@group_delete_url@">Delete This Group</a></li>
		</if>
		<if @group_permit_url@ not nil>
			<li><a href="@group_permit_url@">Change the Permissions on This Group</a></li>
		</if>
		</ul>
	</if>
</if>