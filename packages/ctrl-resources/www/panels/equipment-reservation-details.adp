<formtemplate id="update">
<multiple name="get_events">
    <if @get_events:rowcount@ gt 0 and @get_events.rownum@ eq 1>

       <fieldset> <legend> Main Inforomation:</legend>
         <table>
          <tr><td> <b> Request ID: </b> </td> <td> @get_events.request_id@ </td> </tr>
          <tr><td> <b> Reserved By: </b> </td> <td> @get_events.reserved_by@ </td> </tr>
          <tr><td> <b> Date reservation was made: </b> </td> <td> @get_events.date_reserved@ </td> </tr>
          <tr><td> <b> Date Reserved: </b> </td> <td> @get_events.start_date@ to @get_events.end_date@ </td> </tr>
        </table>
       </fieldset>
   <br /><br />
     </if>

<if @get_events.room_p@ le 0>
   <fieldset> <legend> Equipment: @get_events.object_name@ </legend>
     <table>
         <tr><td> <b> Title: </b> </td> <td> @get_events.title@ </td> </tr>
         <tr><td> <b> Event Code: </b> </td> <td> @get_events.event_code@ </td> </tr>
         <tr><td> <b> Status: </b> </td>
            <td>
              <if @update_status_p@ eq 1>
                <formwidget id=@get_events.widget_name@>
              </if>
              <else>
                 @get_events.status@  <if @write_p@ eq 1>(<a href=@get_events.status_update_url@> Update </a>)</if>
              </else>
             </td>
         </tr>
         <tr><td> <b> Options: </b> </td> <td> <if @get_events.room_p@ le 0>
                                               <if @write_p@ eq 1><a href=@get_events.edit_url@> Edit the request </a></if> 
                                               <if @delete_p@ eq 1><a href=@get_events.delete_url@> Delete the request </a></if>
                                            </if>
             </td>
          </tr>
</if><else>
<li>@get_events.object_name@ (<a href=@get_events.delete_url@> Remove this item </a>)</li>
@get_events.room_p@

</else>
</multiple>

<if @get_events:rowcount@ gt 1>
</ul></td></tr>
</if>

     </table>
</fieldset>

 <if @update_status_p@ eq 1>
   <formwidget id=sub>
 </if>

</formtemplate>
