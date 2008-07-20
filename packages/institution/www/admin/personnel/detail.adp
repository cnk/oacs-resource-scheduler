<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>

<% set step 0 %>

<!-- ADMIN TABLE -->
<table cellpadding="0" cellspacing="0" width="100%">
	<tr><td style="padding: 5px" valign="top">
			<b>Personnel: @first_names@ @middle_name@ @last_name@</b><br />
			<if @group_admin_p@ eq 1 or @sitewide_admin_p@ eq 1>
				Status:			@status@<br />
				Date of Birth:	@date_of_birth@<br />
				Gender:			@gender@<br />
				Start Date:		@start_date@<br />
				End Date:		@end_date@<br />

				Created on:		@created_on@ <i>at</i> @created_at@ <br />
				<if @created_by@ not nil>
					Created by:	@created_by@<br />
				</if>
				Updated on:		@modified_on@ <i>at</i> @modified_at@<br />
				<if @modified_by@ not nil>
					Updated by:	@modified_by@<br />
				</if>
			</if>
		</td>
		<td style="padding: 5px" valign="top">
 <if @sitewide_admin_p@>
			<if @morrissey_physician_data_url@ not nil>					<a href="@morrissey_physician_data_url@">Examine Morrissey Import Data</a><br /></if>
			<if @personnel_delete_url@ not nil>							<a href="@personnel_delete_url@">Delete this Personnel</a> <br /> </if>
			<if @physician_p@ eq 1 and @personnel_write_url@ not nil>	<a href="@physician_write_url@">Edit this Physician</a> <br /> </if>
			<if @user_p@ eq 0 and @user_create_url@ not nil>			<a href="@user_create_url@">Make this Personnel a User</a> <br /> </if>
			<if @faculty_create_url@ not nil>
				<if @faculty_p@ eq 0>
					<a href="@faculty_create_url@">Make this Personnel a Faculty</a><br />
				</if><else>
					<a href="@faculty_edit_url@">Edit this Person's Faculty Info</a><br />
				</else>
			</if>
			<if @faculty_p@ gt 0 and @faculty_delete_url@ not nil>		<a href="@faculty_delete_url@">Remove this Personnel from Faculty</a> <br /> </if>
 </if>

			<if @jccc_write_url@ not nil>								<a href="@jccc_write_url@">Edit JCCC Information</a><br /></if>
			<if @access_write_url@ not nil>								<a href="@access_write_url@">Edit ACCESS Information</a><br /></if>
			<if @sph_write_url@ not nil>								<a href="@sph_write_url@">Edit SPH Information</a><br /></if>
			<if @personnel_permit_url@ not nil>							<a href="@personnel_permit_url@">Change the Permissions on this Person</a><br /></if>
			                                                            <a href="@subsite_url@institution/personnel?personnel_id=@personnel_id@">View Public Profile</a><br />
			<if @user_id@ eq @personnel_id@>							<a href="@subsite_url@pvt/home">Go Back to Your Workspace</a>.<br /></if>
		</td>
	</tr>
</table>
<!-- END ADMIN TABLE -->

