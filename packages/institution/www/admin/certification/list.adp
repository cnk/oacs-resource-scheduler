<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @certifications:rowcount@ gt 0>
<table width="100%">
	<tr><th align="left" valign="top" class="secondary-header">Degree<if @certifications:rowcount@ gt 1>s</if>/Certification<if @certifications:rowcount@ gt 1>s</if></th>
		<th class="secondary-header">Type</th>
		<if @certification_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="certifications">
		<!-- output leading space and expand/collapse widget -->
		<if @certifications.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output certification title/name row(@certifications.rownum@) -->
		<if @certifications.detail_url@ not nil>
			<td><a href="@certifications.detail_url@">@certifications.certification_credential@</a></td>
			<td><a href="@certifications.detail_url@">@certifications.certification_type_name@</a></td></if>
		<else>
			<td>@certifications.certification_credential@</td>
			<td>@certifications.certification_type_name@</td>
		</else>

		<!-- output available actions -->
		<if @certifications.action_url_exists_p@>
			<td><small>
				[
				<if @certifications.edit_url@ not nil>
					<a href="@certifications.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @certifications.delete_url@ not nil>
					<a href="@certifications.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				<if @certifications.permit_url@ not nil>
				|
					<a href="@certifications.permit_url@">Permit</a>
				</if>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
