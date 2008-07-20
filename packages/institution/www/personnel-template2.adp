<table border="0">
<tr><td>
<!-- This cell contains photo, name, department, certification, phone, and email info -->

	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	  <tr>
		<td valign="top" align="left" style="padding-left: 10px; padding-bottom: 10px; padding-right: 10px">
			<include src="photo-template"
					personnel_id="@personnel_id@"
					max_width="155"
					max_height="225">
		</td>
		<td align="left" width="100%" class="primary-header" valign="top">
			@first_name@ @last_name@<if @degree_titles@ not nil>, @degree_titles@</if>

		<if @edit_url@ not nil>
			<small><small>
			[ <a href="@edit_url@">Edit</a>
			| <a href="../register/logout">Logout</a>
			]
			</small></small>
		</if>

		<br><img src="@subsite_url@images/h-teal-pixel" width="100%" height="1"><br>

		<table cellpadding="5" cellspacing="0" border="0"><multiple name="specialty">
		    <tr><td valign="top">
					<span class="secondary-header">@specialty.parent@:</span><br>
					<group column="parent">@specialty.name@<br></group></multiple>
				</td>
				<td width="10">&nbsp;</td>

				<td valign="top">
					<if @display_page@ eq "physician" and @patient_care_p@ eq 1>
						<span class="secondary-header">General Information:</span><br>
						<if @gender@ not nil><b>Gender:</b> @gender@<br></if>
						<if @language_info@ not nil><b>Languages:</b>@language_info@</if>
					</if>
				</td>
		    </tr>
		</table>

		<if @specialty:rowcount@ ne "0" or @display_page@ eq "physician"><img src="@subsite_url@images/h-teal-pixel" width="100%" height="1"><br></if>

				<!-- Titles and Groups Info -->
				<include src="/packages/institution/www/admin/title/pretty-list"
						&="personnel_id"
						&filter="title_filter">
        	</td>
	    </tr>
	</table>

	<img src="@subsite_url@images/h-teal-pixel" width="100%" height="1"><br>

	<!-- Clinical Areas of Interest -->
	<table cellspacing="5" cellpadding="0" border="0" width="100%">
		<multiple name="area_of_interest">
			<if area_of_interest.rowcount gt 0>
				<tr><td class="secondary-header" align="left" colspan="2">
						Practice Information:
					</td>
				</tr>
			</if>
		    <tr><td class="main-text-bold" valign="top" width="20%">@area_of_interest.parent@:</td>
				<td class="main-text" align="left" valign="top"><group column="parent">@area_of_interest.name@<br></group></td>
			</tr>
		</multiple>
	</table>

	<!-- Certification/Training/Education -->
	<multiple name="cert_info">
			<table cellpadding="5" cellspacing="0" border="0" width="100%">
			    <tr><td align="left" class="secondary-header">@cert_info.certification_affiliation_type@</td>
			    </tr>
				<group column="certification_affiliation_type">
				<tr><th class="main-text-bold" align="right" valign="top">@cert_info.parent_type@:</th>
					<td class="main-text" valign="top" width="80%">
						<group column="parent_type">
							<if @cert_info.type_of_certification@ not nil>	@cert_info.type_of_certification@</if>
							<if @cert_info.certifying_party@ not nil>, @cert_info.certifying_party@</if>
							<if @cert_info.certification_years@ not nil>, @cert_info.certification_years@</if>
							<br>
						</group>
					</td>
			    	</tr>
				</group>
			</table>
	</multiple>

	<img src="@subsite_url@images/h-teal-pixel" width="100%" height="1">
	<br>
	<br>

	<if @contact_info_exists_p@>				<!-- INDIRECT Contact Information -->
		<span class="secondary-header">Contact Information:</span>
	</if>

	<if @email_addrs:rowcount@ gt 0>
		<table cellpadding="5" cellspacing="0" border="0" >
			<multiple name="email_addrs">
			<tr><th width="150" class="main-text-bold" align="right" valign="top">@email_addrs.type@:</th>
					<td class="main-text" align="left" valign="top"><a href="mailto:@email_addrs.email@">@email_addrs.email@</a></td>
				</tr>
			</multiple>
		</table>
	</if>

	<if @indirect_phones:rowcount@ gt 0>		<!-- Phone Numbers -->
		<table cellpadding="5" cellspacing="0" border="0">
			<multiple name="indirect_phones">
				<tr><th width="150" class="main-text-bold" align="right" valign="top">
						@indirect_phones.type@:
					</th>
					<td class="main-text" align="left" valign="top">
						<group column="type">
							<if @indirect_phones.format_phone_p@ ne 0>
								(@indirect_phones.area_code@)
								@indirect_phones.prefix@-@indirect_phones.suffix@
								<if @indirect_phones.description@ not nil>
									@indirect_phones.description@
								</if>
							</if>
							<else>
								@indirect_phones.phone_number@
								<if @indirect_phones.description@ not nil>
									(@indirect_phones.description@)
								</if>
							</else><br>
						</group>
					</td>
				</tr>
			</multiple>
		</table>
	</if>

	<if @addresses:rowcount@ gt 0>				<!-- Addresses -->
		<table cellpadding="5" cellspacing="0" border="0">
			<multiple name="addresses">
				<tr><th width="150" class="main-text-bold" align="right" valign="top">@addresses.type@: </th>
					<td class="main-text" valign="top" align="left">
					<if @addresses.description@ not nil>@addresses.description@<br></if>
					<if @addresses.address_line_1@ not nil>@addresses.address_line_1@</if>
					<if @addresses.address_line_2@ not nil><br>@addresses.address_line_2@</if>
					<if @addresses.address_line_3@ not nil><br>@addresses.address_line_3@</if>
					<if @addresses.address_line_4@ not nil><br>@addresses.address_line_4@</if>
					<if @addresses.address_line_5@ not nil><br>@addresses.address_line_5@</if>
					<if @addresses.citystate@ not nil><br>@addresses.citystate@</if>
					<if @addresses.country@ not nil><br>@addresses.country@</if>
					</td>
				</tr>
			</multiple>
		</table>
	</if>

	<if @url_info:rowcount@ gt 0>				<!-- URLs -->
		<table cellpadding="5" cellspacing="0" border="0">
			<multiple name="url_info">
				<tr><th width="150" class="main-text-bold" align="right" valign="top">@url_info.type@: </th>
					<td class="main-text" valign="top" align="left">
						<a href="@url_info.url@" target="_blank">@url_info.url@</a>
					</td>
				</tr>
			</multiple>
		</table>
	</if>

	<if @direct_contact_info_exists_p@>			<!-- DIRECT Contact Information -->
		<img src="@subsite_url@images/h-teal-pixel" width="100%" height="1"><br><br>
		<span class="secondary-header">Direct Contact Information:</span>
	</if>

	<if @phones:rowcount@ gt 0>					<!-- Phone Numbers -->
		<table cellpadding="5" cellspacing="0" border="0">
			<multiple name="phones">
				<tr><th width="150" class="main-text-bold" align="right" valign="top">
						@phones.type@:
					</th>
					<td class="main-text" align="left" valign="top">
						<group column="type">
							<if @phones.format_phone_p@ ne 0>
								(@phones.area_code@)
								@phones.prefix@-@phones.suffix@
								<if @phones.description@ not nil>
									@phones.description@
								</if>
							</if>
							<else>
								@phones.phone_number@
								<if @phones.description@ not nil>
									@phones.description@
								</if>
							</else><br>
						</group>
					</td>
				</tr>
			</multiple>
		</table>
	</if>

	<img src="@subsite_url@images/h-teal-pixel" width="100%" height="1"><br><br>

	<if @research_interest@ not nil>
		<span class="secondary-header">Research Interest:</span>
		<table cellpadding="5" cellspacing="0" border="0">
			<tr><td>
			<if @research_interest_title@ not nil>
				@research_interest_title@
				<br><br>
			</if>
			@research_interest@
			</td></tr>
		</table>
		<br><br>
	</if>

	<if @technical_research_interest@ not nil>
		<span class="secondary-header">Technical Research Interest:</span>
		<table cellpadding="5" cellspacing="0" border="0">
			<tr><td>
			<if @technical_research_interest_title@ not nil>
				@technical_research_interest_title@
				<br><br>
			</if>
			@technical_research_interest@
			</td></tr>
		</table>
		<br><br>
	</if>

	<if @bio@ not nil>
		<div style="margin-bottom: 1em" class="secondary-header">
			Additional Information:
		</div>
		<div style="padding: 5px; margin-bottom: 1em; text-align: top">
			@bio@
		</div>
	</if>
	<include src="publications" &="personnel_id">
	</td>
</tr>
</table>