<table cellpadding="0" cellspacing="0" width="100%">
	<tr><td bgcolor="#ccffff" style="padding: 5px">
			<if @personnel_write_url@ not nil>
				<span class="primary-header">
					<a href="@personnel_write_url@">Step 1: Edit Basic Information</a>
				</span><br />
				<% incr step %>
			</if>
		</td>
	<tr><td bgcolor="#ffffff">&nbsp;</td></tr>
	<tr><td bgcolor="#ccffcc">
			<span class="primary-header">Step 2: Contact Information</span>
			<% incr step %>
			<br /><br />

	<table cellpadding="2" cellspacing="2" border="0" width="95%" bgcolor="#ffffff">
		<tr><td valign="top" align="left" colspan="2">
				<p><span class="secondary-header">@first_names@ @middle_name@ @last_name@</span></p>
			</td>
		</tr>
		<tr><td valign="top" align="left" colspan="2">
				<if 0><include src="../../photo-template"
					 personnel_id="@personnel_id@"
					 max_width="155"
					 max_height="225"
					 border="0">&nbsp;
				</if>
			</td>
		</tr>
		<tr><td colspan="2">
				<if @sitewide_admin_p@>
					(Preferred Name: <if @preferred_first_name@ nil and @preferred_last_name@ nil><i>n/a</i></if><else>@preferred_first_name@ @preferred_middle_name@ @preferred_last_name@</else>)
				</if>
				<!-- USER LOGIN IDENTITY -->
				<if @user_p@ gt 0>
					<p><span class="secondary-header">User Login:</span> @user_login@</p>
				</if>
			</td>
		</tr>

		<!-- Addresses -->
		<tr><td valign="top" class="secondary-header">
				Addresses:
			</td>
			<td><include src="../address/list"
						return_url="@this_url@"
						&items="personnel_addresses"
						&="personnel_id"
						if_none_put="None"
						&="step">
				<if @personnel_create_address_url@ not nil>
					<a href="@personnel_create_address_url@">Add an Address</a>
				</if>
			</td>
		</tr>

		<!-- Emails -->
		<tr><td valign="top" class="secondary-header">
				Email Addresses:
			</td>
			<td><include src="../email/list"
						return_url="@this_url@"
						&items="personnel_emails"
						&="personnel_id"
						if_none_put="None"
						&="step">
				<if @personnel_create_email_url@ not nil>
					<a href="@personnel_create_email_url@">Add an Email Address</a>
				</if>
			</td>
		</tr>

		<!-- URLs -->
		<tr><td valign="top" class="secondary-header">
				URLs:
			</td>
			<td><include src="../url/list"
						return_url="@this_url@"
						&items="personnel_urls"
						&="personnel_id"
						if_none_put="None"
						&="step">
				<if @personnel_create_url_url@ not nil>
					<a href="@personnel_create_url_url@">Add a URL</a>
				</if>
			</td>
		</tr>

		<!-- Phone Numbers -->
		<tr><th align="left" valign="top" class="secondary-header">
				Phone Numbers:
			</th>
			<td><include src="../phone-number/list"
						return_url="@this_url@"
						&items="personnel_phones"
						&="personnel_id"
						if_none_put="None"
						&="step">
				<if @personnel_create_phone_url@ not nil>
					<a href="@personnel_create_phone_url@">Add a Phone Number</a>
				</if>
			</td>
		</tr>
	</table>
	</td>
	</tr>

	<tr><td bgcolor="#ffffff">&nbsp;</td></tr>
	<tr><td bgcolor="#ffffcc">
			<a name="research-info"></a>
			<% incr step %>
			<span class="primary-header">Step 3: Research Information</span>
			<br /><br />
			<table cellpadding="2" cellspacing="2" border="0" width="95%" bgcolor="#ffffff">
				<!-- Titles -->
				<tr><td class="secondary-header" valign="top">Titles:</td>
					<td align="left">
						<table>
							<multiple name="titles">
							<tr><td></td><td align="left">
									<if @titles.admin_p@>
										<a href="@titles.detail_url@">
											@titles.title@</a>,
									</if><else>@titles.title@,</else>

									<if @titles.group_url@ not nil>
										<a href="@titles.group_url@">
											@titles.group_name@</a>
									</if><else> @titles.group_name@</else>
									<if @titles.pretty_title@ not nil>(@titles.pretty_title@)</if>
								</td>
								<td><if @titles.edit_url@ not nil>&nbsp;&nbsp;&nbsp;&nbsp;
										<a href="@titles.edit_url@">Edit</a>
									</if>
									<if @titles.delete_url@ not nil>&nbsp;&nbsp;&nbsp;&nbsp;
										<a href="@titles.delete_url@">Remove</a>
									</if>
									<br />
								</td>
							</tr>
							</multiple>

							<tr><td></td>
								<td colspan="2" height="0px" bgcolor="#666666"></td>
							</tr>
							<tr><td></td><td colspan="2">
									<p>	<if @title_add_url@ not nil>
											<a href="@title_add_url@">Add a Title</a></if><if @title_add_url@ not nil and @title_arrange_url@ not nil>,
										</if><else><br /></else>
										<if @title_arrange_url@ not nil and @titles:rowcount@ gt 0>
											<a href="@title_arrange_url@">Arrange These Titles</a>
										</if>
									</p>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td bgcolor="#ffffff">&nbsp;</td></tr>

				<!-- Research Interest -->
				<tr><th align="left" valign="top" class="secondary-header">
						Research Interests:
					</th>
					<td><table class="layout" valign="top" width="100%">
					    <tr><th align="left" valign="top" class="secondary-header">Type</th>
						 <th class="secondary-header">Title</th><th class="secondary-header">Research Interest</th>
						 <if @personnel_edit_ri_url@ not nil><th class="secondary-header">Action</th></if></tr>
						 <tr bgcolor="#CBDBEC"><td valign="top">@lay_label@</td>
						 <if @lay_research_interest@ not nil>
						 		<if @lay_research_interest_title@ not nil> <td valign="top">@lay_research_interest_title@</td></if>
								<else><td valign="top" align="center"><i>n/a</i></td></else>
								<td valign="top">@lay_research_interest@</td>
								<if @personnel_edit_ri_url@ not nil><td valign="top"><a href="@personnel_edit_ri_url@">Edit</a> </if>
								<if @personnel_edit_ri_url@ not nil and @personnel_delete_ri_url@ not nil>|</if>
								<if @personnel_delete_ri_url@ not nil><a href="@personnel_delete_ri_url@&type=lay">Delete</a></td></if>
						 </if>
						 <else><td valign="top" align="center"><i>n/a</i></td><td valign="top" align="center"><i>n/a</td><td></td></else>
						</tr>
						 <tr bgcolor="#FFFFFF"><td valign="top">@technical_label@</td>
						 <if @technical_research_interest@ not nil>
						 		<if @technical_research_interest_title@ not nil> <td valign="top">@technical_research_interest_title@</td></if>
								<else><td valign="top" align="center"><i>n/a</i></td></else>
								<td valign="top">@technical_research_interest@</td>
								<if @personnel_edit_ri_url@ not nil><td valign="top"><a href="@personnel_edit_ri_url@">Edit</a> </if>
								<if @personnel_edit_ri_url@ not nil and @personnel_delete_ri_url@ not nil>|</if>
								<if @personnel_delete_ri_url@ not nil><a href="@personnel_delete_ri_url@&type=technical">Delete</a></td></if>
						 </if><else><td valign="top" align="center"><i>n/a</i></td><td valign="top" align="center"><i>n/a</td><td></td></else>
						 </tr>
						 </table>
						 <if @personnel_create_ri_url@ not nil>
						 <a href="@personnel_create_ri_url@">Add/Edit Research Interests for Other Web Sites</a>
						 </if>
				</td></tr>

