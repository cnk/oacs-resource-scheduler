<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @party_images:rowcount@ gt 0>
<table width="100%">
	<tr><th align="left" valign="top" class="secondary-header">Image<if @party_images:rowcount@ gt 1>s</if></th>
		<th class="secondary-header">Size</th>
		<if @party_image_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="party_images">
		<!-- output leading space and expand/collapse widget -->
		<if @party_images.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output party_image title/name row(@party_images.rownum@) -->
		<if @party_images.detail_url@ not nil>
			<td><a	href="@party_images.detail_url@"
					title="Click to see detailed information about this image"
					>@party_images.description@</a></td></if>
		<else>
			<td>@party_images.description@</td>
		</else>

		<td><small>@party_images.bytes@</small></td>

		<!-- output available actions -->
		<if @party_images.action_url_exists_p@>
			<td><small>
				[
				<if @party_images.edit_url@ not nil>
					<a	href="@party_images.edit_url@"
						title="Click to edit the details of this image">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @party_images.delete_url@ not nil>
					<a	href="@party_images.delete_url@"
						title="Click to delete this image">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				<if @party_images.permit_url@ not nil>
				|
					<a href="@party_images.permit_url@"
						title="Click to change access privileges for this image"
						>Permit</a>
				</if>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
