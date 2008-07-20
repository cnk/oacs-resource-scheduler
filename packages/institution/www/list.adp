<if @group_list_view:rowcount@ defined>

<table align="center" width="100%">
	<multiple name="group_list_view">
		<!-- output leading space and expand/collapse widget -->
		<if @group_list_view.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

			<!-- output group title/name row(@group_list_view.rownum@) -->
			<td class="main-text" valign="top">
				<a	class="long-link"
					href="@group_list_view.detail_url@">
						@group_list_view.name@
				</a>
			</td>
		</tr>
	</multiple>
</table>

</if>
