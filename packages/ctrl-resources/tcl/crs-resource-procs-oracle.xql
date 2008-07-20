<?xml version="1.0"?>
<queryset> 
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="crs::reservable_resource::delete.delete">
	<querytext>
		begin 
			crs_reservable_resource.del (
				resource_id => :resource_id
			);
		end;
	</querytext>
	</fullquery>

	<fullquery name="crs::resource::delete.delete">
	<querytext>
		begin 
			crs_resource.del (
				resource_id => :resource_id
			);
		end;
	</querytext>
	</fullquery>

	<fullquery name="crs::resource::add_image.add_image">
	<querytext>
		begin 
			:1 := crs_image.new (
				resource_id 	=> :resource_id ,
				image_name   	=> :image_name ,
				image_width 	=> :image_width ,
				image_height	=> :image_height ,
				image_file_type => :image_file_type
			);
		end;
	</querytext>
	</fullquery>

	<fullquery name="crs::resource::delete_image.delete_image">
	<querytext>
		begin 
			crs_image.del (
				image_id => :image_id
			);
		end;
	</querytext>
	</fullquery>

   <fullquery name="crs::resource::rel_add.resource_rel_new">
      <querytext>
         begin
              :1 := ctrl_subsite_for_object_rel.new (
                        subsite_id => :subsite_id,
                        object_id  => :object_id
            );
          end;
      </querytext>
   </fullquery>

   <fullquery name="crs::resource::rel_del.resource_rel_del">
      <querytext>
          begin
                ctrl_subsite_for_object_rel.del (
                        rel_id => :rel_id
                );
          end;
      </querytext>
   </fullquery>

</queryset>
