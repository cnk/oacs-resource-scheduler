<?xml version=1.0?>
  <queryset>

<!-- START ctrl::cal::filter::new.new -->
<fullquery name="ctrl::cal::filter::new.new">
  <querytext>
	begin
	   :1 := ctrl_calendar_filter.new (
		cal_filter_id 	=> :cal_filter_id,
		filter_name 	=> :filter_name, 
		description 	=> :description, 
		cal_id 		=> :cal_id, 
		filter_type 	=> :filter_type,
		creation_user	=> :user_id,
		context_id	=> :context_id,
		package_id	=> :package_id
	   );
	end;
  </querytext>
</fullquery>
	 
<!-- START ctrl::cal::filter::remove.remove -->
<fullquery name="ctrl::cal::filter::remove.remove">
  <querytext>
   begin
	ctrl_calendar_filter.del (
           cal_filter_id =>	:cal_filter_id
	);
   end;		
  </querytext>
</fullquery>
<!-- END ctrl::cal::filter::remove.remove -->
</queryset>
