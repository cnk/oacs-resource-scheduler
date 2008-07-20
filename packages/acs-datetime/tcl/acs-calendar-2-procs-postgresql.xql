<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="dt_widget_week.select_week_info">      
<querytext>
select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 'D') 
as day_of_the_week,
cast(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') as date)
as sunday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday'),'J') 
as sunday_julian,
cast(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('1 day' as interval) as date)
as monday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('1 day' as interval),'J')
as monday_julian,
cast(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('2 days' as interval) as date)
as tuesday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('2 days' as interval),'J') 
as tuesday_julian,
cast(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('3 days' as interval) as date)
as wednesday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('3 days' as interval),'J') 
as wednesday_julian,
cast(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('4 days' as interval) as date)
as thursday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('4 days' as interval),'J') 
as thursday_julian,
cast(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('5 days' as interval) as date)
as friday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('5 days' as interval),'J') 
as friday_julian,
cast(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('6 days' as interval) as date)
as saturday_date,
to_char(next_day(to_date(:current_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('6 days' as interval),'J') 
as saturday_julian,
cast(:current_date::timestamptz - cast('7 days' as interval) as date) as last_week,
to_char(:current_date::timestamptz - cast('7 days' as interval), 'Month DD, YYYY') as last_week_pretty,
cast(:current_date::timestamptz + cast('7 days' as interval) as date) as next_week,
to_char(:current_date::timestamptz + cast('7 days' as interval), 'Month DD, YYYY') as next_week_pretty
from     dual
</querytext>
</fullquery>

<fullquery name="dt_widget_day.select_day_info">      
<querytext>
select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 'Day, DD Month YYYY') 
as day_of_the_week,
to_char(to_date(:current_date, 'yyyy-mm-dd') - cast('1 day' as interval), 'yyyy-mm-dd')
as yesterday,
to_char(to_date(:current_date, 'yyyy-mm-dd') + cast('1 day' as interval), 'yyyy-mm-dd')
as tomorrow
from     dual
</querytext>
</fullquery>

 
</queryset>
