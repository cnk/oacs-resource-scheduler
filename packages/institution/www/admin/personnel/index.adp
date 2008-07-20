<master>
<property name="title">@title@</property>

<table width="100%">
<tr>
<td>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">

<!-- ---------------------------Add Body Content Here------------------- -->
<formtemplate id="search">
<p>
	<table class="layout" width="100%">

		<tr><td colspan="100%" align="left">
		<span class="primary-header">Find a person by choosing from the following search options.</span><br><br>
		</td></tr>
		<tr><td colspan="100%"><img src="@subsite_url@images/h-teal-pixel.gif" width="95%" height="1"><br><br></td>

		<tr><td colspan="100%">
			<font class="secondary-header">
				Select personnel that match <formwidget id="combine_method"/>of the criteria below.</font><br><br></td>
		</tr>
		</table>
	<table>
		<tr><td/><td/></tr> <!-- magic row to shrink left-most column -->

	    <tr><td class="main-text-bold" align="right">
			First Name:</td><td>
			<formwidget id="fn_cond"/><formwidget id="search_first_name"/><br>
		</tr>
		<tr><td class="main-text-bold" align="right"> 
			Last Name:</td><td>
			<formwidget id="ln_cond"/><formwidget id="search_last_name"/><br>
		</tr>
		<tr>
		    <td align="right" class="main-text-bold">
			Keyword:</td><td>
			<formwidget id="search_keyword"/></td>
		</tr>
		<tr><td class="main-text-bold" align="right">
			Department/Division/...:</td><td>
			<formwidget id="group_id"/><br>
		</tr>
		<tr><td class="main-text-bold" align="right">
			Display Order:</td><td>
			<formwidget id="display"/></td>
		</tr>
		<tr><td>&nbsp;</td><td align="left">
			<br><formwidget id="search"/></td>
		</tr>
		<tr><td colspan="100%"><br><br><img src="@subsite_url@images/h-teal-pixel.gif" width="95%" height="1"></td>

	</table>
<br><br>
<table border="0" cellpadding="0" cellspacing="0"><tr><th class="secondary-header">Browse:&nbsp; </th><th>@letter_index@</td></tr></table><br>

<if @n_results@ defined>
	<if @n_results@ le 0>
		<b>No Personnel matched your search criteria.</b><br></if>
	<else>
	    <span class="secondary-header">
		<if @n_results@ gt 1>Showing @n_results@ matching personnel</if>
		<else>Found 1 personnel matching your criteria.</else>
		</span>
		<br><br>
		<table border="0" cellpadding="2" cellspacing="2">
			<!-- Data --><tr><td><table class="layout" width="100%" border="0">
			<multiple name="found">
				<if @found.rownum@ odd>
					<tr bgcolor="#CBDBEC"></if>
				<else><tr bgcolor="#FFFFFF"></else>

				<!-- Name -->
				<td><a href="@found.detail_url@"><nobr>
						<if @display@ eq "first_names">@found.first_names@ @found.last_name@</if>
						<else>@found.last_name@, @found.first_names@</else>
						@found.degree_titles@
					</nobr>
					</a>
				</td>

				</tr>
			</multiple></table></td></tr>

		</table><br>

	</else>

</if>

</formtemplate>
</div>
<!-- --------------------------End Body Content Here-------------------- -->
</div>

</td>
</tr>
</table>
