# -*- tab-width: 4 -*-
ad_library {
	Hypertext Transfer Protocol utility Procs from CTRL

	@author			helsleya@cs.ucr.edu (ACH)
	@creation-date	2004-08-31
	@cvs-id			$Id: http-procs.tcl,v 1.6 2005/05/13 00:10:57 andy Exp $
}

namespace eval ctrl {}

ad_proc -public ctrl::set_charset {
	{charset "utf-8"}
} {
	Set the "charset" part of the "Content-Type" HTTP header.  The default
	charset of returned pages is "iso-8859-1" or whatever is specified in the
	AOLserver startup file.  When this proc is called, the default value for
	the "charset" parameter is "utf-8".

	@author		helsleya@cs.ucr.edu
	@param		charset
} {
	set headers			[ad_conn outputheaders]
	set content_type	[ns_set get $headers "Content-Type"]
	#//TODO// change the charset if it exists, don't just append
	ns_set put $headers	"Content-Type" "$content_type; charset=$charset"
}

ad_proc -public ctrl::external_redirect {
	{-protocol					"http"}
	{-hostname:required}
	{-port:required				""}
	{-base_path:required		""}
	{-allow_deep_link:boolean}
	{-remote_index				"index.html"}
} {
	<p>Redirect the client to an external site.  Uses <code>[ad_conn ...]</code>
	and <code>[ns_conn ...]</code> calls to extract parts of the remote-path and
	query string.  If you pass <code>-allow_deep_link</code> then the client
	will be forwarded to a URL that includes pieces of their original path and
	query.</p>

	@param	protocol		The protocol the client will be using.
	@param	hostname		The hostname of the external site.
	@param	port			The port to access on the external site.
	@param	base_path		The base path of the external site to which the
							unmatched part of the original request will be
							appended in the final URL.
	@param	allow_deep_link	Pass this to allow the construction of deep-links.
	@param	remote_index	The name the remote-server uses as the default file
							to be accessed when the last path component of a URLd
							is a directory and not a file.
	@return					The URL the client was directed to.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-03-04 14:57 PST
} {
	if {$allow_deep_link_p} {
		set remote_path [ad_conn path_info]
		if {[empty_string_p $remote_path]} {
			set remote_path $remote_index
		}

		set query [ns_conn query]
		if {![empty_string_p $query]} {
			set query "?$query"
		}
	} else {
		set remote_path	""
		set query		""
	}

	if {[exists_and_not_null protocol] && ![regexp {://$} $protocol]} {
		append protocol "://"
	}

	if {[exists_and_not_null port] && ![regexp {^:} $port]} {
		set port ":$port"
	}

	if {[exists_and_not_null base_path]} {
		if {![regexp {^/} $base_path]} {
			set base_path "/$base_path"
		}
		if {![regexp {/$} $base_path]} {
			append base_path "/"
		}
	} elseif {![empty_string_p $remote_path] || ![empty_string_p $query]} {
		set base_path "/"
	}

	set result_url "$protocol$hostname$port$base_path$remote_path$query"
	template::forward $result_url

	return $result_url
}