<?xml version="1.0"?>
<queryset>
<fullquery name="get_image_file_type">
<querytext>
	select	image_file_type
	from	crs_images
	where	image_id = :image_id
</querytext>
</fullquery>

<fullquery name="show_image">
<querytext>
	select 	image
	from	crs_images
	where	image_id = $image_id
</querytext>
</fullquery>

</queryset>
