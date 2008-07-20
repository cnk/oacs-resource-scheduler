<master>
<property name=title> @page_title@</property>
<property name=context> @context@</property>

@cnsi_context_bar;noquote@
<if @room_available_all_p@ eq 0>
 <if @room_admin_p@ eq 1>
   <font color=red> Warning: This room has been previously reserved during the times you selected. You may still reserve this room because you are an admin, but doing so will result in cancelling the previous reservation and an email will be sent to <b>@conflicting_reserver_name_display@</b>, notifying the party of the cancellation.</font>
 </if>
 <else>
   <font color=red>This room has previously been reserved by another user. Please go back and change your reservation dates.</font>
 </else>
</if>

<br><br>

<formtemplate id="confirm">
 <if @start_end_date_conflict_p@ eq 0 and @room_available_all_p@ eq 1 or @room_admin_p@ eq 1>
 <formwidget id=warn />
 <br>
</if>
 <br>
 <fieldset> <legend> <b> @room_info.name@ </b> </legend>
  <table>
   <!--<tr><td> <b> Request Code: </b> </td> <td> @event_code@ </td></tr> -->
   <tr><td align="right"> <b> Reservation Date: </b></td> <td> @start_date_pretty@  - @end_date_pretty@
						 <if @start_end_date_conflict_p@ eq 1>
						    <font color=red><li>(The end date cannot be less than the start date, please go back to the previous screen to fix this.)</font>
						   </if>
						 <if @past_reservation_p@ eq 1>
						    <font color=red><li>(The reservation is in the past, please go back to the previous screen to fix this.)</font>
						   </if>
                                            </td>
   </tr>
   <tr><td align="right"> <b> All Day Event: </b> </td> <td> <if @all_day_p@ eq "t">Yes</if><else>No</else> </td></tr>
   <tr><td align="right"> <b> Repeating Event: </b> </td> <td> @msg;noquote@ </td></tr>
   <tr><td align="right"> <b> Request By:</b> </td> <td> @user_name@ </td></tr>
   <tr><td align="right"> <b> Status: </b>  </td> <td> @status@ </td></tr>
   <tr><td align="right" valign="top"> <b> Reserved Equipment(s): </b>  </td> <td> @internal_eq;noquote@ </td></tr>

<!--   <tr><td> <b> External Reserved Resources: </b>  </td> <td> @external_eq;noquote@ </td></tr>-->
  </table>
 </fieldset>

 <br>
 <br>

 <if @past_reservation_p@ eq 0>
    <if @start_end_date_conflict_p@ eq 0 and @room_available_all_p@ eq 1 or @room_admin_p@ eq 1>   
      <center> <formwidget id=sub /><formerror id="sub"></formerror> </center>
    </if>
</if>

</formtemplate>
<a href=@return_url@> << Go Back To Previous Step </a>
<br/><br/>


<!--pass parameters-->
<if @room_available_all_p@ eq 0>
<br><br>
<include src="/packages/ctrl-resources/www/panels/room-search-results"
name=""
capacity=""
location=""
add_services=""
all_day_p=@all_day_p@
all_day_date_list=@all_day_date_list@
to_date_list=@to_date_list@
from_date_list=@from_date_list@
eq=@all_equipments@
current_page=0
roo_num=25
paginate_p 1
max_dbrows=50
max_returnresults=25>
</if>
