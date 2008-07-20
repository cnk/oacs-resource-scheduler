# -*- tab-width: 4 -*-
ad_page_contract {
	Return the requested image.

	@author				helsleya@cs.ucr.edu (AH)
	@creation-date		2003-05-18
	@cvs-id				$Id: party-image-view.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@param	image_id	the image to retrieve
} {
	{image_id:integer}
}

# if there was no image...
if {[db_0or1row image_metadata {
		select	format
		  from	inst_party_images
		 where	image_id = :image_id
		   and	dbms_lob.getlength(image) > 0
		   and	format is not null
	}] < 1} {

	ad_returnredirect "@subsite_url@images/photo-not-available.gif"
	return
}

# get a filename for temporary storage on disk
set tmpfilename [ns_mktemp "/tmp/inst_party_imageXXXXXX"]

# double quotes need to be used here, otherwise an error occurs
# (looks like db_blob_get_file doesn't allow bind variables)
db_blob_get_file get_party_image "
	select	image
	  from	inst_party_images
	 where	image_id = $image_id
" -file $tmpfilename

# send image data to the browser
ns_returnfile 200 $format $tmpfilename

# delete from disk
ns_unlink -nocomplain $tmpfilename
