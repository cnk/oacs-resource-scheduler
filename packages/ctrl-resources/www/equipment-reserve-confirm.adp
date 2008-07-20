<master>
<property name=title> @page_title@</property>
<property name=context> @context@</property>


<a href=@return_url@> << Go Back To Previous Step </a>

<br><br>

@cnsi_context_bar;noquote@

<if @resource_available_p@ eq 0 and @updating_p@ eq 0>
 <if @resource_admin_p@ eq 1>
   <font color=red> Warning: </font> This equipment has been previously reserved by: <b> @conflicting_reserver_name@ </b> . You may still reserve this equipment because you are an admin, but doing so will result in cancelling the previous reservation and an email will be sent to <b> @conflicting_reserver_name@ </b> , notifying the party of the cancellation.
 </if>
 <else>
   This equipment has previously been reserved by: . Please go back and change your reservation dates.
 </else>
</if>

<br><br>

<formtemplate id="confirm">
 <formwidget id=warn>
 <br>
 <br>
 <br>
 <fieldset> <legend> <b> @resource_info.name@ </b> </legend>
  <table>
   <tr><td> <b> Request Code: </b> </td> <td> @event_code@ </td></tr>
   <tr><td> <b> Reservation Date: </b></td> <td> @start_date.month@/@start_date.day@/@start_date.year@
                                                   @start_date.short_hours@:@start_date.minutes@ @start_date.ampm@  -
                                                 @end_date.month@/@end_date.day@/@end_date.year@
                                                   @end_date.short_hours@:@end_date.minutes@ @end_date.ampm@
                                                   <if @start_end_date_conflict_p@ eq 1>
                                                    <font color=red>(The end date cannot be less than the start date, please go back to the previous screen to fix this.)</font>
                                                   </if>
                                            </td>
   </tr>
   <tr><td> <b> Request By:</b> </td> <td> @user_name@ </td></tr>
   <tr><td> <b> Status: </b>  </td> <td> Pending </td></tr>
  </table>
 </fieldset>

 <br>
 <br>
 <if @start_end_date_conflict_p@ eq 0>
   <center> <formwidget id=sub> </center>
 </if>
</formtemplate>