<if 0><!-- SITEWIDE ADMINS ONLY? *************************** -->
				<tr><td class="secondary-header" valign="top">Bio:</td>
					<td>@bio@</td>
				</tr>
				<tr><td class="secondary-header">Notes:</td>
					<td>@notes@</td>
				</tr>
				<tr><td class="secondary-header" valign="top">
						Language(s):
					</td>
					<td><multiple name="languages">
							@languages.name@ <br />
						</multiple>
					</td>
				</tr>
</if><!-- ****************************************************************** -->

				<!-- Certifications -->
				<tr><td valign="top"><span class="secondary-header">
						Degrees/Certifications:</span><br />
						<small style="color: red"><a href="@example_degree_url@">Click Here for an Example</a></small>
					</td>
					<td align="left"><!-- a list of certifications -->
						<include src="../certification/list"
								return_url="@this_url@"
								&items="personnel_certifications"
								&="personnel_id"
								if_none_put="None"
								&="step">
						<if @personnel_create_certification_url@ not nil>
							<a href="@personnel_create_certification_url@">Add a Degree/Certification</a>
						</if>
					</td>
				</tr>

				<!-- Resumes -->
				<tr><td align="left" valign="top" class="secondary-header">
						Resumes/CVs:
					</td>
					<td align="left"><!-- a list of resumes -->
						<include src="../resume/list"
								return_url="@this_url@"
								&items="personnel_resumes"
								&="personnel_id"
								if_none_put="None"
								&="step">
						<if @personnel_create_resume_url@ not nil>
							<a href="@personnel_create_resume_url@">Add a Resume/CV</a>
						</if>
					</td>
				</tr>

