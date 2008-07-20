<?xml version="1.0"?>
<queryset>
<fullquery name="list_images">
<querytext>
	select	image_id, image_name, image_file_type
	from	crs_images
	where	resource_id = :resource_id
	order by image_id
</querytext>
</fullquery>

<fullquery name="show_image">
<querytext>
	select 	image
	from	crs_images
	where	image_id = :image_id
</querytext>
</fullquery>

</queryset>
