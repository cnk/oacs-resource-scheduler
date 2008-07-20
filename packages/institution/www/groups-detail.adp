<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="context">@context@</property>
<property name="title">@title@</property>
<property name="group_id">@group_id@</property>
<property name="keywords">@details.keywords@</property>

<if @pcn_p@>
	<include src="/packages/shared/www/templates/section-var-pcn"></if>
<else>
	<include src="/packages/shared/www/templates/section-var-departments">
	<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">
</else>

<!-- ---------------------------Add Body Content Here------------------- -->
<table align="center">
	<if @pcn_p@>
		<tr><td colspan="100%" align="center" valign="top">
				<if @front_photo_id@ not nil>
					<include src="admin/party-image/view-template" image_id="@front_photo_id@" max_width="400">
				</if>
			</td>
		</tr>
	</if>
	<tr><th colspan="100%" align="center" class="primary-header">@details.short_name@
			<if @edit_url@ not nil>
				<small><small>
					[ <a href="@edit_url@">Edit</a>
					| <a href="../register/logout">Logout</a>
					]
				</small></small>
			</if>
		</th>
	</tr>

	<if @details.parent_name@ not nil and @show_parent_name_p@>
		<tr><th colspan="100%" align="center" class="secondary-header">
				<a href="groups-detail?group_id=@details.parent_group_id@">
					@details.parent_name@
				</a>
			</th>
		</tr>
	</if>

	<!-- Spacer -->
	<tr class="layout"><td>  <br><br>  </td></tr>

	<if @pcn_p@ not>
		<tr><th class="secondary-header" align="right"><nobr>@details.group_type@:</nobr></th>
			<td class="main-text" valign="top">@details.short_name@</td>
		</tr>
	</if>

	<if @details.description@ not nil>
	<tr><th class="secondary-header" align="right" valign="top">Information:</th>
		<td class="main-text" valign="top">@details.description@</td></tr>
	</if>

	<!-- //TODO// CERTIFICATION INFO -->

	<!-- CATEGORIES, grouped -->
	<if @group_cat_info:rowcount@ gt 0>
		<multiple name="group_cat_info">
			<tr><td><br></td></tr>
			<tr><th class="secondary-header" align="right" valign="top"><nobr>@group_cat_info.parent_name@:</nobr></th>
				<td class="main-text" valign="top"><group column="parent_name"><nobr>@group_cat_info.name@</nobr><br></group></td>
				</tr></multiple><tr><td><br></td></tr>
	</if>

	<!-- //TODO// LEADERS //TODO// update to look more like personnel -->
	<if @leaders:rowcount@ gt 0>
		<tr><th class="secondary-header" align="right" valign="top"><nobr>Physicians:</nobr></th></tr>
		<multiple name="leaders">
			<tr><td />
				<td class="main-text" valign="top">@leaders.last_name@, @leaders.first_names@</td>
				<td class="main-text" valign="top">@leaders.title@</td>
			</tr>
			</multiple>
	</if>
	<!-- TELEPHONE INFO -->
<if 1> <!-- @pcn_p@? -->
	<if @phones:rowcount@ gt 0>
		<tr valign="top">
			<th class="secondary-header" align="right" valign="top">
				<nobr>Telephone Number<if @phones:rowcount@ gt 1>s</if>:</nobr>
			</th>
			<td valign="top">
				<table cellpadding="0" cellspacing="0" border="0"><tr>
					<multiple name="phones">
						<tr valign="top">
							<td class="main-text" valign="top" style="padding: inherit; padding-left: 0.75em;">
								<if @phones.format_phone_p@ ne 0>
									<nobr>(@phones.area_code@) @phones.prefix@-@phones.num@</nobr>
								</if><else>
									<nobr>@phones.phone_number@</nobr>
								</else>
							<td class="main-text" valign="top" style="padding: inherit; padding-left: 2em;">@phones.descript@</td></tr>
					</multiple>
				</table>
			</td>
		</tr>
		<tr><td valign="top"><br></td></tr>
	</if>
