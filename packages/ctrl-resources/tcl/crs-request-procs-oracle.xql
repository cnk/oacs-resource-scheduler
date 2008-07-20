<?xml version="1.0"?>

<queryset>
   <fullquery name="crs::request::new.new_request">      
      <querytext>
       begin
          :1 := crs_request.new (
			request_id		=> :request_id,
			repeat_template_id 	=> :repeat_template_id,
			repeat_template_p	=> :repeat_template_p,
			name			=> :name,
        		description 		=> :description,
        		status          	=> :status,
        		reserved_by     	=> :reserved_by,
        		requested_by    	=> :requested_by,
                        package_id      	=> :package_id ,
                        context_id      	=> :context_id
		);
      end;
      </querytext>
   </fullquery>

    <fullquery name="crs::request::delete.do_delete">      
      <querytext>
   	begin
           crs_request.del (
			request_id => :request_id
		);
        end;
      </querytext>
   </fullquery>
</queryset>
