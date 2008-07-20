#ad_page_contract {
#	Return the publication
#
#	@author		nick@ucla.edu
#	@creation-date	2004/02/09
#	@cvs-id		$Id: publication-template.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
#
#	@param	publication_id	person to retrieve the photo for
#} {
#	{publication_id:integer}
#}

# if there was no photo for this person...
if {[db_0or1row photo_metadata {
		select	publication
		  from	inst_publications
		 where	publication_id = :publication_id
		   and	dbms_lob.getlength(photo) > 0
	}] < 1} {

	ad_returnredirect "@subsite_url@images/photo-not-available.gif"
	return
}

set tmpfilename [ns_mktemp "/tmp/inst_photoXXXXXX"]

db_blob_get_file get_personnel_photo "select photo from inst_personnel where personnel_id = $personnel_id" \
 -file $tmpfilename

ns_returnfile 200 $photo_type $tmpfilename
ns_unlink -nocomplain $tmpfilename

