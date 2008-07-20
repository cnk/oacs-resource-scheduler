<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

   <fullquery name="crs::room::new.room_new">      
      <querytext>
          begin
              :1 := crs_room.new (
        		capacity 		=> :capacity,
        		dimensions_width        => :dimensions_width,
		        dimensions_length       => :dimensions_length,
		        dimensions_height       => :dimensions_height,
		        dimensions_unit         => :dimensions_unit,
  		        how_to_reserve          => :how_to_reserve,
		        approval_required_p     => :approval_required_p,
		        address_id		=> :address_id,
		        department_id           => :department_id,   
		        floor                   => :floor,   
		        room                    => :room,   
		        gis                     => :gis,   
		        color                   => :color,
                        reservable_p            => :reservable_p,
                        reservable_p_note       => :reservable_p_note,   
                        special_request_p       => :special_request_p,
		        name                    => :name,   
		        description             => :description,   
		        resource_category_id    => :resource_category_id,   
		        enabled_p               => :enabled_p,   
		        services                => :services,   
			new_email_notify_list   => :new_email_notify_list,
			update_email_notify_list => :update_email_notify_list,
		        property_tag            => :property_tag,   
                        owner_id                => :owner_id,
                        parent_resource_id      => :parent_resource_id,
		        object_type             => :object_type, 
			package_id              => :package_id,  
		        context_id              => :context_id,   
		        creation_user           => :creation_user	
	    );
          end;
      </querytext>
   </fullquery>

   <fullquery name="crs::room::delete.delete_room">
      <querytext>
          begin
		crs_room.del (
   		    room_id => :room_id
		);
	  end;
      </querytext>
   </fullquery>

</queryset>
