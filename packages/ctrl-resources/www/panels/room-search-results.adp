<!--remove to other pages-->
<multiple name="get_rooms">
  <if @get_rooms:rowcount@ gt 0 and @get_rooms.rownum@ eq 1>  
   Here are the rooms that matched your criteria exactly:
   <fieldset>  <legend> <b> Matched Rooms </b> </legend> 
     <table>
       <tr> <td> <b> Room Name </b> </td>
            <td> <b> Description </b> </td>
	    <td> <b> Capacity </b></td>
	    <!--<td> <b> Floor  </b> </td>-->
	    <!--<td> <b> Extra Services  </b> </td>-->
	    <td> <b> <nobr>Approval needed?</nobr>  </b> </td>
	    <td> <b> Options  </b> </td>
       </tr>
  </if>
  


  <if @get_rooms.rownum@ odd>
    <tr bgcolor=#eeeeee>
  </if>

  <if @get_rooms.rownum@ even>
    <tr bgcolor=#ffffff>
  </if>   


            <td> @get_rooms.name@  </td>
            <td> @get_rooms.description@ </td>
	    <td> @get_rooms.capacity@  </td>
	    <!--<td> @get_rooms.floor@  </td>-->
	    <!--<td> @get_rooms.services@  </td>-->
	    <td> <if @get_rooms.approval_required_p@ eq t>Yes</if><else>No</else> </td>
	    <td> <a href=@get_rooms.details_url@> See Details and Reserve </a></td>
       </tr>
         

  <if @get_rooms:rowcount@ eq @get_rooms.rownum@>
     </table>
     </fieldset>
  </if>

</multiple>

<if @get_rooms:rowcount@ eq 0>
         <font color="red"><b>We currently do not have any other rooms that exactly matches your criteria. </b></font>
</if>

<br>
<br>
<if @show_recommendations@ eq 1>
 <multiple name="get_rooms_no_amenities">
  <if @get_rooms_no_amenities:rowcount@ gt 0 and @get_rooms_no_amenities.rownum@ eq 1>  
<!--      The following is a list of other rooms.  They satisify all of your criteria except the equipments.  -->
     <fieldset>  <legend> <b><font color="red">Below are other rooms that matches your criteria except for equipment.   </font></b> </legend> 
     <table width="100%" cellpadding="4" cellspacing="4">
       <tr bgcolor="#aaaaaa"> <th> <b> Room Name </b> </th>
            <!--<td> <b> Description </b> </td>-->
	    <th> <b> Capacity </b></th>
	    <th> <b> Floor  </b> </th>
	    <th> <b> Extra Services  </b> </th>
	    <th> <b> <nobr>Approval needed?</nobr>  </b> </th>
	    <th> <b> Options  </b> </th>
       </tr>
  </if>
  


  <if @get_rooms_no_amenities.rownum@ odd>
    <tr bgcolor=#eeeeee>
  </if>

  <if @get_rooms_no_amenities.rownum@ even>
    <tr bgcolor=#ffffff>
  </if>   


            <td> @get_rooms_no_amenities.name@  </td>
            <!--<td> @get_rooms_no_amenities.description@ </td>-->
	    <td align="center"> @get_rooms_no_amenities.capacity@  </td>
	    <td align="center"> @get_rooms_no_amenities.floor@  </td>
	    <td align="center"> @get_rooms_no_amenities.services@  </td>
	    <td align="center"> <if @get_rooms_no_amenities.approval_required_p@ eq t>Yes</if><else>No</else> </td>
	    <td align="center"> <a href=@get_rooms_no_amenities.details_url@> See Details and Reserve </a></td>
       </tr>
         

  <if @get_rooms_no_amenities:rowcount@ eq @get_rooms_no_amenities.rownum@>
     </table>
     </fieldset>
  </if>
 </multiple>

</if>
<br/><br/>
