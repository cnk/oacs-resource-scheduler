<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="party_image">
	 <querytext>
		select	i.image_id,
				i.party_id,
				i.image_type_id,
				i.description,
				i.image,
				acs_object.name(i.party_id) as owner_name,
				decode(acs_permission.permission_p(i.image_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(i.image_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(i.image_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(i.image_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(i.image_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_party_images	i
		 where	i.image_id	= :image_id
	 </querytext>
	</fullquery>

	<fullquery name="party_image_name">
	 <querytext>
		select description
		  from inst_party_images
		 where image_id = :image_id
	 </querytext>
	</fullquery>

	<fullquery name="party_image_new">
	 <querytext>
		begin
			:1 := inst_party_image.new(
				owner_id			=> :party_id,
				type_id				=> :image_type_id,
				description			=> :description,
				height				=> :height,
				width				=> :width,
				format				=> :format,
				creation_user		=> :user_id,
				creation_ip			=> :peer_ip,
				context_id			=> :party_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="party_image_edit">
	 <querytext>
		update	inst_party_images
		   set	party_id		= :party_id,
				image_type_id	= :image_type_id,
				description		= :description
		 where	image_id		= :image_id
	 </querytext>
	</fullquery>

	<fullquery name="party_image_update_blob">
	 <querytext>
		update	inst_party_images
		   set	image		= empty_blob(),
				height		= :height,
				width		= :width,
				format		= :format
		 where	image_id	= :image_id
		returning image into :1
	 </querytext>
	</fullquery>

	<fullquery name="modified">
	 <querytext>
		update	acs_objects
		   set	last_modified	= sysdate,
				modifying_user	= :user_id,
				modifying_ip	= :peer_ip
		 where	object_id		= :image_id
	 </querytext>
	</fullquery>

	<fullquery name="party_image_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		 start	with parent_category_id	= category.lookup('//Image')
		connect	by prior category_id	= parent_category_id
		 order by name
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
