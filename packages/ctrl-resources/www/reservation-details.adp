<master>
<property name=title> @page_title@ </property>
<property name=context> @context@ </property>
@cnsi_context_bar;noquote@
<br>
<b>Reservation Details:</b>
<br>
<br>
<if @exists_p@ eq "0">
  <b>The request you selected no longer exists in the database. Please use the link below to select another request. Thank you.</b><br/><br/>
</if>
<else>
<include src="/packages/ctrl-resources/www/panels/reservation-details" request_id=@request_id@ update_status_p=@update_status_p@ event_id=@event_id@ room_id=@room_id@>
</else>
<br>
<if @room_id@ ne "">@room_detail_link;noquote@</if>
<br></br><br></br>
@reservation_link;noquote@
<br></br><br></br>
