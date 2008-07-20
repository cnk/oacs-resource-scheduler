<master>
<property name="title">Core Facilities</property>

<include src="/packages/shared/www/templates/links-page-begin"
		section_title_image="core-facilities-v-title.gif">
	<include src="/packages/shared/www/templates/links-info-column-begin"
			image="@subsite_url@images/section-main-images/research-cores-main1.jpg"
			width="253"
			height="170"><span class="main-text">
			The Core Facilities, commonly referred to as "Cores" are an integral and vital part of everyday life here at UCLA. These facilities provide investigators, students and staff from the School of Medicine and throughout Campus access to resources that could be unaffordable or beyond reach. The School of Medicine Dean's Office has made a firm commitment to the success and expansion of these facilities. School of Medicine Cores are invaluable to those who use them and they are also a valuable recruitment tool for new faculty who view these resources as part of the benefits of being here at UCLA. Here you will find a complete picture of these services and information on how to make them available to you.
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br></span>
	<include src="/packages/shared/www/templates/links-info-column-end">

	<include src="/packages/shared/www/templates/links-begin">
		<multiple name="core_groups">
			<include src="/packages/shared/www/templates/links-section-label"
					label="@core_groups.parent_group_name@">
			<group column="parent_group_name">
				<include src="/packages/shared/www/templates/links-link"
						text="@core_groups.group_name@"
						href="@core_groups.detail_url@">
			</group>
			<tr><td><br><!-- SPACER --></td></tr>
		</multiple>

	<include src="/packages/shared/www/templates/links-end">
<include src="/packages/shared/www/templates/links-page-end">
