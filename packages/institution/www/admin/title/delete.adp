<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<br>
This title names @owner_name@ as @description@ in the @group_type@ named
<a href="@group_url@">@group_name@</a>.
<br><br>

<formtemplate id="delete"></formtemplate>

<if @can_change_this_title_p@>
	<ul>
		<if @title_edit_url@ not nil>
			<li><a href="@title_edit_url@">Edit This Title</a></li>
		</if>
		<if @title_permit_url@ not nil>
			<li><a href="@title_permit_url@">Change the Permissions on This Title</a></li>
		</if>
	</ul>
</if>
