/* 
	Request Views
	@author avni@ctrl.ucla.edu (AK)
	@cvs-id $Id$
	@creation-date 2005-12-18
*/

create or replace view crs_events_vw
as
select 	cre.event_id,
	cre.request_id,
	cre.status,
	cre.reserved_by,
	cre.date_reserved,
	cre.event_code,
	ce.event_object_id,
	ce.repeat_template_id,
	ce.repeat_template_p,
	ce.title,
	ce.start_date,
	ce.end_date,
	ce.all_day_p,
	ce.location,
	ce.notes,
	ce.capacity
from    crs_events cre,
	ctrl_events ce
where   cre.event_id = ce.event_id;


commit;
