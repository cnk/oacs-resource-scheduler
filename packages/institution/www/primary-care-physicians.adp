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
		<td align="left">
			<table class="layout">

				<% set not_divided_p 1 %>
				<multiple name="pcps">
					<tr><td colspan="2" class="main-text-bold">@pcps.specialty@</td></tr>
					<tr style="height: 0px"><td style="width: 1em" /></tr>

					<% set rowcount_div_2 [expr $rowcount_div_2 - 0.5] %><!-- only decrement 1/2 of the time -->
					<group column="specialty">
						<!-- next column -->
						<if @pcps.rownum@ gt @rowcount_div_2@ and @not_divided_p@>
							<% set not_divided_p 0 %>
								</table>
							</td>
							<td align="right" valign="top">
								<table class="layout">
									<tr><td colspan="2" class="main-text-bold">
											@pcps.specialty@<small><br>(continued)</small>
										</td>
									</tr>
									<tr style="height: 0px"><td style="width: 1em" /></tr>
						</if>

						<!-- Active Primary Care Physicians -->
						<if @pcps.rownum@ odd>
							<tr bgcolor="#CBDBEC"></if>
						<else><tr bgcolor="#FFFFFF"></else>
							<td valign="middle" bgcolor="#FFFFFF">
								<if @pcps.accepting_new_hmo_p@>
									<img width="15px" src="@subsite_url@images/red-check" />
								</if>
							</td>
							<td><a href="@pcps.detail_url@">
									@pcps.last_name@, @pcps.first_names@ @pcps.degree_titles@
								</a>
							</td>
						</tr>
					</group>

					<tr><td>&nbsp;</td></tr>
				</multiple>

			</table>
		</td>
	</tr>
</table>
<!-- --------------------------End Body Content Here-------------------- -->
