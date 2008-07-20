<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

<br>
This title names @owner_name@ as @description@ in the @group_type@ named
<if @group_url@ not nil><a href="@group_url@">@group_name@</a></if>
<else>@group_name@</else>.
<br><br>

<table class="layout">
	<!-- instance attributes -->
	<tr><th class="secondary-header" align="left">Title:</th>			<td class="data">@title@</td></tr>
	<tr><th class="secondary-header" align="left">Group:</th>			<td class="data">@group_name@</td></tr>
	<tr><th class="secondary-header" align="left">Display as...</th>	<td class="data">@pretty_title@</td></tr>
	<tr><th class="secondary-header" align="left">Status:</th>			<td class="data">@status@</td></tr>
	<tr><th class="secondary-header" align="left">Leader?:</th>			<td class="data">@leader_p@</td></tr>
	<tr><th class="secondary-header" align="left">Start Date:</th>		<td class="data">@start_date@</td></tr>
	<tr><th class="secondary-header" align="left">End Date:</th>		<td class="data">@end_date@</td></tr>
	<tr><th class="secondary-header" align="left">Display Order:</th>	<td class="data">@title_priority_number@</td></tr>

	<if @admin_p@>
		<tr><td class="layout" style="height: 0.75em"></td></tr>
		<tr><th class="secondary-header" align="left">Created on:</th>		<td>@created_on@ <i>at</i> @created_at@</td></tr>
		<if @created_by@ not nil>
			<tr><th class="secondary-header" align="left">Created by:</th>	<td>@created_by@</td></tr>
		</if>
		<tr><th class="secondary-header" align="left">Updated on:</th>		<td>@modified_on@ <i>at</i> @modified_at@</td></tr>
		<if @modified_by@ not nil>
			<tr><th class="secondary-header" align="left">Updated by:</th>	<td>@modified_by@</td></tr>
		</if>
	</if>
</table>

<if @can_change_this_title_p@>
	<ul>
		<if @title_edit_url@ not nil>
			<li><a href="@title_edit_url@">Edit This Title</a></li>
		</if>
		<if @title_delete_url@ not nil>
			<li><a href="@title_delete_url@">Delete This Title</a></li>
		</if>
		<if @title_permit_url@ not nil>
			<li><a href="@title_permit_url@">Change the Permissions on This Title</a></li>
		</if>
	</ul>
</if>
