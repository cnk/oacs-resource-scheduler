<table cellspacing="5" cellpadding="0" border="0" width="100%">
<if 0><!-- !!!! WARNING: complex ADP-foo past this point! :WARNING !!!! --></if>
	<% set last_title_id 0 %>
	<multiple name="titles">
		<tr><td><span class="secondary-header">
				@titles.group_affiliation_type@
			</span>
			<group column="group_affiliation_type">
				<if @titles.pretty_title@ not nil>
					<% set last_title_id 0 %>
					</td></tr><tr><td><!-- NEXT ROW -->
					<span class="main-text-bold">
						@titles.pretty_title@,
					</span>
					<span class="main-text">
					<if @titles.hospital_p@>@titles.group_name@</if>
					<else><a href="@titles.group_url@">@titles.group_name@</a></else>
					</span>
				</if>
				<else>
					<if @titles.hospital_p@>
						</td></tr><tr><td><!-- NEXT ROW -->
						<span class="main-text-bold">
							@titles.group_name@
						</span>
					</if>
					<else>
						<if @last_title_id@ ne @titles.title_id@>
							</td></tr><tr><td><!-- NEXT ROW -->
							<span class="main-text-bold">
								<group column="group_id">
									<% set last_title_id $titles(title_id) %>
									<if @titles.groupnum@ gt 1>
										<if @titles.groupnum_last_p@>
											<% set last_title_id 0 %>
											</span>and<span class="main-text-bold">
										</if>
										<else>, </else>
									</if>
									@titles.title@</group>,
							</span>
							<span class="main-text">
								<a href="@titles.group_url@">
									@titles.group_name@</a></span></if><else>,
						<!-- /if, else -->
							<span class="main-text">
								<a href="@titles.group_url@">
									@titles.group_name@</a></span></else></else></else></group>
						<!-- /else -->
					<!-- /else -->
				<!-- /else -->
			</td>
		</tr>
	</multiple>
<if 0><!-- !!!!!!!!!!!!!!!! END: complex ADP-foo :END !!!!!!!!!!!!!!!! --></if>
</table>
