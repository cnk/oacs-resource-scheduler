<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @resumes:rowcount@ gt 0>
<table width="100%">
	<tr><th align="left" valign="top" class="secondary-header">Description<if @resumes:rowcount@ gt 1>s</if></th>
		<if @resume_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="resumes">
		<!-- output leading space and expand/collapse widget -->
		<if @resumes.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output resume title/name row(@resumes.rownum@) -->
		<if @resumes.detail_url@ not nil>
			<td><a href="@resumes.detail_url@">@resumes.description@</a></td></if>
		<else>
			<td>@resumes.description@</td>
		</else>

		<!-- output available actions -->
		<if @resumes.action_url_exists_p@>
			<td><small>
				[
				<if @resumes.download_url@ not nil>
					<a	title="Click this link to begin dowloading the resume.  It is @resumes.download_size@."
						href="@resumes.download_url@">Download</a>
				|
				</if><else><if @resume_download_url_exists_p@>
					<span style="visibility: hidden">Download | </span>
					</if>
				</else>

				<if @resumes.edit_url@ not nil>
					<a href="@resumes.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @resumes.delete_url@ not nil>
					<a href="@resumes.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				<if @resumes.permit_url@ not nil>
				|
					<a href="@resumes.permit_url@">Permit</a>
				</if>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
