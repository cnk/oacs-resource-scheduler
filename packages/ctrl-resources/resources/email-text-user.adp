
Your reservation has been @action_verb@ and is currently @request_info.status@.
<if @request_info.status@ eq "pending">
Your reservation will be reviewed by a CNSI staff member and approved/denied within one business day.
</if>
<if @action@ ne "delete">
Please go here to review the request: @url@ 

Request Name: @request_name@
Request Description: @request_description@

Requested On: @request_info.requested_date@
Requested By: @request_info.reserved_by@
Status: @request_info.status@
</if>

<if @notification_list@ ne "">
Please contact @notification_list@ if you have any questions.
</if>

Thank you. 
