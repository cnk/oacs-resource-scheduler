<master>
<property name="context_bar">@context_bar@</property>
<property name="title">@title@</property>

 <div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px"> 

<formtemplate id="search_publication">
	<table class="layout" width="100%" >
		<tr><td colspan="100%" align="center">
			<span class="bluebold">
				Select Publication that match <formwidget id="combine_method"/>of
					the criteria below.</span><br><br></td>
		</tr>
		<tr><td colspan="100%" align="center">@letter_index@<br><br></th></tr>
		</table>

	<table width="100%" border="0" cellpadding="2" cellspacing="2">
		<tr><th class="secondary-header" align="right"><nobr>Title:</nobr></th>
			<td class="data-io"><formwidget id="title"/></td>
		</tr>
		<tr><th class="secondary-header" align="right"><nobr>Publication Name:</nobr></th>
			<td class="data-io"><formwidget id="publication_name"/></td>
		</tr>
		<tr><th class="secondary-header" align="right"><nobr>URL:</nobr></th>
			<td class="data-io"><formwidget id="url"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Author:</nobr></th>
			<td class="data-io"><formwidget id="authors"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Volume:</nobr></th>
			<td class="data-io"><formwidget id="volume"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Issue:</nobr></th>
			<td class="data-io"><formwidget id="issue"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Page Range(s):</nobr></th>
			<td class="data-io"><formwidget id="page_ranges"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Year:</nobr></th>
			<td class="data-io"><formwidget id="year"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Publish Date:</nobr></th>
			<td class="data-io"><formwidget id="publish_date"/></td>
		</tr>

		<if @publication_search_p@ eq 1>
		
		<tr><th class="secondary-header" align="right"><nobr>Creation Date:</nobr></th>
			<td class="data-io"><formwidget id="creation_date"/></td>
		</tr>

		<tr><th class="secondary-header" align="right"><nobr>Date Last Modified:</nobr></th>
			<td class="data-io"><formwidget id="last_modified"/></td>
		</tr>
		
		</if>

		<tr><td/><td align="left">
			<br><formwidget id="search"/><br><br></td>
		</tr>		
		
	</table>
</formtemplate>
</div>
