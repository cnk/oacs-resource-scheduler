The following request has been @action_verb@.<br>
<if @request_status@ eq "pending">
It requires approval in order to be scheduled.<br>
</if>
<br>
Please go here to review the request: @url@ 
<br><br>
Room: @resource_info.name@<br>
Request Name: @request_name@<br>
Request Description: @request_info.description@<br>
<br>
Requested On: @request_info.requested_date@<br>
Requested By: @request_info.reserved_by@<br>
Status: @request_status@<br>
<br>
Thank you. 
