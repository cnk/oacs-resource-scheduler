<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="ctrl::cal::event::insert.ccem_insert">
	 <querytext>
		insert into ctrl_calendar_event_map (cal_id, event_id)
		values (:cal_id, :event_id)
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::cal::event::del.ccem_del">
	 <querytext>
		delete from ctrl_calendar_event_map where event_id = :event_id
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::cal::event::month_list.get_month_event_list">
	 <querytext>
		select	ce.event_id,
				ce.event_object_id,
				ce.title,
				ce.start_date,
				ce.end_date,
				to_char(ce.start_date,	'J') 				as julian_start_date,
				to_char(ce.end_date,	'J') 				as julian_end_date,
				trim(to_char(ce.start_date,	'hh12:mi am'))	as start_time,
				trim(to_char(ce.end_date,	'hh12:mi am'))	as end_time,
				ce.all_day_p,
				ccem.cal_id
		from	ctrl_events				ce,
				ctrl_calendar_event_map	ccem
		where	ce.event_id				= ccem.event_id
		and		ccem.cal_id				in ($cal_id_list)
		and		to_char(ce.start_date, 'yyyy-mm') = to_char(to_date(:current_date),'yyyy-mm')
		and		repeat_template_p		= 'f'
		order	by ce.start_date
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::cal::event::week_list.get_week_event_list">
	 <querytext>
		select	ce.event_id,
				ce.event_object_id,
				ce.title,
				ce.start_date,
				ce.end_date,
				to_char(ce.start_date,	'J')		as julian_start_date,
				to_char(ce.end_date,	'J')		as julian_end_date,
				trim(to_char(ce.start_date,	'hh12:mi am'))	as start_time,
				trim(to_char(ce.end_date,	'hh12:mi am'))	as end_time,
				ce.all_day_p
		from	ctrl_events			ce, ctrl_calendar_event_map ccem
		where	ce.event_id = ccem.event_id
        and     ccem.cal_id in ($cal_id_list)
		and		to_char(ce.start_date, 'yyyy-mm-dd') >= to_char(to_date(:current_date) - 7,'yyyy-mm-dd')
		and		to_char(ce.start_date, 'yyyy-mm-dd') <= to_char(to_date(:current_date) + 7,'yyyy-mm-dd')
		and		repeat_template_p	= 'f'
		order	by ce.start_date asc
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::cal::event::week_list.get_day_event_list">
	 <querytext>
		select	ce.event_id,
				ce.event_object_id,
				ce.title,
				ce.start_date,
				ce.end_date,
				to_char(ce.start_date,	'J')			as julian_start_date,
				to_char(ce.end_date,	'J')			as julian_end_date,
				trim(to_char(ce.start_date,	'hh24:mi'))	as start_time,
				trim(to_char(ce.end_date,	'hh24:mi'))	as end_time,
				ce.all_day_p
		from	ctrl_events			ce
		where	ce.event_object_id	in ($object_id_list)
		and		to_char(ce.start_date, 'yyyy-mm-dd') = to_char(to_date(:current_date),'yyyy-mm-dd')
		and		repeat_template_p	= 'f'
		order	by ce.start_date asc
	 </querytext>
	</fullquery>


	<fullquery name="ctrl::cal::event::log_download.get_email">
	 <querytext>
		select	email
		from	parties
		where	party_id = :user_id
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::cal::event::log_download.record_exists_p">
	 <querytext>
		select count(*)
		from	ctrl_calendar_event_downloads
		where	event_id = :event_id
		and		email	 = :email
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::cal::event::log_download.log_download">
	 <querytext>
		insert into ctrl_calendar_event_downloads
			(event_id, email)
		values	(:event_id, :email)
	 </querytext>
	</fullquery>
</queryset>
<!--	vim:set ts=4 sw=4 syntax=sql:	-->
<!--	Local Variables:				-->
<!--	mode:		sql					-->
<!--	tab-width:	4					-->
<!--	End:							-->
