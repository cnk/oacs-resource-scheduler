<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>

<table width="575" border="0" cellpadding="0" cellspacing="0">
	<tr><td colspan="3" width="575" valign="top" bgcolor="#999999">
			<img src="/images/greypixel.gif" width="575" height="1" border="0">
		</td>
	</tr>
	<tr><td width="1" valign="top" bgcolor="#999999">
			<img src="/images/greypixel.gif" width="1" height="1" border="0">
		</td>
		<td width="573" valign="top" bgcolor="#FFFFFF" align="left">
			<table width="573" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffcc33">
				<tr><td><img src="/images/spacer.gif" width="573" height="10">
					</td>
				</tr>
				<tr><td valign="middle" align="center">
						<h3>A-Z Directory</h3>
					</td>
				</tr>
				<tr><td><img src="/images/spacer.gif" width="573" height="10">
					</td>
				</tr>
			</table>

			<blockquote>
				<center>@letter_index_list@</center>
				<table width="100%">
					<tr><td><div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">
<!-- ---------------------------Add Body Content Here------------------- -->
	<table align="center" border="0" cellpadding="2" cellspacing="2">
		<tr><td><table class="layout" width="100%" border="0">
					<tr><td valign="top">
						<multiple name="personnel">
							<if @personnel.last_name_initial@ eq @middle_letter_index@>
							   </td><td valign="top">
							</if>
							<group column="last_name_initial">
								<if @personnel.groupnum@ eq 1>
									<a name="@personnel.last_name_initial@">
									</a>
									<span class="secondary-header">
										@personnel.last_name_initial@
									</span>
									<br>
								</if>
								<a href="@personnel.detail_url@">
									@personnel.last_name@,
									@personnel.first_names@
									@personnel.degree_titles@
								</a>
								<br>
							</group>
							<br>
						</multiple>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br>
<!-- --------------------------End Body Content Here-------------------- -->
							</div>

						</td>
					</tr>
				</table>

				<center>@letter_index_list@</center>
			</blockquote>
		</td>
		<td width="1" valign="top" bgcolor="#999999">
			<img src="/images/greypixel.gif" width="1" height="1" border="0">
		</td>
	</tr>
</table>
