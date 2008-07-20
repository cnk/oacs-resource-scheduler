<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffcc99">
				<span class="primary-header">@title@</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#publications">Don't Save &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

<p><h3><if @user_id@ eq @personnel_id@>
		Your
	</if><else>
		@personnel_name@'s
	</else> profile may be shown on several websites.</h3>

For each website, you can choose a set of publications to show and an order to show
them in.
</p>

<p> <h3 style="color: maroon; display: inline">Choose the website</h3> that you wish
	to arrange publications for:
	<if @personnel_subsite_list:rowcount@ gt 0>
		<blockquote>
			<multiple name="personnel_subsite_list">
				<a href="@personnel_subsite_list.select_subsite_url@">
					@personnel_subsite_list.subsite_name@
				</a>
				<if @this_subsite_id@ eq @personnel_subsite_list.subsite_id@>
					<b style="color: maroon">*</b>
				</if>
				<if @personnel_subsite_list.n_arranged_for_subsite@ gt 0>
					<small><b>
						<a	href="@personnel_subsite_list.reset_arrangement_url@"
							title="Click to reset this arrangement of @personnel_subsite_list.n_arranged_for_subsite@ publications to the default"
							><font color="red">
								( reset
								<if @personnel_subsite_list.rownum@ ne 1>
									to <i>Default</i>
								</if> )
							</font></a>
						</b>
					</small>
				</if>
				<br>
			</multiple>
		</blockquote>
	</if><else>
		<i>None</i>
	</else>
</p>
<p><b style="color: maroon">*</b> This website.</p>
