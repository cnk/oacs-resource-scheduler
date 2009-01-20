<?xml version="1.0"?>
<queryset> 
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
</queryset>