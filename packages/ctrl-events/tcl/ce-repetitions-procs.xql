<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="ctrl_event::repetition::get.get">
	<querytext>
		select	repeat_template_id,
			frequency_type,
			frequency,
			specific_day_frequency,
			specific_days,
			specific_dates_of_month,
			specific_months,
			end_date
	          from  ctrl_events_repetitions
	         where  repeat_template_id = :repeat_template_id
 	</querytext>
	</fullquery>

	<fullquery name="event_repetitions::repeating_events_add.get_new_day">
		<querytext>
			select to_char(to_date(:date_param, 'YYYY MM DD HH24 MI') + :frequency_param, 'YYYY MM DD HH24 MI') as new_date from dual
		</querytext>
	</fullquery>

	<fullquery name="event_repetitions::repeating_events_add.get_new_weekday">
		<querytext>
			select to_char(next_day(to_date(:date_param, 'YYYY MM DD HH24 MI'), :day_param), 'YYYY MM DD HH24 MI') as new_date from dual
			
		</querytext>
	</fullquery>

	<fullquery name="event_repetitions::repeating_events_add.get_new_month">
		<querytext>
	                
			select to_char(add_months(to_date(:date_param, 'YYYY MM DD HH24 MI'), :new_frequency_param), 'YYYY MM DD HH24 MI') as new_date from dual

		</querytext>
	</fullquery>

	<fullquery name="event_repetitions::repeating_events_add.get_last_day">
		<querytext>
			
			select to_char(last_day(to_date(:date_param, 'YYYY MM DD HH24 MI')), 'YYYY MM DD HH24 MI') as new_date from dual

		</querytext>
	</fullquery>

	<fullquery name="event_repetitions::repeating_events_add.get_previous_last_day">
		<querytext>

			select to_char(last_day(to_date(add_months(to_date(:date_param, 'YYYY MM DD HH24 MI'), -1), 'YYYY MM DD HH24 MI')), 'YYYY MM DD HH24 MI') as new_date from dual

		</querytext>
	</fullquery>

	<fullquery name="event_repetitions::repeating_events_add.get_last_weekday_of_month">
		<querytext>

			select to_char(next_day(last_day(to_date(:date_param, 'YYYY MM DD HH24 MI')) -7, :day_param), 'YYYY MM DD HH24 MI') as new_date from dual
		</querytext>
	</fullquery>

	<fullquery name="ctrl_event::repetition::today_day_in_string.get_day">
		<querytext>
			select to_char($date_param, 'DY') as new_date from dual
		</querytext>
	</fullquery>
</queryset>
