ad_page_contract {
	Return the a single publication.

	@author  nick@ucla.edu
	@creation-date  2004/02/18
	@cvs-id	$Id: publication.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

	@param	publication_id	publication to retrieve
} {
	{publication_id:integer,notnull}
}

# if there was no photo for this person...
if {[db_0or1row photo_metadata {
		select	publication_type
		  from	inst_publications
		 where	publication_id = :publication_id
		   and	dbms_lob.getlength(publication) > 0
		   and	publication_type is not null
	}] < 1} {

	ad_return_error "Error" "The Publication you have selected does not exist."
	return
}

ReturnHeaders "$publication_type"
db_write_blob publication_write "
	select	publication
	  from	inst_publications
	 where	publication_id = $publication_id
"
