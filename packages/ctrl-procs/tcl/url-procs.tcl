# -*- tab-width: 4 -*-
ad_library {
	Procs for working with URLs.

	@author			helsleya@cs.ucr.edu (ACH)
	@creation-date	2005-04-26
	@cvs-id			$Id: url-procs.tcl,v 1.5 2005/05/10 17:21:07 marc Exp $
}

namespace eval ctrl::url {}

ad_proc -public ctrl::url::parse {
	{-url:required}
	{-get}
	{-into}
} {
	<p>Parses a URL into its component pieces.  It provides a rich set of
	identified parts, but is not strictly standards adherent.  For example, it
	is capable of parsing out a username and password from HTTP urls as well as
	FTP URLs even though only the FTP standard provides for including this
	information in a URL.
	</p>

	<p>Pass the <code>-get</code> parameter to extract a single part.  Pass
	the <code>into</code> parameter to populate an array with the pieces
	of the URL.  If neither of these parameters is passed, then a list is
	returned with all of the parts of the URL suitable for passing to
	<code><a href="http://tcl.activestate.com/man/tcl7.6/TclCmd/array.n.html#M11">
			array set</a></code>.
	</p>

	<p>Example URL: <code>http://foo:bar@ftp.cdrom.com:21/pub/mirror/readme.pl?skip_copyright=1&bold_changes=0#bottom</code>
	</p>

	<p>The components extracted are:
	<ul><li><b>all</b>			</li>
		<li><b>base</b>			(<code>http://foo:bar@ftp.cdrom.com</code>)</li>
		<li><b>protocol_</b>	(<code>http://</code>)</li>
		<li><b>protocol</b>		(<code>http</code>)</li>
		<li><b>login_</b>		(<code>foo:bar@</code>)</li>
		<li><b>login</b>		(<code>foo:bar</code>)</li>
		<li><b>username</b>		(<code>foo</code>)</li>
		<li><b>_password</b>	(<code>:bar</code>)</li>
		<li><b>password</b>		(<code>bar</code>)</li>
		<li><b>hostname</b>		(<code>ftp.cdrom.com</code>)</li>
		<li><b>_port</b>		(<code>:21</code>)</li>
		<li><b>port</b>			(<code>21</code>)</li>
		<li><b>path</b>			(<code>/pub/mirror/readme.pl</code>)</li>
		<li><b>_query</b>		(<code>?skip_copyright=1&bold_changes=0</code>)</li>
		<li><b>query</b>		(<code>skip_copyright=1&bold_changes=0</code>)</li>
		<li><b>_anchor</b>		(<code>#bottom</code>)</li>
		<li><b>anchor</b>		(<code>bottom</code>)</li>
	</ul>
	</p>

	<p>No apologies are offered if the names of the components above differ from
	official terminology used in the RFCs defining the URI standards.  Some of
	the RFCs for URLs/URIs are:
	<blockquote>
		<a href="ftp://ftp.rfc-editor.org/in-notes/rfc1738.txt">
			RFC 1738</a> (absolute URLs)<br>
		<a href="ftp://ftp.rfc-editor.org/in-notes/rfc1808.txt">
			RFC 1808</a> (relative URLs)<br>
		<a href="ftp://ftp.rfc-editor.org/in-notes/rfc2368.txt">
			RFC 2368</a> (the mailto: scheme)<br>
	</blockquote>
	RFC 1808 (and probably 1738 too) is superseded by:
	<blockquote>
		<a href="ftp://ftp.rfc-editor.org/in-notes/rfc3986.txt">
			RFC 3986</a> (generic URI syntax)<br>
	</blockquote>
	A list of URL schemes can be found at:
	<blockquote>
		<a href="http://www.w3.org/Addressing/schemes.html">
			http://www.w3.org/Addressing/schemes.html
		</a>
	</blockquote>
	</p>

	@param	url		The URL to be parsed
	@param	get		The part of the URL to retrieve
	@param	into	The array to store the parts of the URL in
	@return			The part of the URL requested in the -get parameter
					<br>or<br>
					A list with all parts of the URL suitable for use with
					<code><a href="http://tcl.activestate.com/man/tcl7.6/TclCmd/array.n.html#M11">
							array set</a></code>
					<br>or<br>
					1 if the URL was successfully parsed, 0 otherwise

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-04-26 18:48 PDT
} {
	# This is a very complex regular expression.  It is purposefully written
	# this way so that it can be commented and more easily understood.  The
	# later 'regsub' calls clean it up so it can be used by 'regexp'.  Otherwise
	# it would have to be written:
	#	{^((([^:/]+)://)((([^:]+)(:([^@:/]*))?)@)?([^:]+)(:([0-9]+))?)?([^?#]*)([?]([^#]*))?(#([^#]+))?$}
	# which most people would agree is incomprehensible by anyone who's head is
	# small enough to fit in an MRI machine.
	set url_parse_regexp {
		^	(							;# base
				(						;# protocol-with-slashes
					([^:/]+)			;# protocol					(AKA "scheme")
					://
				)
				(						;# login-with-at
					(					;# login
						([^:]+)			;# username
						(:				;# password-with-colon
							([^@:/]*)	;# password
						)?
					)
					@
				)?
				([^:]+)					;# hostname
				(:						;# port-with-colon
					([0-9]+)			;# port
				)?
			)?
			([^?#]*)					;# path
			([?]						;# query-with-question-mark
				([^#]*)					;# query
			)?
			(#							;# anchor-with-pound
				([^#]+)					;# anchor					(AKA "fragment")
			)?
		$
	}
	regsub -all -- {;#[^\n]*\n} $url_parse_regexp {} url_parse_regexp
	regsub -all -- {[ \n\r\t\\]} $url_parse_regexp {} url_parse_regexp

	# Parse and save into variables (variables with and underscore at the
	#	beginning or end have a piece of connective-text at their beginning
	#	or end respectively)
	set parse_successful_p [regexp -- $url_parse_regexp	\
		$url											\
		all												\
		base											\
		protocol_										\
		protocol										\
		login_											\
		login											\
		username										\
		_password										\
		password										\
		hostname										\
		_port											\
		port											\
		path											\
		_query											\
		query											\
		_anchor											\
		anchor
	]

	# Save into an array
	if {![exists_and_not_null get]} {
		set values [list			\
			all			$all		\
			base		$base		\
			protocol_	$protocol_	\
			protocol	$protocol	\
			login_		$login_		\
			login		$login		\
			username	$username	\
			_password	$_password	\
			password	$password	\
			hostname	$hostname	\
			_port		$_port		\
			port		$port		\
			path		$path		\
			_query		$_query		\
			query		$query		\
			_anchor		$_anchor	\
			anchor		$anchor
		]
		if {[exists_and_not_null into]} {
			upvar $into url_pieces
			array set url_pieces $values
			return $parse_successful_p
		}
		return $values
	}

	return [subst $$get]
}
