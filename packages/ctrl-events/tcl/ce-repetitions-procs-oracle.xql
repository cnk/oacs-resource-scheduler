<?xml version="1.0"?>
<queryset>

<fullquery name="ctrl_event::repetition::pattern_add.add_repetition_template">
	<querytext>
		insert into ctrl_events_repetitions 
		(repeat_template_id, frequency_type, frequency, specific_day_frequency, specific_days, specific_dates_of_month, specific_months, end_date) 
		values 
		(:repeat_template_id, :frequency_type, :frequency, :specific_day_frequency, :specific_days, :specific_dates_of_month, :specific_months, $end_date)
	</querytext>
</fullquery>

        <fullquery name="ctrl_event::repetition::get_repeat_end_date.get_repeat_end_date">
                <querytext>
                        select to_char(add_months(to_date(:repeat_end_date_str, 'YYYY MM DD HH24 MI'), :repeat_duration), 'YYYY MM DD HH24 MI PM') as new_date from dual
                </querytext>
        </fullquery>

</queryset>
