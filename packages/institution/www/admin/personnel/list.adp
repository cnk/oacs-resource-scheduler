<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @personnel:rowcount@ gt 0>
<table class="list-of-objects">
	<tr><th class="secondary-header">Personnel</th>
		<if @personnel_action_url_exists_p@>
			<th class="secondary-header">Action</th>
		</if>
	</tr>

	<multiple name="personnel">
		<!-- output leading space and expand/collapse widget -->
		<tr <if @personnel.rownum@ odd>class="odd"</if>>

		<!-- output personnel title/name row(@personnel.rownum@) -->
		<td><if @personnel.detail_url@ not nil>
				<a href="@personnel.detail_url@">
			</if>
			@personnel.first_names@
			@personnel.middle_name@
			@personnel.last_name@
			<if @personnel.detail_url@ not nil>
				</a>
			</if>
		</td>

		<!-- output available actions -->
		<if @personnel.action_url_exists_p@>
			<td	class="action-buttons">
			<nobr>
				<if @personnel.unassociate_url@ not nil>
					<a	href="@personnel.unassociate_url@"
						title="Unassociate"
						alt="Unassociate">
						<img src="@subsite_url@institution/images/icons/disassociate" class="action-button"></img></a>
				</if><else><img src="@subsite_url@institution/images/icons/disassociate-off" class="action-button"></else>
				<if @personnel.edit_url@ not nil>
					<a	href="@personnel.edit_url@"
						title="Edit">
						<img src="@subsite_url@institution/images/icons/edit" class="action-button"></img></a>
				</if><else><img src="@subsite_url@institution/images/icons/edit-off" class="action-button"></else>
				<if @personnel.delete_url@ not nil>
					<a	href="@personnel.delete_url@"
						title="Delete"
						alt="Delete">
						<img src="@subsite_url@institution/images/icons/delete" class="action-button"></img></a>
				</if><else><img src="@subsite_url@institution/images/icons/delete-off" class="action-button"></else>
				<if @personnel.permit_url@ not nil>
					<a	href="@personnel.permit_url@"
						title="Permit"
						alt="Permit">
						<img src="@subsite_url@institution/images/icons/permit" class="action-button"></img></a>
				</if><else><img src="@subsite_url@institution/images/icons/permit-off" class="action-button"></else>
				<if 0 and @personnel.title_edit_url@ not nil>
					<a	href="@personnel.title_edit_url@"
						title="Edit Titles"
						>
						<small>Edit Titles</small>
					</a>
				</if><else></else>
			</nobr>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
