# -*- tab-width: 4 -*-
ad_page_contract {
	Return the photo for a single person.

	@author				helsleya@cs.ucr.edu (AH)
	@creation-date		2003-08-14
	@cvs-id				$Id: photo.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

	@param	personnel_id	person to retrieve the photo for
} {
	{personnel_id:integer}
}

# if there was no photo for this person...
if {[db_0or1row photo_metadata {
		select	photo_type
		  from	inst_personnel
		 where	personnel_id = :personnel_id
		   and	dbms_lob.getlength(photo) > 0
		   and	photo_type is not null
	}] < 1} {

	ad_returnredirect "@subsite_url@images/photo-not-available.gif"
	return
}

set tmpfilename [ns_mktemp "/tmp/inst_photoXXXXXX"]

db_blob_get_file get_personnel_photo "select photo from inst_personnel where personnel_id = $personnel_id" \
 -file $tmpfilename

ns_returnfile 200 $photo_type $tmpfilename
ns_unlink -nocomplain $tmpfilename