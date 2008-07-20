# -*- tab-width: 4 -*-
ad_page_contract {
	Return the ACCESS portrait for a single person.

	@author				helsleya@cs.ucr.edu (AH)
	@creation-date		2003-08-14
	@cvs-id				$Id: access-portrait.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@param	personnel_id	person to retrieve the access portrait for
} {
	{personnel_id:integer}
}

set subsite_url [site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# if there was no access portrait for this person...
if {[db_0or1row image_metadata {
		select	image_id, format,
				dbms_lob.getlength(image) as image_bytes
		  from	inst_party_images
		 where	party_id				= :personnel_id
		   and	dbms_lob.getlength(image)	> 0
		   and	format					is not null
		   and	image_type_id			= category.lookup('//Image//ACCESS Portrait')
		   and	rownum					< 2
	}] < 1} {

	ad_returnredirect "${subsite_url}images/photo-not-available.gif"
	return
}

set tmpfilename [ns_mktemp "/tmp/inst_axspicXXXXXX"]

db_blob_get_file get_access_personnel_photo "
	select	image
	  from	inst_party_images
	 where	image_id = $image_id
" -file $tmpfilename

ns_returnfile 200 $format $tmpfilename
ns_unlink -nocomplain $tmpfilename
