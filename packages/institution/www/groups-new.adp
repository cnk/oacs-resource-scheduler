<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<if @subsite_url@ ne "/healthsciences/dgsom/">

</if>
<property name="title">@title@</property>
<property name="context">@context@</property>

<table width="588" border="0" cellspacing="0" cellpadding="0">
 <tr> 
  <td width="253" align="left" valign="top">
			<img src="/images/links-pages-main/departments-main1.jpg"
				width="253"
				height="170"><br>
				<img src="/images/spacer.gif" width="253" height="5"><br>
         <div style="padding: 5px;">
			<if @subsite_url@ eq "/healthsciences/healthcare/">
			<font class="secondary-header">Departments</font>
				<p>At UCLA, medical services are organized by the academic departments of the David Geffen School of Medicine. <br><br>
				Medical programs can be located by choosing the appropriate department from this list.</p>
			</if>
			<else>
			<font class="secondary-header">Departments</font>
			</else>
		</div>

  <td width="1" align="left" valign="top" bgcolor="#536895">
         <img src="/shared/styleimgs/bluepixel.gif" width=1 height=400> 
  </td>
  <td width="334" style="padding: 5px;" align="left" valign="top">
        <table id="standard" width=90%>
		<if @subsite_url@ ne "/healthsciences/healthcare/mattel/">
			<if @subsite_url@ eq "/healthsciences/healthcare/">
				<include src="/packages/shared/www/templates/links-section-label"
						label="Clinical Departments">
				<tr><td colspan="2" style="padding-left: 1.5em">
						<include src="list" type="Clinical Department" subsite_only_p="1">
						<br>
					</td>
				</tr>
				<include src="/packages/shared/www/templates/links-section-label"
						label="Labs, Institutes and Centers">
				<tr><td colspan="2" style="padding-left: 1.5em">
						<include src="list" base_url="@package_url@" 	 type="Institute or Center" subsite_only_p="1">
						<br>
					</td>
				</tr>
				<include src="/packages/shared/www/templates/links-section-label"
						label="Basic Science">
				<tr><td colspan="2" style="padding-left: 1.5em">
						<include src="list" base_url="@package_url@" 	type="Basic Science" subsite_only_p="1">
			</if>
			<else>
				<include src="/packages/shared/www/templates/links-section-label"
						label="Basic Science">
				<tr><td colspan="2" style="padding-left: 1.5em">
						<include src="list" base_url="@package_url@" 	type="Basic Science" subsite_only_p="1">
						<br>
					</td>
				</tr>
				<include src="/packages/shared/www/templates/links-section-label"
						label="Clinical Departments">
				<tr><td colspan="2" style="padding-left: 1.5em">
					<include src="list" base_url="@package_url@"  type="Clinical Department" subsite_only_p="1">
						<br>
					</td>
				</tr>
				<include src="/packages/shared/www/templates/links-section-label"
						label="Labs, Institutes and Centers">
				<tr><td colspan="2" style="padding-left: 1.5em">
						<include src="list" base_url="@package_url@" 	type="Institute or Center" subsite_only_p="1">
			</else>
		</if>
		<else>
			<!-- Mattel -->
			<include src="/packages/shared/www/templates/links-section-label"
					label="Divisions">
			<tr><td colspan="2" style="padding-left: 1.5em">
				<include src="list" absolute_url="@package_url@groups-detail"  type="Division" subsite_only_p="1">
		</else>

				<br><br>
			</td>
		</tr>
      </table>

  </td>
  </tr>
</table>
