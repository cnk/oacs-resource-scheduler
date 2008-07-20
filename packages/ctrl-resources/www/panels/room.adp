<table>
<tr align=left><th>Name:</th><td>@room_info.name@</td></tr>
<tr align=left><th>Description:</th><td>@room_info.description@</td></tr>   
<tr align=left><th>Enabled:</th><td><if @room_info.enabled_p@ eq  t> Yes </if><else>No</else></td></tr>
<tr align=left><th>Approval Required:</th><td><if @room_info.approval_required_p@ eq  t> Yes </if><else>No</else></td></tr>
<tr align=left><th>Type:</th><td><if @room_info.resource_category_name@ eq "">(Not Specified)</if><else> @room_info.resource_category_name@</else></td></tr>
<tr align=left><th>Property tag:</th><td><if @room_info.property_tag@ eq "">(Not Specified)</if><else>@room_info.property_tag@ </else></td></tr>
<tr align=left><th>Services:</th><td>@room_info.services@</td></tr>
<tr align=left><th>How to Reserve:</th><td>@room_info.how_to_reserve@</td></tr>
<tr align=left>       <th>Floor:</th><td>@room_info.floor@</td></tr>
<tr align=left>       <th>Room:</th><td>@room_info.room@</td> </tr>
<tr align=left>        <th>Capacity:</th><td>@room_info.capacity@</td> </tr>
<tr align=left>        <th>Size (WxLxH):</th><td>@room_info.width@ x @room_info.length@ x @room_info.height@</td> </tr>
<tr align=left>        <th>Allow Reservations?</th><td><if @room_info.reservable_p@>Yes</if><else>No</else></td> </tr>
<if @room_info.reservable_p@ eq "f">
<tr align=left>        <th>Message to display when not<br>allowing reservations:</th><td>@room_info.reservable_p_note;noquote@</td> </tr>
</if>
<tr align=left>        <th>Special Request Only?</th><td><if @room_info.special_request_p@>Yes</if><else>No</else></td> </tr>
</table>



