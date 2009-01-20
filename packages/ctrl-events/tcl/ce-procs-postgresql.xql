<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<!-- START event::get.get -->
<fullquery name="ctrl_event::get.get">
 <querytext>
	select	event_object_id,
		repeat_template_id,
		repeat_template_p,
		title,
		speakers,
		to_char(start_date,$date_format) as start_date,
                to_char(end_date,$date_format) as end_date,
		to_char(start_date, 'Mon DD, YYYY ') || to_char(start_date,'FMHH12') || to_char(start_date,':MI AM') as pretty_start_date,
                to_char(end_date, 'Mon DD, YYYY ') || to_char(end_date,'FMHH12') || to_char(end_date,':MI AM') as pretty_end_date,
		all_day_p,
		location,	
		notes,
		capacity,
		ctrl_category__name(category_id) as category_name,
		acs_object__name(event_object_id) as event_object_name,
		image_item_id
	  from	ctrl_events
	 where	event_id = :event_id
 </querytext>
</fullquery>
<!-- END event::get.get -->


<!-- START NEW EVENT -->
<fullquery name="ctrl_event::new.add">
    <querytext>
        select ctrl_event__new (
                :event_id,
                :event_object_id,
                :repeat_template_id,
                :repeat_template_p,
                :title,
                :speakers,
                $start_date,
                $end_date,
                :all_day_p,
                :location,
                NULL,
                :capacity,
                NULL,
                't',  -- public_p
                't',  -- approved_p
                :category_id,
                :package_id,
                NULL,
                NULL,
                'ctrl_event',
                NULL,
                :context_id
            );
    </querytext>
</fullquery>

<fullquery name="ctrl_event::new.notes">
    <querytext>
        update ctrl_events
           set notes    = empty_clob()
         where event_id = :event_id
        returning notes into :1
    </querytext>
</fullquery>
<!-- END NEW EVENT -->

<!-- START UPDATING EVENT -->
<fullquery name="ctrl_event::update.notes">
    <querytext>
        update  ctrl_events
           set  notes       = empty_clob()
         where  event_id    = :event_id
        returning notes into :1
    </querytext>
</fullquery>
<!-- END UPDATING EVENT -->


<!-- START DELETING EVENT -->
<fullquery name= "ctrl_event::delete.remove">
    <querytext>
        begin
            delete from ctrl_calendar_event_categories where event_id = :event_id;
            select ctrl_event__delete(event_id => :event_id);
        end;
    </querytext>
</fullquery>
<!-- END DELETING event::delete.remove -->

<fullquery name= "ctrl_event::update_recurrences.update">
    <querytext>
        DECLARE
            u       record;
        BEGIN
            FOR u in (select event_id
                      from ctrl_events ce
                      where ce.repeat_template_id = :repeat_template_id
                      and to_char(ce.start_date, 'YYYY/MM/DD HH12:MI AM') >= :start_update_date) LOOP
                update  ctrl_events
                set event_id            = u.event_id,
                    event_object_id     = :event_object_id,
                    repeat_template_p   = :repeat_template_p,
                    title               = :title,
                    speakers            = :speakers,
                    start_date          = $start_date,
                    end_date            = $end_date,
                    all_day_p           = :all_day_p,
                    location            = :location,
                    capacity            = :capacity,
                    category_id         = :category_id
                where event_id  = u.event_id;
            END LOOP;
            return 1;
        end;
    </querytext>
</fullquery>

<fullquery name= "ctrl_event::delete_recurrences.remove_recurrences">
    <querytext>
        DECLARE 
            d     record;
        BEGIN
            FOR d in (select event_id
                        from ctrl_events ce
                       where ce.repeat_template_id = :repeat_template_id
                         and to_char(ce.start_date,
                                    'YYYY/MM/DD HH12:MI AM') >= :delete_date) LOOP
                delete from ctrl_calendar_event_categories where event_id = d.event_id; 
                ctrl_event__delelete(d.event_id);
            END LOOP;
        END;
    </querytext>
</fullquery>

<!-- END DELETING EVENT -->

<fullquery name= "ctrl_event::update_recurrences.ctrl_events_photo_delete">
    <querytext>
           update  ctrl_events
           set  event_image_width = null,
                event_image_height = null,
                event_image_file_type = null,
                event_image_caption	 = null,
                event_image = empty_blob()
         where  event_id    = :event_id
    </querytext>
</fullquery>


<fullquery name="ctrl_event::event_image_display.event_image_display">
                <querytext>
                select  event_id, 
						event_image, 
						event_image_width, 
						event_image_height
		        from 	ctrl_events
        		where 	event_id = :event_id
                </querytext>
</fullquery>


</queryset>

<!--	vim:set ts=4 sw=4 syntax=sql:	-->
<!--	Local Variables:				-->
<!--	mode:			sql				-->
<!--	tab-width:		4				-->
<!--	End:							-->

