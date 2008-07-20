<?xml version="1.0"?>
<queryset>

<fullquery name="ctrl_event::object::new.add">
   <querytext>
	begin
	   :1 := ctrl_event_object.new (
		event_object_id	=> :event_object_id,
		name 		=> :name,
		object_type_id 	=> :object_type_id,
		description 	=> :description,
		url		=> :url,
		creation_ip	=> :creation_ip,
		context_id	=> :context_id
	   );
	end;
   </querytext>
</fullquery>

<fullquery name="ctrl_event::object::update.update">
   <querytext>
	update 	ctrl_events_objects
	set 	name = :name,
		object_type_id = :object_type_id,
		description = :description,
		url = :url
	where 	event_object_id = :event_object_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::object::delete.remove_mapping">
   <querytext>
	delete from ctrl_events_event_object_map where event_object_id = :event_object_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::object::delete.remove">
   <querytext>
	begin 
	   ctrl_event_object.del(event_object_id => :event_object_id);
	end;
   </querytext>
</fullquery>

<fullquery name= "ctrl_event::object::image_delete.image_delete">
   <querytext>
   	update  ctrl_events_objects
           set  image_width = null,
                image_height = null,
                image_file_type = null,
                image = empty_blob()
         where  event_object_id    = :event_object_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::object::image_display.image_display">
    <querytext>
      	select event_object_id, image, image_width, image_height
        from ctrl_events_objects
        where event_object_id = :event_object_id
    </querytext>
</fullquery>

<fullquery name="ctrl_event::object::unique_p.check_unique">
    <querytext>
    	select 1
        from ctrl_events_objects
        where object_type_id = :object_type_id and name = :name and event_object_id <> :event_object_id
    </querytext>
</fullquery>

<fullquery name="ctrl_event::object::unique_tag_p.check_unique">
    <querytext>
    	select 1
        from ctrl_events_event_object_map
        where event_id = :event_id and tag = :tag and event_object_id <> :event_object_id
    </querytext>
</fullquery>

<fullquery name="ctrl_event::object::tag.tag">
    <querytext>
    	select tag
        from ctrl_events_event_object_map
        where event_id = :event_id and event_object_id = :event_object_id
    </querytext>
</fullquery>

<fullquery name="ctrl_event::object::map.add">
    <querytext>
	insert into ctrl_events_event_object_map (event_id, event_object_id, tag)
	values (:event_id, :event_object_id, :tag)
    </querytext>
</fullquery>

<fullquery name="ctrl_event::object::unmap.remove">
    <querytext>
	delete from ctrl_events_event_object_map
	where event_id = :event_id and event_object_id = :event_object_id
    </querytext>
</fullquery>

<fullquery name="ctrl_event::object::map_update.update">
    <querytext>
	update ctrl_events_event_object_map
	set tag = :tag
	where event_id = :event_id and event_object_id = :event_object_id
    </querytext>
</fullquery>

</queryset>
