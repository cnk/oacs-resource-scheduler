<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="ctrl_event::date_util::todays_date.get_sysdate">
		<querytext>
			select to_char(sysdate, 'YYYY MM DD HH12:MI AM') as today_date from dual
		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_new_day_median_format.add">
		<querytext>
			select to_char(to_date(:date_param, 'YYYY MM DD HH12 MI AM') + :frequency_param, 'YYYY MM DD HH12 MI AM') as new_date from dual
		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_new_day.add">
		<querytext>
			select to_char(to_date(:date_param, 'YYYY MM DD HH24 MI') + :frequency_param, 'YYYY MM DD HH24 MI') as new_date from dual
		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_new_weekday.next_day">
		<querytext>
			select to_char(next_day(to_date(:date_param, 'YYYY MM DD HH24 MI'), :day_param), 'YYYY MM DD HH24 MI') as new_date from dual
			
		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_new_month.add_months">
		<querytext>
	                
			select to_char(add_months(to_date(:date_param, 'YYYY MM DD HH24 MI'), :frequency_param), 'YYYY MM DD HH24 MI') as new_date from dual

		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_last_day.last_day">
		<querytext>
			
			select to_char(last_day(to_date(:date_param, 'YYYY MM DD HH24 MI')), 'YYYY MM DD HH24 MI') as new_date from dual

		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_previous_last_day.last_day_add_months">
		<querytext>

			select to_char(last_day(add_months(to_date(:date_param, 'YYYY MM DD HH24 MI'), -1)), 'YYYY MM DD HH24 MI') as new_date from dual

		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_last_weekday_of_month.next_day_last_day">
		<querytext>

			select to_char(next_day(last_day(to_date(:date_param, 'YYYY MM DD HH24 MI')) -7, :day_param), 'YYYY MM DD HH24 MI') as new_date from dual
		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::date_util::get_event_duration.get_event_duration">
		<querytext>
			 select ($end_date - $start_date)  as duration from dual	
		</querytext>
	</fullquery>
</queryset>
