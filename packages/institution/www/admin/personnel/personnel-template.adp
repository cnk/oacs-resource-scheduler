<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<table cellpadding="2" cellspacing="4" border="0">
	<!-- This cell contains photo, name, department, certification, phone, and email info -->
	<tr><td>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr><td valign="top" align="left">
					<include	src="photo-template"
								personnel_id="@personnel_id@"
								max_width="155"
								max_height="225"
								border="0">&nbsp;
				</td>
				<td  width="100%" align="left" class="blueboldlarge" valign="top">@first_name@ @last_name@<if @medical_degree_titles@ not nil>,
					@medical_degree_titles@</if></td>
			</tr>
		</table>
		</td>
	</tr>

	<!-- Titles and Groups Info -->
	<tr><td><table cellspacing="2">
			<multiple name="position_info">
				<tr><td colspan=100%><span class="section_label">@position_info.group_affiliation_type@</span></td></tr>
					<group column="group_affiliation_type">
					<tr><td>
					<if @position_info.hospital_p@>
							<span class="secondary-header">@position_info.department@</span>
					</if>
					<else>
							<span class="secondary-header">@position_info.position@,</span>
							<span class="data">
							<a href="../groups/detail?group_id=@position_info.group_id@">@position_info.department@</a></span>
					</else></td></tr></group>
					<tr><td>&nbsp;</td></tr><!-- spacer -->
			</multiple></table></td>
	</tr>


	<!-- General Information -->
	<tr><td><table cellpadding="2" cellspacing="0" border="0">
				<tr><th class="section_label" colspan="100%">General Information:</th></tr>
				<tr><th class="secondary-header">Gender:</th>		<td class="data">@gender@</td></tr>
				<tr><th class="secondary-header">Age:</th>			<td class="data">@age@</td></tr>
				<tr><th class="secondary-header">Languages:</th>	<td class="data">@language_info@</td></tr>
			</table>
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr><!-- spacer -->

	<!-- Education -->
	<tr><td><table cellpadding="2" cellspacing="0" border="0">
				<multiple name="cert_info">
				<tr><td colspan=100%><span class="section_label">@cert_info.certification_affiliation_type@</span></td></tr>
   					<group column="certification_affiliation_type">
					<tr><th class="secondary-header" valign="top">@cert_info.parent@:</th>
						<td class="data" valign="top">
							<group column="parent">@cert_info.certification@<br></group>
						</td></tr>
					</group>
				<tr><td>&nbsp;</td></tr><!-- spacer -->
				</multiple>
			</table>
		</td>
	</tr>

	<!-- Contact Information -->
	<if @contact_info_exists_p@><tr><th class="section_label">Contact Information</th></tr></if>

	<if @email_addrs:rowcount@ gt 0>
	<tr><td align=left><table cellpadding="2" cellspacing="0" border="0">
				<multiple name="email_addrs">
					<tr><th class="secondary-header">@email_addrs.type@:</th>
						<td class="data"><a href="mailto:@email_addrs.email@">
							@email_addrs.email@</a></td>
					</tr>
				</multiple>
			</table>
		</td>
	</tr>
	</if>

	<if @phones:rowcount@ gt 0>
	<tr><td align=left><table cellpadding="2" cellspacing="0" border="0">
				<multiple name="phones">
					<tr><th class="secondary-header">@phones.type@:</th>
						<td class="data">(@phones.area_code@) @phones.prefix@-@phones.suffix@</td>
					</tr>
				</multiple>
			</table>
		<td>
	</tr>
	</if>

	<if @addresses:rowcount@ gt 0>
	<tr><td align=left><table class="layout">
				<multiple name="addresses">
			<tr><th class="secondary-header" valign=top><nobr>@addresses.type@:&nbsp;&nbsp;</nobr></th>
			<td class="data">
			<if @addresses.description@ not nil>@addresses.description@<br></if>
			<if @addresses.address_line_1@ not nil>@addresses.address_line_1@</if>
			<if @addresses.address_line_2@ not nil>@addresses.address_line_2@<br></if>
			<if @addresses.address_line_3@ not nil>@addresses.address_line_3@<br></if>
			<if @addresses.address_line_4@ not nil>@addresses.address_line_4@<br></if>
			<if @addresses.address_line_5@ not nil>@addresses.address_line_5@<br></if>
			<if @addresses.citystate@ not nil>@addresses.citystate@<br</if>
			<if @addresses.country@ not nil>@addresses.country@<br></if>
			</td></tr>
				</multiple>
			</table>
		</td>
	</tr>
	</if>

	<if @url_info:rowcount@ gt 0>
	<tr><td><multiple name="url_info">
				@url_info.type@:&nbsp;<a href="@url_info.url@">@url_info.url@</a><br>
			</multiple>
		</td>
	</tr>
	</if>

	<if @bio@ not nil>
		<tr><td>Bio:&nbsp;@bio@</td></tr>
	</if>

</table>
