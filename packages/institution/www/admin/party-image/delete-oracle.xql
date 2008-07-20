<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="party_image">
	 <querytext>
		select	p.image_id,
				p.party_id,
				p.image_type_id,
				c.name							as image_type_name,
				p.description,
				p.width,
				p.height,
				dbms_lob.getlength(p.image)		as bytes,
				p.format,
				acs_object.name(p.party_id)		as owner_name,
				decode(acs_permission.permission_p(p.image_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(p.image_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(p.image_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(p.image_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(p.image_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_party_images	p,
				categories			c
		 where	p.image_id			= :image_id
		   and	p.image_type_id		= c.category_id
	 </querytext>
	</fullquery>

	<fullquery name="party_image_delete">
	 <querytext>
		begin
			inst_party_image.delete(:image_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
