
<table width="100%" border="0" cellpadding="1" cellspacing="1">
   <td valign="top" width="55%">
	<formtemplate id="add_edit_event">
	<table width="99%" cellpadding="0" cellspacing="1">
	        <tr><th align="right">Subject<font color="red">*</font></th>
		    <td><formwidget id="title"/><font color="red"><formerror id="title"></formerror></font></td>
		</tr>
		<tr><th align="right">Description</th>
		    <td><formwidget id="description"/><font color="red"><formerror id="description"></formerror></font></td>
		</tr>
		<tr><th align="right">Event Start Time:</th>
		    <td><formwidget id="event_start_time"/><font color="red"><formerror id="event_start_time"></formerror></font></td>
		</tr>
		<tr><th align="right">Event Duration:</th>
		    <td><table><tr>
                        <td align=center>
                           <table border="0" cellpadding="0" cellspacing="2">
                           <tr><td><formwidget id="event_duration_days"/><font color="red"><formerror id="event_duration_days"></formerror></font></td></tr>
                           <tr><td align=center><span style="font-size:smaller;">Days</span></td></tr>
                           </table>
                        </td>
                        <td>
                           <formwidget id="event_duration_hm"/><font color="red"><formerror id="event_duration_hm"></formerror></font>
                        </td>
                        </tr></table>
                    </td>
		</tr>
	<if @new_p@ and @admin_p@>
		<tr>
		    <th align="right">Event Repeats:</th>
		    <td> <span id="1">
		         <formgroup id="frequency_type" onclick="repeatType()">
				@formgroup.widget;noquote@ @formgroup.label;noquote@
		         </formgroup>
		         </span></td>
		</tr>
		<tr>
		   <td> </td>
		   <td> <span id="Day" style="display:none;">Every &nbsp<formwidget id="frequency_day"/> &nbsp day(s)
			<font color="red"><formerror id="frequency_day"></formerror><br>
			</span> </td>
		</tr>

		<tr>
		   <td> </td>
		   <td> <span id="Week" style="display:none;">Every &nbsp<formwidget id="frequency_week"/> &nbsp week(s) on
			<formgroup id="specific_days_week">
			<br>&nbsp&nbsp&nbsp&nbsp&nbsp @formgroup.widget;noquote@ @formgroup.label;noquote@
			</formgroup>
		   </span></td>
		</tr>
		<tr>
		   <td></td>
		   <td><span id="Month" style="display:none;">
		       <table><tr><td>
			      <formgroup id="repeat_month_opt1" onclick="repeatMonthOpt(1)">
				@formgroup.widget;noquote@ @formgroup.label;noquote@ &nbsp <formwidget id="specific_dates_of_month_month"/>&nbsp of every &nbsp
			      <formwidget id="frequency_month"/>&nbsp month(s)
			      <font color="red"><formerror id="frequency_month"></formerror></font>
			      <font color="red"><formerror id="specific_dates_of_month_month"></formerror><br>
			      </formgroup>
		       </td></tr>
		       <tr><td><formgroup id="repeat_month_opt2" onclick="repeatMonthOpt(2)">
				@formgroup.widget;noquote@ @formgroup.label;noquote@ &nbsp
			       <formwidget id="specific_day_frequency"/>
			       <formwidget id="specific_days_month"/></formgroup></td>
		       </tr></table>
		       </span></td>
		</tr>

		<tr>
		   <td></td>
		   <td><span id="Year" style="display:none;">
			Every &nbsp <formwidget id="specific_months"/> <formwidget id="specific_dates_of_month_year"/>
			<font color="red"><formerror id="specific_dates_of_month_year"></formerror></font>
		     </span></td>
		</tr>
                <tr>
                   <td></td><td></td>
                </tr>
	        <tr>
		   <td></td>
		   <td> <span id="End" style="display:none;">
                        <br>
                        <table>
                        <tr><td style="padding-bottom:15px;">Begin Date:</td>
		            <td valign=bottom><formwidget id="start_date"/><font color="red"><formerror id="start_date"></formerror></font></td>
                        </tr>
                        <tr>
                            <td></td><td></td>
                        </tr>
                        <tr><td style="padding-bottom:15px;"> End Date: &nbsp</td> 
                            <td valign=center><br>
                             <% set my_count 1 %>                             
			     <formgroup id="repeat_end_date_opt">
                              <if @my_count@ eq 2>
                                <table> 
                                   <tr><td>@formgroup.widget;noquote@ @formgroup.label;noquote@<br>                                  
                                       <span style="font-size:smaller; padding-left:25px;">
                                       (No End Date reserves the room 6 months for </span><br>
                                       <span style="font-size:smaller; padding-left:25px;">
                                       daily,weekly,monthly and 5 years for yearly)
                                       </span>
                                   </td></tr>
                                </table>
                                <% incr my_count %>
                              </if><elseif @my_count@ eq 1>
                                <table>
                                 <tr>
	                           <td valign=top>@formgroup.widget;noquote@ @formgroup.label;noquote@</td>
                                   <td valign=top> <formwidget id="repeat_end_date"/></td>
                                 </tr>
                                </table>
                                <%  incr my_count %>
                              </elseif>
			    </formgroup>                                                                                      
                            </td>
                        </tr>
                        </table>
			<table>			
		      </span></td>
	        </tr>
	</if><else>
           <tr>
               <td></td>
               <td><span id="begin_date" style="display:none;">
                   <formwidget id="start_date"/>
                   </span>                   
               </td>
           </tr>
        </else>

	<if @room_has_eqpmt_p@>
		<tr>
		   <th valign="top"><br />Equipment:</th>
		   <td><br />
					 <formgroup id="room_eqpmt_check">
					   @formgroup.widget;noquote@ @formgroup.label@ <br />
					 </formgroup>
					 <br />
					 <br />
		   </td>
		</tr>
	</if>

	<if @get_repeat_reservation:rowcount@ ne 0>
		<tr><td colspan="2" align="center"><formwidget id="update_future_p"></td></tr>
	</if>
		<tr><td>&nbsp;</td><td><formwidget id="submit"/><br /><br /></td>
		</tr>
		</table>
	<if @get_repeat_reservation:rowcount@ ne 0>
		<center><h3>All Related Reservations</h3></center>
		<table>
		   <th>Title</th>
		   <th>Start Date</th>
		   <th>End Date</th>
		   <th>Status</th>
		   <multiple name="get_repeat_reservation">
		      <tr>
		        <td><a href="@get_repeat_reservation.edit_url@">@get_repeat_reservation.title@</a></td>
		        <td>@get_repeat_reservation.start_date@</td>
		        <td>@get_repeat_reservation.end_date@</td>
		        <td>@get_repeat_reservation.status@</td>
		      </tr>
		   </multiple>
		</table>
		<br /><br />
	</if>
</formtemplate>
</td></tr></table>

