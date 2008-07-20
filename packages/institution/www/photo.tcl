# -*- tab-width: 4 -*-
ad_page_contract {
	Return the photo for a single person.

	@author				helsleya@cs.ucr.edu (AH)
	@creation-date		2003-08-14
	@cvs-id				$Id: photo.tcl,v 1.2 2007/02/28 01:38:17 glacson Exp $

	@param	personnel_id	person to retrieve the photo for
} {
	{personnel_id:integer}
}

set subsite_url [site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# if there was no photo for this person...
if {[db_0or1row photo_metadata {
		select	photo_type,
				dbms_lob.getlength(photo) as photo_bytes
		  from	inst_personnel
		 where	personnel_id				= :personnel_id
		   and	dbms_lob.getlength(photo)	> 0
		   and	photo_type					is not null
	}] < 1} {

	ad_returnredirect "${subsite_url}institution/images/photo-not-available.gif"
	return
}

set tmpfilename [ns_mktemp "/tmp/inst_photoXXXXXX"]

db_blob_get_file get_personnel_photo "
	select	photo
	  from	inst_personnel
	 where	personnel_id = $personnel_id
" -file $tmpfilename

ns_returnfile 200 $photo_type $tmpfilename
ns_unlink -nocomplain $tmpfilename
