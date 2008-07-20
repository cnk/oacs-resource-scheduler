<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="party_images">
	 <querytext>
		select	distinct i.image_id,
				i.party_id,
				nvl(i.description, '<i>(None)</i>')	as description,
				i.width,
				i.height,
				dbms_lob.getlength(i.image) as bytes,
				i.format,
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
		 where	image_id			in ($items)
		   and	acs_permission.permission_p(i.image_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
