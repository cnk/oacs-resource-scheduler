<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

<table class="layout">
	<tr><td colspan="100%">
			@authors@.
			@title@.
			<if @url@ nil>@publication_name@.</if>
			<else><a href="@url@">@publication_name@</a>.</else>
			@year@;
			@issue@(@volume@):
			@page_ranges@
		</td>
	</tr>
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

<if @can_change_this_publication_p@>
	<ul><if @publication_edit_url@ not nil>
			<li><a href="@publication_edit_url@">Edit This Publication</a></li>
		</if>
		<if @publication_delete_url@ not nil>
			<li><a href="@publication_delete_url@">Delete This Publication</a></li>
		</if>
		<if @publication_permit_url@ not nil>
			<li><a href="@publication_permit_url@">Change the Permissions on This Publication</a></li>
		</if>
		<if @publication_map_url@ not nil>
			<li><a href="@publication_map_url@">Map this Publication to a Personnel</a></li>
		</if>
		<if @publication_contents_url@ not nil>
			<li><a href="@publication_contents_url@">Download this Publication</a></li>
		</if>
	</ul>
</if>
