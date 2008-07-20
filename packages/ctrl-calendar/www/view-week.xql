<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="get_juilian_date">
		<querytext>
			select 	to_char(ce.start_date, 'J') as julian_start_date
			from    ctrl_events ce
                	where   ce.event_object_id in ($object_id_list_for_sql)
                	and     to_char(ce.start_date, 'yyyy-mm') = to_char(to_date(:current_date),'yyyy-mm') 
                	order  by ce.start_date asc
		</querytext>
	</fullquery>


<fullquery name="julian_week_date_list">
<querytext>
select   to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday'),'J')
as sunday_j,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday'),'yyyy-mm-dd')
as sunday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 1,'J')
as monday_j,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 1,'yyyy-mm-dd')
as monday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 2,'J') 
as tuesday_j,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 2,'yyyy-mm-dd') 
as tuesday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 3,'J') 
as wednesday_j,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 3,'yyyy-mm-dd') 
as wednesday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 4,'J') 
as thursday_j,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 4,'yyyy-mm-dd') 
as thursday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 5,'J')
as friday_j,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 5,'yyyy-mm-dd')
as friday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 6,'J') 
as saturday_j,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - 7, 'Sunday') + 6,'yyyy-mm-dd') 
as saturday_date
from     dual
</querytext>
</fullquery>


</queryset>
