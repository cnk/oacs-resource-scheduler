# -*- tab-width: 4 -*-
ad_page_contract {
	Return the requested resume.

	@author				helsleya@cs.ucr.edu (AH)
	@creation-date		2004-12-08
	@cvs-id				$Id: resume-download.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@param	resume_id	the resume to retrieve
} {
	{resume_id:integer}
}

# if there was no resume...
if {[db_0or1row resume_metadata {
		select	format
		  from	inst_personnel_resumes
		 where	resume_id = :resume_id
		   and	dbms_lob.getlength(content) > 0
		   and	format is not null
	}] < 1} {

	ad_return_exception_page 404 "Resume does not exist or is plain text." {
		The resume you requested does not exist or is not available for
		download.
	}
#	ad_returnredirect "@subsite_url@images/photo-not-available.gif"
	return
}

# get a filename for temporary storage on disk
set tmpfilename [ns_mktemp "/tmp/inst_personnel_resumeXXXXXX"]

# double quotes need to be used here, otherwise an error occurs
# (looks like db_blob_get_file doesn't allow bind variables)
db_blob_get_file get_personnel_resume "
	select	content
	  from	inst_personnel_resumes
	 where	resume_id = $resume_id
" -file $tmpfilename

# send resume data to the browser
ns_returnfile 200 $format $tmpfilename

# delete from disk
ns_unlink -nocomplain $tmpfilename
