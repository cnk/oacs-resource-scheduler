<if @publications:rowcount@ ne 0>
	<table border="0">
		<tr><td valign="top">
				<span class="secondary-header">Publications:</span>
		</td><td>
</if>

<multiple name="publications">
	<div style="padding-bottom: 0.75em">
	@publications.authors@ @publications.title@.
	<if @publications.url@ nil>@publications.publication_name@</if>
	<else><a href="@publications.url@">@publications.publication_name@</a>.</else>
	@publications.year@; @publications.volume@<if @publications.issue@ not nil>(@publications.issue@)</if>
	<if @publications.volume@ not nil or @publications.issue@ not nil>:</if>
	@publications.page_ranges@.
	<br>
	<if @publications.edit_url@ not nil><a href="@publications.edit_url@">Edit</a></if>
	<if @publications.unmap_url@ not nil><a href="@publications.unmap_url@">Unassociate</a></if>
	<if @publications.download_url@ not nil><a href="@publications.download_url@">Download</a></if>
	</div>
</multiple>

<if @publications:rowcount@ ne 0>
		</td>
	</tr>
</table>
</if>
