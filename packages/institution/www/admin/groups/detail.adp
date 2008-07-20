<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master src="../master">
<property name="title">@title@</property>
<property name="context">@context@</property>
<property name="keywords">@keywords@</property>

<span class="primary-header">Institution Admin: @group_name@</span>
<br><br>
<style type="text/css">th { padding-right: 8px }</style>
<table class="layout" bgcolor="#ffffff">
	<tr><td valign="top">
		<table cellpadding="0" cellspacing="0" border="0px" style="padding-left: 7px">
			<!-- instance attributes -->
			<tr><th class="secondary-header" align="left">Name:</th>
				<td class="data">@group_name@</td>
				<td rowspan="3" valign="top" style="padding-left: 1em">
					<if @can_change_this_group_p@>
					<table align="right" border="1" cellpadding="2" cellspacing="2">
					<tr><td align="center">
							<b>Actions:</b>
						</td>
					</tr>
					<tr><td style="margin-left: 20px">
							<if @group_edit_url@ not nil>
								<a href="@group_edit_url@">Edit This Group</a><br>
							</if>
							<if @group_permit_url@ not nil>
								<nobr><a href="@group_permit_url@">Change the Permissions on This @actual_object_type@</a></nobr><br>
							</if>
							<if @group_delete_url@ not nil>
								<a href="@group_delete_url@">Delete This Group</a><br>
							</if>
							<if @jccc_write_url@ not nil>
								<a href="@jccc_write_url@">Edit JCCC Information</a>
							</if>
						</td>
					</tr>
					</table>
					</if>
				</td>
			</tr>
			<tr><th class="secondary-header" align="left">Short Name:</th>
				<td class="data">@short_name@</td>
			</tr>
			<if @parent_group_name@ not nil>
				<tr><th class="secondary-header" align="left">Parent Group:</th>
					<td class="data">
						<a href="@parent_group_url@">@parent_group_name@</a>
					</td>
				</tr>
			</if>
			<if @alias_group_name@ not nil>
				<tr><th class="secondary-header" align="left">Alias for Group:</th>
					<td class="data">
						<a href="@alias_group_url@">@alias_group_name@</a>
					</td>
				</tr>
			</if>
			<tr><th class="secondary-header" align="left">Type:</th>
				<td class="data">@group_type_name@</td>
			</tr>
			<tr><th class="secondary-header" align="left" valign="top">Description:</th>
				<td colspan="2" class="data">@description@</td>
			</tr>
			<tr><th class="secondary-header" align="left" valign="top">Keywords:</th>
				<td colspan="2" class="data">@keywords@</td>
			</tr>
		</table>
		<if @admin_p@>
		<table cellpadding="0" cellspacing="0" style="padding-left: 7px; padding-top: 8px;">
			<tr><th class="secondary-header" align="left">Created on:</th>
				<td>@created_on@ <i>at</i> @created_at@</td>
			</tr>
			<if @created_by@ not nil>
				<tr><th class="secondary-header" align="left">Created by:</th>
					<td>@created_by@</td>
				</tr>
			</if>
			<tr><th class="secondary-header" align="left">Updated on:</th>
				<td>@modified_on@ <i>at</i> @modified_at@</td>
			</tr>
			<if @modified_by@ not nil>
				<tr><th class="secondary-header" align="left">Updated by:</th>
					<td>@modified_by@</td>
				</tr>
			</if>
		</table>
		</if>
		<table cellpadding="0" cellspacing="0" style="padding-left: 7px; padding-top: 8px;">
			<!-- Sub-Groups -->
			<tr><th align="left" valign="top" class="secondary-header">
					Subgroups:
				</th>
				<td align="left"><!-- an expandable tree of (sub)groups -->
					<if @n_children@ gt 0>
						<include src="tree"
								&="root_group_id"
								&="roots"
								&="show"
								&="hide">
					</if><else>
						<i>None</i><br>
					</else>
					<if @subgroup_create_url@ not nil>
						<a href="@subgroup_create_url@">
						<if @actual_object_type@ in "Group">
							Add a Sub-group
						</if><else>
							Add a Top Level Group
						</else>
						</a>
					</if>
				</td>
			</tr>
			<tr><td colspan="2"><hr size="1"></td></tr>

			<!-- Addresses -->
			<tr><th align="left" valign="top" class="secondary-header">
					<a href="@group_addresses_url@">Addresses</a>:
				</th>
				<td align="left"><!-- a list of addresses -->
					<include src="../address/list"
							return_url="@this_url@"
							&items="group_addresses"
							&="group_id"
							if_none_put="None">
					<if @group_add_address_url@ not nil>
						<a href="@group_add_address_url@">Add an Address</a>
					</if>
				</td>
			</tr>

			<!-- Emails -->
			<tr><th align="left" valign="top" class="secondary-header">
					<a href="@group_emails_url@">Email Addresses:</a>
				</th>
				<td align="left"><!-- a list of emails -->
					<include src="../email/list"
							return_url="@this_url@"
							&items="group_emails"
							&="group_id"
							if_none_put="None">
					<if @group_add_email_url@ not nil>
						<a href="@group_add_email_url@">Add an Email Address</a>
					</if>
				</td>
			</tr>


			<!-- URLs -->
			<tr><th align="left" valign="top" class="secondary-header">
					<a href="@group_urls_url@">URLs:</a>
				</th>
				<td align="left"><!-- a list of urls -->
					<include src="../url/list"
							return_url="@this_url@"
							&items="group_urls"
							&="group_id"
							if_none_put="None">
					<if @group_add_url_url@ not nil>
						<a href="@group_add_url_url@">Add a URL</a>
					</if>
				</td>
			</tr>


			<!-- Phone Numbers -->
			<tr><th align="left" valign="top" class="secondary-header">
					<a href="@group_phones_url@">Phone Numbers:</a>
				</th>
				<td align="left"><!-- a list of phones -->
					<include src="../phone-number/list"
							return_url="@this_url@"
							&items="group_phones"
							&="group_id"
							if_none_put="None">
					<if @group_add_phone_url@ not nil>
						<a href="@group_add_phone_url@">Add a Phone Number</a>
					</if>
				</td>
			</tr>


			<!-- Certifications -->
			<tr><th align="left" valign="top" class="secondary-header">
					<a href="@group_certifications_url@">Certifications:</a>
				</th>
				<td align="left"><!-- a list of certifications -->
					<include src="../certification/list"
							return_url="@this_url@"
							&items="group_certifications"
							&="group_id"
							if_none_put="None">
					<if @group_add_certification_url@ not nil>
						<a href="@group_add_certification_url@">Add a Certification</a>
					</if>
				</td>
			</tr>


			<if @admin_p@>
				<!-- Images -->
				<tr><th align="left" valign="top" class="secondary-header">
						<a href="@group_images_url@">Images:</a>
					</th>
					<td align="left"><!-- a list of images -->
						<include src="../party-image/list"
								return_url="@this_url@"
								&items="group_images"
								&="group_id"
								if_none_put="None">
						<if @group_add_image_url@ not nil>
							<a href="@group_add_image_url@">Add an Image</a>
						</if>
					</td>
				</tr>
			</if>
           <tr><td colspan="2"><hr size="1"></td></tr>
		</table>

	</td>
	<td valign="top">

		<table cellpadding="2" cellspacing="4">
			<!-- Personnel -->
			<tr><th bgcolor="#cccccc" valign="top" class="secondary-header">
					Personnel:
			</th></tr>
			<tr>
			<td align="left"><!-- a list of personnel -->
					<% set allow_action_p(permit) 0 %>
					<include src="../personnel/list"
							return_url="@this_url@"
							&items="group_personnel"
							&="group_id"
							max="max_personnel"
							if_none_put="None">
					<if @group_associate_personnel_url@ not nil>
						<a href="@group_associate_personnel_url@">Associate Personnel with this Group</a><br>
						<a href="@personnel_group_add_url@">Create Personnel within this Group</a><br>
					</if>
			</td>
			</tr>
		</table>
		</td>
	</tr>
</table>


