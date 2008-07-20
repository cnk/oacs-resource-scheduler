<?xml version="1.0"?>
<queryset> 

   <fullquery name="ctrl::address::new.new">
      <querytext>
          begin
              :1 := ctrl_address.new (
			address_id 		=> :address_id,
			address_type_id		=> :address_type_id,
			room			=> :room,
		        description             => :description,
			floor			=> :floor,
			building_id		=> :building_id,
			address_line_1		=> :address_line_1,
			address_line_2		=> :address_line_2,
			address_line_3		=> :address_line_3,
			address_line_4		=> :address_line_4,
			address_line_5		=> :address_line_5,
			city			=> :city,
			fips_state_code		=> :fips_state_code,
			zipcode			=> :zipcode,
			zipcode_ext		=> :zipcode_ext,
			fips_country_code	=> :fips_country_code,
			gis			=> :gis,
		        context_id              => :context_id,   
		        creation_user           => :creation_user
	    );
          end;
      </querytext>
   </fullquery>


   <fullquery name="ctrl::address::delete.delete">      
      <querytext>
	begin
		 ctrl_address.del (
                        address_id               => :address_id
		 );
	end;
      </querytext>
   </fullquery>


   <fullquery name="ctrl::address::update.update">      
      <querytext>
        begin
                 ctrl_address.del (
                        address_id               => :address_id
                 );
        end;
      </querytext>
   </fullquery>


</queryset>
