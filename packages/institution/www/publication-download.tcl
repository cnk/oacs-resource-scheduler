# /packages/institution/www/publication-download.tcl
ad_page_contract {
	Return the a single publication.

	@author			helsleya@cs.ucr.edu
	@creation-date	2005/01/14
	@cvs-id			$Id: publication-download.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@param	publication_id	publication to retrieve
} {
	{publication_id:integer,notnull}
}

# /web/ucla/packages/institution/www/publication-download.tcl
# /web/ucla/www/healthsciences/dgsom/institution/publication-download.tcl
# /web/ucla/www/healthsciences/dgsom/research/institution/publication-download.tcl

# get metadata
if {[db_0or1row publication_metadata {
		select	publication_type,
				dbms_lob.getlength(publication)	as n_bytes
		  from	inst_publications
		 where	publication_id = :publication_id
		   and	dbms_lob.getlength(publication) > 0
		   and	publication_type is not null
	}] < 1} {

	# if there was no publication for this person
	ad_return_complaint 1 "The Publication you have selected does not exist."
	return
}

# ignore certain robots (robots.txt is not flexible enough to help us here)
set user_agent [ns_set iget [ns_conn headers] User-Agent]
if {$n_bytes > 60000 &&
	[regexp [join [list					\
					"Ask Jeeves"		\
					ConveraCrawler		\
					BecomeBot			\
					Gigabot				\
					RufusBot			\
					Jyxobot				\
					msnbot				\
					Webdup				\
					WebVac				\
					ichiro				\
				  ] "|"] \
		 $user_agent]} {
	ad_return_complaint 1 {
		Your web crawler/broswer isn't polite enough with large binaries
		(&gt;60KB) to be allowed to index/view this data.  You may have reached
		this web page through a search engine.  If so, it is most likely that
		the problem lies with the search engine.  If not, please use another
		browser to access this data, or contact the system administrator.
	}
	return
}

# write out the HTTP headers along with the content length
set extra_headers "HTTP/1.0 200 OK\r
MIME-Version: 1.0\r
Content-Type: $publication_type\r
Content-Length: $n_bytes\r
"

util_WriteWithExtraOutputHeaders $extra_headers
ns_startcontent -type $publication_type

# if it is an HTTP GET, start sending the data for the publication from the DB
if {[ns_conn method] == "GET"} {
	db_write_blob publication_write "
		select	publication
		  from	inst_publications
		 where	publication_id = $publication_id
	"
}