</if>

<!-- URL INFO -->
<if @urls:rowcount@ gt 0>
	<tr><th class="secondary-header" align="right" valign="top">
			Web Resource<if @urls:rowcount@ gt 1>s</if>:
		</th>
		<td valign="top">
			<multiple name="urls">
				&nbsp;&nbsp;
				<a target="_blank" href="@urls.url@">
					@urls.url@
				</a>
				<br>
			</multiple>
		</td>
	</tr>
</if>

<!-- EMAIL INFO -->
<if @emails:rowcount@ gt 0>
	<tr valign="top">
		<th class="secondary-header" align="right">
			Email<if @emails:rowcount@ gt 1>s</if>:
		</th>
		<td><table border="0" cellpadding="0" cellspacing="0" valign="top" style="padding-left: 0.75em">
			<multiple name="emails">
				<tr><td valign="top" class="main-text" style="padding: inherit">
						<a href="mailto:@emails.email@">
							@emails.email@
						</a>
					</td>
					<td valign="top" class="main-text" style="padding: inherit; padding-left: 20px;">
						@emails.name@
					</td>
				</tr>
			</multiple>
			</table>
		</td>
	</tr>
</if>
<!-- GROUPS IMMEDIATELY INSIDE THIS GROUP -->
<if @children_p@>
		<tr><td colspan="2" valign="top">&nbsp;<br></td><tr>
		<tr><th class="secondary-header" align="right" valign="top">
				<!-- some of the formatting in this list is important: if you're not careful, -->
				<!-- extra spaces will find their way into your output -->
				<list name="subgroup_types">
					<if @subgroup_types:rownum@ gt 1>
						<if @subgroup_types:rownum@ eq @subgroup_types:rowcount@>
							 and </if>
						<else>, </else>
					</if>
					@subgroup_types:item@<if 0><!-- suck up whitespace --></if>
				</list>:
				<!--within the @details.group_type@ of @details.short_name@: -->
			</th>
			<td class="main-text" valign="top">
				<include src="tree"
						&roots="children"
						&="show"
						&="hide"
						title=" "
						maxdepth="1"
						root_group_id="@group_id@">
			</td></tr>
		<tr><td colspan="2" valign="top">&nbsp;<br></td><tr>
</if>
<!-- END CHILDREN GROUPS -->

<!-- PERSONNEL INFO -->
  <if @personnel:rowcount@ gt 0>
		<multiple name="personnel">
			<% set odd_p !0 %>
			<tr><th class="secondary-header" align="right" valign="top">
					<%= $title_names($personnel(title_id)) %>:
				</th>

				<td><table class="layout" valign="top" style="padding-left: 0.75em">
					<tr><th></th>
						<th class="secondary-header">Name</th>
						<th class="secondary-header">Specialty</th>
					</tr>
					<group column="title_id">
						<% set odd_p [expr !$odd_p] %>
						<if @odd_p@>
							<tr bgcolor="#FFFFFF">
						</if><else>
							<tr bgcolor="#CBDBEC">
						</else>
							<if @personnel.accepting_p@ eq 1 and @personnel.pcp_p@ eq 1>
								<td class="main-text" valign="top" bgcolor="#FFFFFF" style="width: 30px">
									<img src="@subsite_url@images/red-check"></img>
									<% set one_or_more_accepting_p 1 %>
								</td>
							</if><else><td></td></else>

							<td style="padding-right: 0.75em" class="main-text">
								<a href="physician?personnel_id=@personnel.personnel_id@">
									@personnel.last_name@, @personnel.first_names@
								</a>
							</td>
							<td colspan="100%" valign="top" class="main-text">
								<group column="personnel_id">
									@personnel.medical_specialty@<br>
								</group>
							</td>
						</tr>
					</group>
					</table>
				</td>
			</tr>
			<tr><td valign="top">&nbsp;<br></td><tr>
		</multiple>

		<if 0><!--	2006/04/28: Linda Ho requested hiding checkmark [on
					patient-care pages] when there are no Primary Care
					physicians being displayed.

					2005/02/17: Used '@one_or_more_accepting_p@ not nil' to show
					this only if one or more physicians in the current group
					were accepting patients.  It was later decided that its best
					to always show this on patient-care related pages, so this
					change was made.
		--></if>
		<if @at_least_one_pcp_p@>
		<tr><td /><td valign="top" class="main-text">
				<p><img src="@subsite_url@images/red-check" />
				: Physician is accepting new managed care (HMO) patients.</p>
				<p class="main-text-bold">Physician availability is subject to
				change.  Please call the physician's office directly to
				confirm.</p>
			</td>
		<tr>
		</if>

		<tr><td valign="top">&nbsp;<br></td><tr>
	</if>

	<!-- ADDRESS INFO: note the incomplete rows constructed by the 'multiple' that are closed outside of it -->
