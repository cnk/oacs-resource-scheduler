<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>
<property name="group_id">@group_id@</property>
<property name="keywords">@details.keywords@</property>

<include src="/packages/shared/www/templates/section-header"
	page_title_text="David Geffen School of Medicine core facilities"
>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px"> 

<!-- ---------------------------Add Body Content Here------------------- -->
<table align="center">
	<tr><th colspan="100%" align="center" class="primary-header">@details.name@</th></tr>
	<if @details.parent_name@ not nil>
		<tr><th colspan="100%" align="center" class="secondary-header">
					@details.parent_name@
			</th>
		</tr>
	</if>

	<!-- CATEGORIES, grouped -->
	<if @group_cat_info:rowcount@ gt 0>
		<multiple name="group_cat_info">
			<tr><td><br></td></tr>
			<tr><th class="secondary-header" align=right valign="top"><nobr>@group_cat_info.parent_name@:</nobr></th>
				<td class="main-text" valign="top"><group column="parent_name"><nobr>@group_cat_info.name@</nobr><br></group></td>
				</tr></multiple><tr><td><br></td></tr>
	</if>

	<!-- //TODO// LEADERS //TODO// update to look more like personnel -->
	<if @leaders:rowcount@ gt 0>
		<tr><th class="secondary-header" align=right valign="top"><nobr>Physicians:</nobr></th></tr>
		<multiple name="leaders">
			<tr><td/>
				<td class="main-text" valign="top">@leaders.last_name@, @leaders.first_names@</td>
				<td class="main-text" valign="top">@leaders.title@</td>
			</tr>
			</multiple>
	</if>

	<!-- ADDRESS INFO: note the incomplete rows constructed by the 'multiple' that are closed outside of it -->
	<if @addresses:rowcount@ gt 0>
		<tr><th class="secondary-header" align=right valign="top">Location<if @addresses:rowcount@ gt 1>s</if>:</th>
		   <td class="main-text" valign="top">
		   <multiple name="addresses">
				<if @addresses.building_name@ not nil>	@addresses.building_name@</if>
				<if @addresses.address_line_1@ not nil>	@addresses.address_line_1@<br></if>
				<if @addresses.address_line_2@ not nil>	@addresses.address_line_2@<br></if>
				<if @addresses.address_line_3@ not nil>	@addresses.address_line_3@<br></if>
				<if @addresses.address_line_4@ not nil>	@addresses.address_line_4@<br></if>
				<if @addresses.address_line_5@ not nil>	@addresses.address_line_5@<br></if>
				<if @addresses.city@ not nil>
					@addresses.city@<if @addresses.abbrev@ not nil>, @addresses.abbrev@</if>
									<if @addresses.zipcode@ not nil>, @addresses.zipcode@</if>
					<br>
				</if>
			</multiple></td></tr>
	</if>

<!-- EMAIL INFO -->
<if @emails:rowcount@ gt 0>
	<tr><th class="secondary-header" align=right valign="top">Email<if @emails:rowcount@ gt 1>s</if>:</th>
			<td valign="top" class="main-text"><multiple name="emails">
					<a href="mailto:@emails.email@">@emails.email@</a><br>
				</multiple></td>
	</tr>
</if>
	<!-- TELEPHONE INFO -->
	<if @phones:rowcount@ gt 0>
		<tr><th class="secondary-header" align=right valign="top"><nobr>Phone Number<if @phones:rowcount@ gt 1>s</if>:</nobr></th>
			<td valign="top"><table cellpadding=0 cellspacing=0 border=0 class="main-text"><tr>
					<multiple name="phones">
						<tr valign="top">
							<td class="main-text" valign="top">
								<nobr>@phones.num@</nobr></td>
					</multiple>
				</table></td>
		</tr>
	</if>
	<!-- URL INFO -->
<if @urls:rowcount@ gt 0>
	<tr><th class="secondary-header" align="right" valign="top">Web Address<if @urls:rowcount@ gt 1>s</if>:
		</th>
			<td valign="top" class=main-text><multiple name="urls">
				<a target="blank" href="@urls.url@">@urls.name@</a><br />
			</multiple>
			</td>
	</tr>
</if>
<tr><td valign="top"><br></td></tr>


<!-- GROUPS IMMEDIATELY INSIDE THIS GROUP -->
<if @children_p@>
		<tr><th class="secondary-header" align=right valign="top">
				<!-- some of the formatting in this list is important: if you're not careful, -->
				<!-- extra spaces will find their way into your output -->
				<list name="subgroup_types">
					<if @subgroup_types:rownum@ gt 1>
						<if @subgroup_types:rownum@ eq @subgroup_types:rowcount@>
							 and </if>
						<else>, </else>
					</if>
					@subgroup_types:item@s<if @subgroup_types:rownum@ eq @subgroup_types:rowcount@></if>
				</list> <!--within the @details.group_type@ of @details.short_name@-->:</th>
			<td class="main-text" valign="top"><include src="tree"
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
		<tr><th class="secondary-header" align=right valign="top">
				<!-- some of the formatting in this list is important: if you're not careful,
					extra spaces will find their way into your output -->
				<list name="titles">
					<if @titles:rownum@ gt 1>
						<if @titles:rownum@ eq @titles:rowcount@>
							 and </if>
						<else>, </else>
					</if>
					@titles:item@s<if @titles:rownum@ eq @titles:rowcount@>:</if>
				</list></th>
		<td class="main-text" valign="top">
			<table border="0" cellpadding="0" cellspacing="0">
				<multiple name="personnel"><% set title_count 0 %>
					<tr><td colspan="100%" valign="top" class="main-text-bold">@personnel.medical_specialty@</td></tr>
					<group column="medical_specialty">
					<tr><td valign="top" style="padding-left:2em">
						<if @personnel.accepting_p@ and @personnel.pcp_p@><img src="@subsite_url@images/red-check"></img>
							<% set one_or_more_accepting_p 1 %>
						</if>
						</td><td valign=top>
							<a href="physician?personnel_id=@personnel.personnel_id@">
							@personnel.last_name@, @personnel.first_names@</a></td>
					</tr>
					</group>
					<tr><td valign="top" colspan=100%>&nbsp;<br></td><tr>
				</multiple>
			</table>
			</td>
		</tr>

		<if @one_or_more_accepting_p@ not nil>
			<tr><td/><td valign="top" class="main-text"><p><img src="@subsite_url@images/red-check"/>
					: Physician is accepting new managed care (HMO) patients.</p>
					<p class=main-text-bold>Physician availability is subject to change.  Please call the
					physician's office directly to confirm.</p>
				</td>
			<tr>
		</if>
		<tr><td valign="top">&nbsp;<br></td><tr>
	</if>

	<if @details.description@ not nil>
	<tr><th class="secondary-header" align=right valign="top">Description:</th>
		<td class="main-text" valign="top">@details.description@</td></tr>
	</if>


<!-- ------------------------End the body code here---------------------- -->
</table>
</div>
<include src="/packages/shared/www/templates/section-footer">
