<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px"> 

<h3> @title@ </h3>
<br>

<if @pag_bool@ eq 1>
	<table><tr><td align=left>@nav_bar@ </td></tr></table>
</if>
<table cellpadding=5 cellspacing=0 frame=box border=1>
	<if @pag_bool@ eq 0 and @results2:rowcount@ lt 1> <tr><td> No Results</td><tr></if>	
	<if @pag_bool@ eq 1 and @results:rowcount@ lt 1> <tr><td> No Results</td><tr></if>
	<else><tr><th class="secondary-header"> Personnel </th> </tr></else>
	<if @pag_bool@ eq 1>
		<multiple name="results">
		<if @results.row_counter@ ge @first_number@ and @results.row_counter@ le @last_number@>
			<tr>
			<td><a href="@link@personnel_id=@results.personnel_id@"> @results.first_names@ @results.last_name@ </a></td> 

		<if @personnel_search_p@ eq 1 and @personnel_edit@ eq 1>
			<td> 
				( <a href="@subsite_url@institution/admin/personnel/personnel-group-delete?personnel_id=@results.personnel_id@&group_id=@group_id@"> Unassociate </a> / 
				<a href="@subsite_url@institution/admin/personnel/personnel-ae?personnel_id=@results.personnel_id@"> Edit </a> / 
				<a href="@subsite_url@institution/admin/personnel/personnel-delete?personnel_id=@results.personnel_id@&return_addr=@return_addr@"> Delete </a> ) 
			</td>
		</if>
		<if @personnel_search_p@ eq 1 and @personnel_edit@ ne 1>
			<td> 
				( <a href="@subsite_url@institution/admin/personnel/personnel-group-delete?personnel_id=@results.personnel_id@&group_id=@group_id@"> Unassociate </a> / 
				<a href="@subsite_url@institution/admin/personnel/personnel-delete?personnel_id=@results.personnel_id@&return_addr=@return_addr@"> Delete </a> ) 
			</td>
		</if>
		<if @personnel_edit@ eq 1 and @personnel_search_p@ ne 1>
			<td> 
				( <a href="@subsite_url@institution/admin/personnel/personnel-ae?personnel_id=@results.personnel_id@"> Edit </a> / 
				<a href="@subsite_url@institution/admin/personnel/personnel-delete?personnel_id=@results.personnel_id@&return_addr=@return_addr@"> Delete </a> ) 
			</td>
		</if>
		</tr>	
		</if>
		</multiple>
	</if>
		<else>
		<multiple name="results2">
			<tr>
			<td><a href="@link@personnel_id=@results2.personnel_id@"> @results2.first_names@ @results2.last_name@ </a></td> 
			<if @personnel_search_p@ eq 1 and @personnel_edit@ eq 1>
				<td> ( <a href="@subsite_url@institution/admin/personnel/personnel-group-delete?personnel_id=@results2.personnel_id@&group_id=@group_id@"> Unassociate </a> / <a href="@subsite_url@institution/admin/personnel/personnel-delete?personnel_id=@results2.personnel_id@&return_addr=@return_addr@"> Delete </a> / <a href="@subsite_url@institution/personnel/personnel-ae?personnel_id=@results2.personnel_id@"> Edit </a> ) </td>
			</if>
			<if @personnel_search_p@ eq 1 and @personnel_edit@ ne 1>
				<td> ( <a href="@subsite_url@institution/admin/personnel/personnel-group-delete?personnel_id=@results2.personnel_id@&group_id=@group_id@"> Unassociate </a> / <a href="@subsite_url@institution/admin/personnel/personnel-delete?personnel_id=@results2.personnel_id@&return_addr=@return_addr@"> Delete </a> ) </td>
			</if>
		<if @personnel_edit@ eq 1 and @personnel_search_p@ ne 1>
			<td> ( <a href="@subsite_url@institution/admin/personnel/personnel-ae?personnel_id=@results2.personnel_id@"> Edit </a> / <a href="@subsite_url@institution/admin/personnel/personnel-delete?personnel_id=@results2.personnel_id@&return_addr=@return_addr@"> Delete </a> ) </td>
		</if>
		</tr>
		</multiple>
	</else>
</table>
        </div>
