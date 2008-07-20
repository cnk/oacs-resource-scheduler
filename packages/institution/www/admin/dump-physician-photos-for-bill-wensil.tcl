ad_page_contract {
	Produce a .zip file with the images of all physicians for whom we have
	photos.

	Ran and sent results to Bill Wensil on 2006/03/07
} {
}

# Strict Permissions check (must be site-wide admin)
ad_maybe_redirect_for_registration
permission::require_permission -object_id [acs_magic_object "security_context_root"] -privilege admin

proc make_filename {dir_suffix ucla_physician_id n mime_type} {
	if {$n > 1} {
		set n [format "-%02d" $n]
	} else {
		set n ""
	}

	switch $mime_type {
		image/bmp	{ set ext "bmp" }
		image/gif	{ set ext "gif" }
		image/jpeg	{ set ext "jpg" }
		default		{ return "" }
	}
	return [format "/tmp/physician-photos%s/%06u%s.%s" $dir_suffix $ucla_physician_id $n $ext]
}

db_foreach physician {
	select	psnl.personnel_id,
			psnl.photo_type,
			nvl(dbms_lob.getlength(psnl.photo), 0) as photo_length,
			pmap.ucla_physician_id
	  from	inst_personnel			psnl,
			ext_physician_id_map	pmap
	 where	psnl.personnel_id		= pmap.inst_physician_id
	   and	pmap.ucla_physician_id	is not null
} {
	set n_photos 0

	if {$photo_length > 0} {
		# produce main photo
		incr n_photos
		set tmpfilename	[make_filename -tmp $ucla_physician_id $n_photos $photo_type]
		set filename	[make_filename "" $ucla_physician_id $n_photos $photo_type]
		if { $tmpfilename != "" && $filename != "" } {
			ns_set icput [ns_conn headers] tmpfilename $tmpfilename
			db_blob_get_file	get_physician_photo "
				select	psnl.photo
				  from	inst_personnel	psnl
				 where	psnl.personnel_id	= $personnel_id
			" -file $tmpfilename
			exec ln -f $tmpfilename $filename
		}
	}

	# produce other photos
	db_foreach get_party_images_metadata {
		select	image_id,
				format
		  from	inst_party_images	img
		 where	img.party_id	= :personnel_id
		   and	(lower(acs_object.name(image_type_id))	like '%portrait%'
				or lower(description)					like '%portrait%'
				 -- or description contains part of name of party
				 )
		   and	dbms_lob.getlength(image) > 0
	} {
		# if { $n_photos > 1 } { break }
		incr n_photos
		set tmpfilename	[make_filename -tmp $ucla_physician_id $n_photos $format]
		set filename	[make_filename "" $ucla_physician_id $n_photos $format]
		if { $tmpfilename != "" && $filename != "" } {
			db_blob_get_file	get_physician_image "
				select	image
				  from	inst_party_images	img
				 where	img.image_id	= $image_id
			" -file $tmpfilename
			exec ln -f $tmpfilename $filename
		}
	}
}
ns_returnnotice 200 done [exec ls -1 /tmp/physician-photos/ | wc -l]