<if @pcn_p@>
	<tr><td colspan="100%" align="center">
			<if @map_image_id@ not nil>
				<include src="admin/party-image/view-template"
						 image_id="@map_image_id@"
						 style="padding: 0px; border-width: 1px; border-style: solid; border-color: gray">
			</if>
		</td>
	</tr>

	<if @addresses:rowcount@ gt 0>
		<tr><th class="secondary-header" align="right" valign="top">Address<if @addresses:rowcount@ gt 1>es</if>:</th>
		<multiple name="addresses">
			<td class="main-text" valign="top">
				<if @addresses.description@ not nil>	@addresses.description@<br></if>
				<if @addresses.building_name@ not nil>	@addresses.building_name@</if>
				<if @addresses.address_line_1@ not nil>	@addresses.address_line_1@<br></if>
				<if @addresses.address_line_2@ not nil>	@addresses.address_line_2@<br></if>
				<if @addresses.address_line_3@ not nil>	@addresses.address_line_3@<br></if>
				<if @addresses.address_line_4@ not nil>	@addresses.address_line_4@<br></if>
				<if @addresses.address_line_5@ not nil>	@addresses.address_line_5@<br></if>
				<if @addresses.city@ not nil>
					@addresses.city@<if @addresses.abbrev@ not nil>, @addresses.abbrev@</if>
					<if @addresses.zipcode@ not nil>,
						@addresses.zipcode@<if @addresses.zipcode_ext@ not nil>-@addresses.zipcode_ext@</if>
					</if>
					<br>
				</if>
				<br>
				</td>
			</tr>
			<tr>
			<td />
		</multiple>
		</tr>
	</if>
</if>

<!-- Related Vital Signs Article Links -->
<if @article_info:rowcount@ gt 0>
	<tr><th class="secondary-header" align="right" valign="top">
			Read Related Vital Signs Articles:
		</th>
		<td class="main-text" valign="top">
			<table class="main-text">
				<multiple name="article_info">
					<if @article_info.rownum@ odd>
						<tr bgcolor="#CBDBEC">
					</if>
					<else>
						<tr bgcolor="#FFFFFF">
					</else>
						<td valign="top" class="main-text">
							<a href="@subsite_url@vital-signs/article-display?article_id=@article_info.article_id@">
								@article_info.article_title@
							</a>
						</td>
					</tr>
				</multiple>
			</table>
		</td>
	</tr>
</if>

<!-- Primary Care Physician Blurb -->
<if @pcn_p@>
	<tr><td colspan="2" style="padding: 2.5em">Before selecting a primary care physician, please call 1-800-UCLA-MD1
	(1-800-825-2631) or the physician's office to confirm the practice is open to
	new managed care patients.  (HMO plan)</td></tr>
</if>

<!-- ------------------------End the body code here---------------------- -->
</table>
</div>
<include src="/packages/shared/www/templates/section-footer">
