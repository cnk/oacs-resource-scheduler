<br />
<table width="100%" class="topnavbar event-view-options">
	<tr><td <if @view_option@ eq "daily">class="active"</if> class="evt-vw-opt-cell">
			<img src="/resources/ctrl-calendar/images/calendar_view_day.gif" class="topnavbar-icon" alt="DAY" />
			<a class="small" href="@view_day_url;noquote@" title="Select Day view" >DAY</a>
		</td>

		<td <if @view_option@ eq "weekly">class="active"</if> class="evt-vw-opt-cell">
			<img src="/resources/ctrl-calendar/images/calendar_view_week.gif" class="topnavbar-icon" alt="WEEK" />
			<a class="small" href="@view_week_url;noquote@" title="Select Week view" >WEEK</a>
		</td>

		<td <if @view_option@ eq "monthly">class="active"</if> class="evt-vw-opt-cell">
			<img src="/resources/ctrl-calendar/images/calendar_view_month.gif" class="topnavbar-icon" alt="MONTH" />
			<a class="small" href="@view_month_url;noquote@" title="Select Month view" >MONTH</a>
		</td>

		<td <if @view_option@ eq "list">class="active"</if> class="evt-vw-opt-cell">
			<img src="/resources/ctrl-calendar/images/list-icon.gif" class="topnavbar-icon" alt="LIST" />
			<a class="small" href="@events_list_url;noquote@" title="Select List View" >LIST</a>
		</td>

		<td id="evt-vw-opt-advcd" <if @view_option@ eq "advanced"> bgcolor=white class="active" </if> class="evt-vw-opt-cell">
			<img src="/resources/ctrl-calendar/images/calendar_advanced.gif" class="topnavbar-icon" alt="ADVANCED" />
			<a class="small" href="@filter_url;noquote@" title="Select Advanced Options" >ADVANCED</a>
		</td>

		<td id="evt-vw-opt-rss" class="evt-vw-opt-cell">
			<img src="/resources/ctrl-calendar/images/rss_feed.gif" class="topnavbar-icon" alt="RSS" />
			<a class="small" href="@rss_url;noquote@" title="Select RSS View">RSS</a>
		</td>
	</tr>
</table>

<slave>
