<?xml version="1.0"?>
<queryset>

<fullquery name="ctrl_event::exists_p.exists_p">
	<querytext>
		select count(*)
		from   ctrl_events
		where  event_id = :event_id
	</querytext>
</fullquery>

<!-- START NEW EVENT -->
<fullquery name="ctrl_event::new.add">
	<querytext>
		begin
			:1 := ctrl_event.new (
				event_id			=> :event_id,
				event_object_id		=> :event_object_id,
				repeat_template_id	=> :repeat_template_id,
				repeat_template_p	=> :repeat_template_p,
				title				=> :title,
				speakers			=> :speakers,
				start_date			=> $start_date,
				end_date			=> $end_date,
				all_day_p			=> :all_day_p,
				location			=> :location,
				capacity			=> :capacity,
				category_id			=> :category_id,
				event_image_caption => :event_image_caption,
				package_id		    => :package_id,
				context_id			=> :context_id
			);
		end;
	</querytext>
</fullquery>

<fullquery name="ctrl_event::new.notes">
	<querytext>
		update ctrl_events
		   set notes	= empty_clob()
		 where event_id	= :event_id
		returning notes into :1
	</querytext>
</fullquery>
<!-- END NEW EVENT -->

<!-- START UPDATING EVENT -->
<fullquery name= "ctrl_event::update.update">
	<querytext>
		update	ctrl_events
		   set	event_id			= :event_id,
				event_object_id		= :event_object_id,
				repeat_template_p	= :repeat_template_p,
				title				= :title,
				speakers			= :speakers,
				start_date			= $start_date,
				end_date			= $end_date,
				all_day_p			= :all_day_p,
				location			= :location,
				capacity			= :capacity,
				category_id			= :category_id,
				event_image_caption = :event_image_caption
		where	event_id	= :event_id
	</querytext>
</fullquery>

<fullquery name="ctrl_event::update.notes">
	<querytext>
		update	ctrl_events
		   set	notes		= empty_clob()
		 where	event_id	= :event_id
		returning notes into :1
	</querytext>
</fullquery>

<!-- END UPDATING EVENT -->


<!-- START DELETING EVENT -->
<fullquery name= "ctrl_event::delete.remove">
	<querytext>
		begin
			delete from ctrl_calendar_event_categories where event_id = :event_id;
			ctrl_event.del(event_id => :event_id);
		end;
	</querytext>
</fullquery>
<!-- END DELETING event::delete.remove -->

<fullquery name= "ctrl_event::update_recurrences.update">
	<querytext>
		begin
			FOR u in (select event_id
					  from ctrl_events ce
					  where ce.repeat_template_id = :repeat_template_id
					  and to_char(ce.start_date, 'YYYY/MM/DD HH12:MI AM') >= :start_update_date) LOOP
				update	ctrl_events
			    set	event_id			= u.event_id,
					event_object_id		= :event_object_id,
					repeat_template_p	= :repeat_template_p,
					title				= :title,
					speakers			= :speakers,
					start_date			= $start_date,
					end_date			= $end_date,
					all_day_p			= :all_day_p,
					location			= :location,
					capacity			= :capacity,
					category_id			= :category_id,
					event_image_caption = :event_image_caption
				where event_id	= u.event_id;
			END LOOP;
		end;
	</querytext>
</fullquery>

<fullquery name= "ctrl_event::delete_recurrences.remove_recurrences">
	<querytext>
		begin
			FOR d in (select event_id
						from ctrl_events ce
					   where ce.repeat_template_id = :repeat_template_id
						 and to_char(ce.start_date,
									'YYYY/MM/DD HH12:MI AM') >= :delete_date) LOOP
				delete from ctrl_calendar_event_categories where event_id = d.event_id;	
				ctrl_event.del(d.event_id);
			END LOOP;
		end;
	</querytext>
</fullquery>

<!-- END DELETING EVENT -->

<fullquery name="ctrl_event::update_recurrences.get_update_date">
                <querytext>
                        select to_char(start_date, 'YYYY/MM/DD HH12:MI AM')
                               from ctrl_events
                        where event_id=:event_id
                </querytext>
</fullquery>

<fullquery name= "ctrl_event::update_recurrences.ctrl_events_photo_delete">
	<querytext>
	       update  ctrl_events
           set  event_image_width = null,
                event_image_height = null,
                event_image_file_type = null,
                event_image_caption = null,
                event_image = empty_blob()
         where  event_id    = :event_id
	</querytext>
</fullquery>


<fullquery name="ctrl_event::event_image_display.event_image_display">
                <querytext>
			    select 	event_id, 
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

