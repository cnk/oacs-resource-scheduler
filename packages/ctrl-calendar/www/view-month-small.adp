<table cellspacing="0" cellpadding="0" width="188">
   <tr>
    <if @view@ eq "month">
        <td>
          <a href="@prev_year_url@" title="#calendar.prev_year#"><img border="0" src="/resources/calendar/images/left.gif" alt="#calendar.prev_year#"/></a>
        </td>
        <td class="at-a-glance-head-current_view" colspan="2">@curr_month@ @curr_day@ @curr_year@</td>
        <td>
          <a href="@next_year_url@" title="#calendar.next_year#"><img border="0" src="/resources/calendar/images/right.gif" alt="#calendar.next_year#" /></a>
        </td>
    </if>
    <else>
        <td>
          <a href="@prev_month_url@#calendar" title="#calendar.prev_month#"><img border="0" src="/resources/calendar/images/left.gif" alt="#calendar.prev_month#" /></a>
        </td>
        <td class="at-a-glance-head-current_view" colspan="2">@curr_month@ @curr_day@ @curr_year@</td>
        <td>
          <a href="@next_month_url@#calendar" title="#calendar.next_month#"><img border="0" src="/resources/calendar/images/right.gif" alt="#calendar.next_month#" /></a>
        </td>
    </else>
</tr>
</table>
 
<table id="at-a-glance" cellspacing="0" cellpadding="0">
    <if @view@ eq month>
      <tr>
       <td colspan="7" style="padding:0px;border-top: 1px solid #B8B8B8;border-left: 1px solid #B8B8B8;border-right:0px; border-bottom:0px;">
       <table cellpadding="0" cellspacing="0" border="0" width="188">
      <multiple name="months">
         <tr>
         <group column="new_row_p">
         <if @months.current_month_p@ true>
          <td class="months selected"><a href="@months.url@" title="#calendar.goto_months_name#">@months.name@</a></td>
         </if>
         <else>
           <td class="months"><a href="@months.url@" title="#calendar.goto_months_name#">@months.name@</a></td>
         </else>
         </group>
         </tr>
       </multiple>
      </table>
     </td>
    </tr>
    </if>
    <else>
      <tr class="days">
        <multiple name="days_of_week">
          <td>@days_of_week.day_short@</td>
        </multiple>
      </tr>

      <tr>
       <td colspan="7" style="padding:0px;border-top: 1px solid #B8B8B8;border-left: 1px solid #B8B8B8;border-right:0px; border-bottom:0px;">
       <table cellpadding="0" cellspacing="0" border="0" width="188">

        <multiple name="days">
          <if @days.beginning_of_week_p@ true>
            <tr>
          </if>

          <if @days.active_p@ true>
            <if @days.today_p@ true>
              <td class="today" onclick="javascript:location.href='@days.url@#calendar';" onkeypress="javascript:acs_KeypressGoto('@days.url@#calendar',event);">
                <a href="@days.url@#calendar" title="#calendar.goto_days_day_number#">@days.day_number@</a>
              </td>
            </if>
            <else>
              <td class="active" onclick="javascript:location.href='@days.url@#calendar';" onkeypress="javascript:acs_KeypressGoto('@days.url@#calendar',event);">
                <a href="@days.url@#calendar" title="#calendar.goto_days_day_number#">@days.day_number@</a>
              </td>
            </else>
          </if>
          <else>
            <td class="inactive" onclick="javascript:location.href='@days.url@#calendar';" onkeypress="javascript:acs_KeypressGoto('@days.url@#calendar',event);">
              <a href="@days.url@#calendar" title="#calendar.goto_days_day_number#">@days.day_number@</a>
            </td>
          </else>
    
          <if @days.end_of_week_p@ true>
            </tr>
          </if>
        </multiple>
    </table>
    </td>
    </tr>
    </else>
 </table>

  <p>
  <if @today_p@ true>
    #acs-datetime.Today#
  </if>
  <else>
    <a href="@today_url@" title="#calendar.goto_today#">#acs-datetime.Today#</a> 
  </else>
  #acs-datetime.is# <%=[dt_ansi_to_pretty]%>
  </p>
