<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px"> 
<span class="primary-header">Institution Admin: @title@</span>
<br><br>

<if @pag_bool@ eq 1>
	<table><tr><td align=left>@nav_bar@ </td></tr></table>
</if>
<table cellpadding=5 cellspacing=0 frame=box border=1>
	<if @pag_bool@ eq 1 and @results:rowcount@ lt 1> <tr><td> No Results</td><tr></if>
	<if @pag_bool@ eq 0 and @results2:rowcount@ lt 1> <tr><td> No Results</td><tr></if>
	<else><tr><th class="secondary-header"> Publication </th> <th class="secondary-header"> Author(s) </th> <th class="secondary-header">Action</th></tr>
	</else>
	<if @pag_bool@ eq 1>
		<multiple name="results">
		<if @results.row_counter@ ge @first_number@ and @results.row_counter@ le @last_number@>
		<tr>
			<td><a href="@link@publication_id=@results.publication_id@"> @results.pub_title@ </a> </td>
			<td> @results.pub_authors@ </td>
			<if @publication_edit@ eq 1>
				<td> ( <a href=./publication-ae?publication_id=@results.publication_id@&personnel_id=0>Edit</a> / <a href=./publication-delete?publication_id=@results.publication_id@>Delete</a> ) </td>
			</if>
		</tr></if>
		</multiple>
	</if>
	<else>
		<multiple name="results2">
		<tr>
			<td><a href="@link@publication_id=@results2.publication_id@"> @results2.pub_title@ </a> </td>
			<td> @results2.pub_authors@ </td>
			<if @publication_edit@ eq 1>
				<td> ( <a href=./publication-ae?publication_id=@results2.publication_id@&personnel_id=0>Edit</a> / <a href=./publication-delete?publication_id=@results2.publication_id@>Delete</a> ) </td>
			</if>
		</tr>
		</multiple>
	</else>
</table>
</div>