<if 0><!-- iff nih-bio package mounted next to institution... -->
				<!-- NIH Biographical Sketches -->
				<tr><td align="left" valign="top" class="secondary-header">
						NIH Biographical Sketches:
					</td>
					<td align="left">
						<include src="../../../../nih-bio/www/list"
								return_url="@this_url@"
								&items="personnel_biosketches"
								&="personnel_id"
								if_none_put="None"
								&="step">
						<if @personnel_create_resume_url@ not nil>
							<a href="@personnel_create_biosketch_url@">Add an NIH Biosketch</a>
						</if>
					</td>
				</tr>
</if>

				<!-- BIO IMAGES.. CONFUSING AT BEST -->
				<if @personnel_admin_p@>
					<tr><td valign="top" class="secondary-header">
							Images for Bio:
						</td>
						<td align="left"><!-- a list of images -->
							<include src="../party-image/list"
									return_url="@this_url@"
									&items="personnel_images"
									&="personnel_id"
									if_none_put="None"
									&="step">
							<if @personnel_create_image_url@ not nil>
								<a href="@personnel_create_image_url@">Add an Image</a>
							</if>
						</td>
					</tr>
				</if>
				<tr><td valign="top" class="secondary-header">
					STTP Mentorship Sign Up</td>
					<td>
				<if @sttp_info:rowcount@ ne 0>
				<multiple name="sttp_info">
				    <if @sttp_info.row_count@ eq 1>
					  @sttp_info.sttp_description@ <if @sttp_info.expire_flag@ eq 1>"Expired"</if>
					    <if @sttp_info.expire_flag@ eq 1>
						  <if @renew_flag@ eq 0>
						  <a href="@sttp_copy@&request_id=@sttp_info.request_id@&title_p=2">Renew Mentorship</a><br />
						  </if>
						  <else>
						  <br />
						  </else>
						</if>
						<else>
						  <a href="@sttp_edit@&request_id=@sttp_info.request_id@&title_p=2">Edit</a> || <a href="@sttp_delete@&request_id=@sttp_info.request_id@&title_p=3">Delete</a>
						</else>
					</if>
				    <if @sttp_info.row_count@ eq 2>
					  @sttp_info.sttp_description@ <if @sttp_info.expire_flag@ eq 1>"Expired"</if>
					    <if @sttp_info.expire_flag@ eq 1>
						  <if @renew_flag@ eq 0>
						  <a href="@sttp_copy@&request_id=@sttp_info.request_id@&title_p=2">Renew Mentorship</a><br />
						  </if>
						</if>
						<else>
						  <a href="@sttp_edit@&request_id=@sttp_info.request_id@&title_p=2">Edit</a> || <a href="@sttp_delete@&request_id=@sttp_info.request_id@&title_p=3">Delete</a>
						</else>
					</if>
				</multiple>
				</if>
				<else>
					<i>None</i><br /><a href="@sttp_add@&title_p=1">Add Mentorship</a>
				</else>
				</td>
				</tr>
			</table>
		</td>
	</tr>

	<tr><td bgcolor="#ffffff">&nbsp;</td></tr>
	<tr><td bgcolor="#ffcc99">
			<a name="publications"></a>
			<% incr step %>
	<span class="primary-header">Step 4: Publications</span>
	<br /><br />
		<table cellpadding="2" cellspacing="2" border="0" width="95%" bgcolor="#ffffff">
			<tr><td class="secondary-header" valign="top">
					Publications:
				</td>
				<td><if @publications:rowcount@ eq 0>
						<i>None</i>
					</if>
					<table>
						<tr><td><if @personnel_create_url@ not nil>
									<a href="@publication_create_url@">Create a New Publication</a>
								</if>
								<if @personnel_create_url@ not nil and @publication_endnote_url@ not nil>
									&nbsp; | &nbsp;
								</if>
								<if @publication_endnote_url@ not nil>
									<a href="@publication_endnote_url@">
										Upload <if @user_is_this_person_p@ not nil>Your</if> EndNote Publications
										<if @user_is_this_person_p@ nil>for this Person</if>
									</a>
								</if>

								<if @publication_endnote_url@ not nil and @publication_subset_url@ not nil>
									&nbsp; | &nbsp;
								</if>
								<if @publication_subset_url@ not nil>
									<if @publications:rowcount@ gt 0>
										<a href="@publication_subset_url@">
											Arrange
											<if @user_id@ eq @personnel_id@>Your</if>
											<else>These</else>
											Publications
										</a>
									</if>
								</if>
							</td>
						</tr>
						<tr bgcolor="gray" style="height: 1px;">
							<td bgcolor="gray" style="height: 1px;">
								<span  bgcolor="gray" style="height: 1px;"/>
							</td>
						</tr>
					</table>

