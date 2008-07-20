<link rel="stylesheet" href="../cnsi-forms.css">
<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px"> 

<if @pag_bool@ eq 1>
	<table><tr><td align=left>@nav_bar@ </td></tr></table>
</if>

<table width=645 border="1" cellspacing="2" cellpadding="5" bgcolor="#ffffff">
	<if @pag_bool@ eq 0 and @results2:rowcount@ lt 1>
	 <tr><td> No Results</td><tr>
	</if>	
	<if @pag_bool@ eq 1 and @results:rowcount@ lt 1>
	 <tr><td> No Results</td><tr>
	</if>
	<else>
	<tr>
    	 <td class="label-shaded" valign="top"><center>USERS</td>
    	 <td class="label-shaded" valign="top"><center>Status</td>
    	 <td class="label-shaded" valign="top"><center>Action</td>
	</tr>
	</else>
	
	<if @pag_bool@ eq 1>
	<multiple name="results">
	 <if @results.row_counter@ ge @first_number@ and @results.row_counter@ le @last_number@>
	  <tr>
	   <if @results.personnel_p@ lt 1> 
	    <td class="value-shaded" valign="top"><a href="@link@personnel_id=@results.user_id@">@results.first_names@ @results.last_name@</a></td>
	    <td class="value-shaded" valign="top">THIS USER IS NOT A PERSONNEL</td>
	    <td class="value-shaded" valign="center"><nobr>
 	     <a href="@link@personnel_id=@results.user_id@">View</a></nobr>
	    </td>
	   </if>
	   <else>
	    <td valign="top">@results.first_names@ @results.last_name@</td>
	    <td valign="top">THIS USER IS ALREADY A PERSONNEL</td>
	    <td valign="top">-----</td>
	   </else>
	  </tr>
	 </if>
	</multiple>
	</if>

	<else>
	<multiple name="results2">
	<tr>
	 <if @results2.personnel_p@ lt 1> 
	  <td><a href="@link@personnel_id=@results2.user_id@"> @results2.first_names@ @results2.last_name@ </a></td>
	  <td> THIS USER IS NOT A PERSONNEL </td>
	 </if>
	 <else>
	  <td> @results2.first_names@ @results2.last_name@ </td>
	  <td> THIS USER IS ALREADY A PERSONNEL </td>
	 </else>
	</tr>
	</multiple>
	</else>

</table>
</div>
