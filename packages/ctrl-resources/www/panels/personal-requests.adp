<a href=@toggle_history_link@>@history_label@ </a>
<br>
<br>
  <if @personal_events:rowcount@ gt 0>
        <multiple name="personal_events">
    <table class="standard" width="90%" style="border: 1px solid #666666; background-color: @personal_events.bg_color@;">
    <tr>
            <td> <i>Request For:</i> <b>@personal_events.object_name@</b>  </td> 
	    <td> <i>Request ID:</i> @personal_events.request_id@   </td>
	    </tr>
	    <tr>
	    <td> @personal_events.title@  </td>
	    <td> <i>Status:</i> @personal_events.status@  </td>
	    </tr>
	    <tr>
	    <td colspan=2 style="padding: 10px; border: 1px dotted #666666;"><i>Date Requested:  @personal_events.date_reserved@ <br>
	    <i>From:  <u>@personal_events.start_date@</u>
	    <i>To:  <u>@personal_events.end_date@</u>  <br>
	    </tr>
            <tr>
	    <td colspan=2 style="text-align: center;"> <i>Actions:</i> &nbsp; 
	         [<a href=@personal_events.details_url@>Details</a> |
		  <if @personal_events.write_p@ eq t><a href=@personal_events.edit_url@> Edit</a></if>
		  |<a href=@personal_events.room_reserve_url@> Make another reservation for this room </a>
                  <if @personal_events.delete_p@ eq t>| <a href=@personal_events.delete_url@>  Delete  </a> </if>
		 ]
	    </td>
          </tr>
	  </table>
	  <br>
        </multiple>         

  </if>

