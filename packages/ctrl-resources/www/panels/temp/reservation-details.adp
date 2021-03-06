<formtemplate id="update">

<multiple name="get_events">
     <if @get_events:rowcount@ gt 0 and @get_events.rownum@ eq 1>  
       <fieldset> <legend> Main Inforomation:</legend>
         <table>
          <tr><td> <b> Request ID: </b> </td> <td> @get_events.request_id2@ </td> </tr>
          <tr><td> <b> Reserved By: </b> </td> <td> @get_events.reserved_by@ </td> </tr>
          <tr><td> <b> Date reservation was made: </b> </td> <td> @get_events.date_reserved@ </td> </tr>
        </table>
       </fieldset>
     </if>

     <if @get_events.rownum@ eq 2>
       <tr><td colspan=2>
       <b> Equipment(s) reserved for this room: </b>
       <ul>
    </if>

   <if @get_events.room_p@> 
   <fieldset> <legend> Room: @get_events.object_name@ </legend>
     <table>
         <tr><td> <b> Title: </b> </td> <td> @get_events.title@ </td> </tr>
	 <tr><td> <b> Description: </b> </td> <td> @get_events.request_description@ </td> </tr>
	 <tr><td> <b> Additional Service: </b> </td> <td> @get_events.notes@ </td> </tr>
         <tr><td> <b> Event Code: </b> </td> <td> @get_events.event_code@ </td> </tr>
         <tr><td> <b> Date Reserved: </b> </td> <td> @get_events.sd@ to @get_events.ed@ </td> </tr>
         <tr><td> <b> Status: </b> </td> 
	    <td>
	      <if @update_status_p@ eq 1 and @request_id@ eq @get_events.request_id2@>
	        <formwidget id=request_status_@get_events.request_id2@>
        	<formwidget id="sub">
		<if @get_repeating_events:rowcount@ gt 0><formwidget id="update_all_p"></if>
	      </if>
	      <else>
	         @get_events.request_status@  
		 <if @write_p@ eq 1>(<a href=@get_events.status_update_url@> Update </a>)</if>
	      </else>
	     </td>
	 </tr>
         <tr><td> <b> Options: </b> </td> <td> <if @get_events.room_p@> 
                                               <if @write_p@ eq 1><a href=@get_events.edit_url@> Edit the request </a> </if>
					       <if @delete_p@ eq 1>| <a href=@get_events.delete_url@> Delete the request </a></if>
                                            </if>
	     </td> 
          </tr>
     </if>
     <else>
         <li>@get_events.object_name@ (<a href=@get_events.delete_url@> Remove this item </a>)</li>
     </else>
</multiple>

<if @get_events:rowcount@ gt 1>
</ul></td></tr>
</if>
</table>
</fieldset>

<!--repeating reservation-->
<if @get_repeating_events:rowcount@ gt 0>
<h3>Other Repeating Reservation</h3>
</if>

<multiple name="get_repeating_events">
<if @get_repeating_events:rowcount@ gt 0>
   <if @get_repeating_events.room_p@>

      <if @get_repeating_events.rownum@ gt 1>
         <if @get_repeating_events.request_item_count@ gt 1></ul></td></tr></if>
         </table></fieldset>
      </if>

   <fieldset> <legend> Room: @get_repeating_events.object_name@ </legend>
      <table>
         <tr><td> <b> Title: </b> </td> <td> @get_repeating_events.title@ </td> </tr>
         <tr><td> <b> Description: </b> </td> <td> @get_repeating_events.request_description@ </td> </tr>
         <tr><td> <b> Additional Service: </b> </td> <td> @get_repeating_events.notes@ </td> </tr>
         <tr><td> <b> Event Code: </b> </td> <td> @get_repeating_events.event_code@ </td> </tr>
         <tr><td> <b> Date Reserved: </b> </td> <td> @get_repeating_events.sd@ to @get_repeating_events.ed@ </td> </tr>
         <tr><td> <b> Status: </b> </td> 
	     <td><if @update_status_p@ eq 1 and @request_id@ eq @get_repeating_events.request_id2@>
	         <formwidget id=request_status_@request_id@ /> 
                 </if>
	         <else>
	           @get_repeating_events.request_status@  
		   <if @write_p@ eq 1>(<a href=@get_repeating_events.status_update_url@> Update </a>)</if>
	         </else>
	     </td>
	 </tr>
         <tr><td> <b> Options: </b> </td> <td> <if @get_repeating_events.room_p@> 
                                               <if @write_p@ eq 1><a href=@get_repeating_events.edit_url@> Edit the request </a> </if>
					       <if @delete_p@ eq 1>| <a href=@get_repeating_events.delete_url@> Delete the request </a></if>
                                               </if>
	                                  </td> 
         </tr>
	 <if @get_repeating_events.request_item_count@ gt 1>
           <tr><td colspan=2><b> Equipment(s) reserved for this room: </b><ul>
         </if>
   </if>
   <else>
         <li>@get_repeating_events.object_name@ (<a href=@get_repeating_events.delete_url@> Remove this item </a>)</li>
   </else>
</if>
</multiple>

<if @get_repeating_events:rowcount@ gt 0>
   <if @get_repeating_events.room_p@ ne 1>
      <if @get_repeating_events.request_item_count@ gt 1></ul></td></tr></if>
   </if>
   </table></fieldset>
</if>

</formtemplate>