<!-- beginning of multiple-deletion modified by David 07/27/2006 -->
<script language="javascript1.2" src="../../scripts/checkbox.js"></script>
<br />
<formtemplate id="publications_display">
	[<a href="javascript:setAllCheckBoxes('publications_display','publication_item',true)">check all</a>   |
	 <a href="javascript:setAllCheckBoxes('publications_display','publication_item',false)">uncheck all</a>]
	<br />
	<% set ix 0 %>
	<table>
		<tr><td>&nbsp;</td></tr>

		<formgroup id="publication_item">
			<% set publication_id [lindex [lindex @publication_items@ @ix@] 1] %>
			<tr><td valign="top">@formgroup.widget@</td>
				<td valign="top">@formgroup.label@</td>
			</tr>
			<tr><td>&nbsp;</td>
				<td align="left">
					<if @publication_write_url@ not nil><a href="@publication_write_url@&publication_id=@publication_id@">Edit</a>&nbsp;&nbsp;</if>
					<if @publication_map_delete@ not nil><a href="@publication_map_delete@&publication_id=@publication_id@">Remove</a>&nbsp;&nbsp;</if>
					<if @pub_publication@ not nil><a href="@publication_download_url@publication_id=@publication_id@">Download Publication</a>&nbsp;&nbsp;</if>
					<div style="height:0.75em"> </div>
				</td>
			</tr>
			<% incr ix %>
		</formgroup>

		<tr><td>&nbsp;</td>
			<td valign="top">
						<formwidget id="submit" />
			</td>
		</tr>
	</table>
</formtemplate>
<!-- end of multiple-deletion By David -->

					<br />
				</td>
			</tr>
			<tr><td colspan="2" align="center">
					<p>	<if @user_id@ eq @personnel_id@>
							If you are done editing your data, you may
							<a href="@subsite_url@pvt/home"> Go Back to Your Workspace</a>
							or
							<form action="@subsite_url@register/logout">
								<input type="Submit" value="Save and Log Out">
							</form>
						</if>
					</p>
					<br /><br />
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>

