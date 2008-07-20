<master>
<if @sttp_selection:rowcount@ ne 0>
<table class="trn_listing" width=100%>
<tr class="trn_th_alt">
    <th>&nbsp;</th>
    <th>Position</th>
    <th>
       <if @order_by@ eq "short_name">
         <if @order_dir@ eq "asc">
    		<a href="index?order_by=short_name&order_dir=desc">Department</a>
         </if>
         <else>
    		<a href="index?order_by=short_name&order_dir=asc">Department</a>
         </else>
       </if>
       <else>
              <a href="index?order_by=short_name">Department</a>
       </else>
    </th>
    <th>
	<if @order_by@ eq last_name>
	   <if @order_dir@ eq desc>
	   <a href="index?order_by=last_name&order_dir=asc">Name</a>
	   </if>
	   <else>
	   <a href="index?order_by=last_name&order_dir=desc">Name</a>
	   </else>
	</if>
	<else>
	   <a href="index?order_by=last_name&order_dir=asc">Name</a>
	</else>
	</b>
    </th>
    <th>Action</th>
    </tr>
<multiple name="sttp_selection">
        <!-- output leading space and expand/collapse widget -->
        <if @sttp_selection.rownum@ odd>
            <tr bgcolor="#CBDBEC"></if>
        <else><tr bgcolor="#FFFFFF"></else>
	<td>[<a href="detail?request_id=@sttp_selection.request_id@&personnel_id=@sttp_selection.personnel_id@">Detail</a>]</td>
	<td><if @sttp_selection.n_requested@ eq @sttp_selection.n_received@>Closed</if>
	    <else>Open</else></td>
	<td>@sttp_selection.short_name@</td>
	<td>@sttp_selection.last_name@, @sttp_selection.first_names@</td>
	<td>[<a href="@sttp_edit@?personnel_id=@sttp_selection.personnel_id@&request_id=@sttp_selection.request_id@&title_p=2">Edit</a>]::[<a href="@sttp_delete@?personnel_id=@sttp_selection.personnel_id@&request_id=@sttp_selection.request_id@&title_p=3">Delete</a>]</td>
    </tr>
</multiple>
</if>
<else>
<h2>No mentor recruitment listing is available for summer 2005 at this time!</h2>
</else>
<if @admin_url@ not nil>
<tr>
  <td colspan=4><br><ul>
	<li><a href="@sttp_add@">Add STTP Mentorship</a></li>
	<li><a href="@admin_url@">Change Poster Session Date</a></li>
  </ul>
  </td>
</tr>
</if>
</table>
