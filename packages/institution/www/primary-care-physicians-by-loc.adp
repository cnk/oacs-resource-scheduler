<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master src="/packages/shared/www/templates/physician-finder-master">
<property name="title">@title@</property>

<!-- ---------------------------Add Body Content Here------------------- -->
<table class="layout" width="100%">
	<tr><td valign="top" class="main-text" colspan="2">
		The following is a list of UCLA Medical Group Primary Care Physicians.
		<p>A <img width="15px" src="@subsite_url@images/red-check"/>
			indicates that a physician is accepting new managed care (HMO) patients.</p>
		<p>Physician availability is subject to change.  Please call the
			physician's office directly to confirm.</p>
		</td>
	<tr>
	<tr><td class="layout">&nbsp;</td></tr>

	<tr valign="top">
		<td align="left"><table class="layout">

	<% set not_divided_p 1 %>
	<multiple name="pcps">
		<!-- Name of the location and the office -->
		<tr><td colspan="2" class="main-text-bold">
				<if @pcps.rownum@ gt 0><br></if>
				<a href="groups-detail?group_id=@pcps.location_id@">@pcps.location_name@</a>:
			</td>
		</tr><% set rowcount_div_2 [expr $rowcount_div_2 - 0.5] %><!-- only decrement 1/2 of the time -->

		<group column="location_name">
			<tr><td colspan="2" class="main-text-bold" style="padding-left: 1em">
					<a href="groups-detail?group_id=@pcps.group_id@">@pcps.group_name@</a>:
				</td>
			</tr><% set rowcount_div_2 [expr $rowcount_div_2 - 0.5] %><!-- only decrement 1/2 of the time -->

			<!-- Physician -->
			<group column="group_name">

				<!-- Make a new column if we have surpassed the half-way point -->
				<if @pcps.rownum@ gt @rowcount_div_2@ and @not_divided_p@>
					</table>
					</td><td align="right">
					<table class="layout">

					<% set not_divided_p 0 %>

					<!-- //TODO// if next-pco == current, don't re-display pco or location -->
					<!-- //TODO// if next-location == current, don't re-display location -->
					<tr><td colspan="2" class="main-text-bold">
							<if @pcps.rownum@ gt 0><br></if>
							<a href="groups-detail?group_id=@pcps.location_id@">@pcps.location_name@</a>:
						</td>
					</tr>
					<tr><td colspan="2" class="main-text-bold" style="padding-left: 1em">
							<a href="groups-detail?group_id=@pcps.group_id@">@pcps.group_name@</a>:
							<small><br>(continued)</small>
						</td>
					</tr>
				</if>

				<if @pcps.rownum@ odd>
					<tr bgcolor="#CBDBEC"></if>
				<else><tr bgcolor="#FFFFFF"></else>
					<td valign="middle" bgcolor="#FFFFFF" align="right">
						<if @pcps.accepting_new_hmo_p@>
							<img width="15px" src="@subsite_url@images/red-check"/>
						</if>
					</td>
					<td><a class="long-link" href="@pcps.detail_url@">
							@pcps.last_name@, @pcps.first_names@ @pcps.degree_titles@
						</a>
					</td>
				</tr>
			</group>
		</group>
	</multiple>

			</table>
		</td>
	</tr>
</table>
<!-- --------------------------End Body Content Here-------------------- -->
