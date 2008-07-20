<?xml version="1.0"?>
<queryset>

<fullquery name="list_images">
<querytext>
	select	image_id, image_name, image_width, image_height
	from	crs_images
	where	resource_id = :resource_id
	order by image_id
</querytext>
</fullquery>

<fullquery name="get_resource_name">
<querytext>
	select	name
	from	crs_resources
	where	resource_id = :resource_id
</querytext>
</fullquery>

</queryset>
