<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master src="/packages/shared/www/templates/physician-finder-master">
<property name="personnel_id">@personnel_id@</property>
<property name="title">UCLA Physician @first_names@ @last_name@@degree_titles@</property>
<property name="show_right_nav_p">0</property>

<!-- ---------------------------Add Body Content Here------------------- -->
<table border="0">
	<if @redirect_p@>
		<tr><td valign="top">
		<span class="secondary-header">If <b>@first_names@ @last_name@</b> is your physician and you wish to receive
		information pertaining to @gender@, please contact <nobr>1-800-UCLA-MD1 (1-800-825-2631). Thank you.</span>
		<br><br><br><br><br><br><br><br><br>
			</td>
		</tr>
	</if>
	<else>
		<tr><td valign="top">
				<include src="personnel-template2"
					&="personnel_id"
					display_page="physician">
			</td>
		</tr>

		<if @marketable_p@>
			<tr><td valign="top">
					<include src="physician-template">
				</td>
			</tr>
		</if>
	</else>
</table>
<!-- --------------------------End Body Content Here-------------------- -->
