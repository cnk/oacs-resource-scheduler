# -*- tab-width: 4 -*-
# /packages/institution/tcl/string-procs.tcl
ad_library {
    Procs for building strings.

    @author			helsleya@cs.ucr.edu
    @creation-date	2005/07/07
    @cvs-id			$Id: string-procs.tcl,v 1.1 2005/08/09 03:26:49 avni Exp $

    @ctrl::string::wrap
}

namespace eval ctrl::string {}

ad_proc -public ctrl::string::wrap {
	{preamble}
	{string}
	{postamble}
} {
	Wrap the string <var>string</var> between two other strings if-and-only-if
	<var>string</var> is not empty.  If <var>string</var> is empty, the empty
	string (<code>""</code>) is returned.

	@param	preamble	The string to place before <var>string</var>.
	@param	string		The string to be wrapped.
	@param	postamble	The string to place after <var>string</var>.
	@return				The result of concatenating all three strings,
						unless <var>string</var> is empty, in which case
						<code>""</code>.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-07-07 15:28 PDT
} {
	if {$string == ""} {
		return ""
	}

	return [append result $preamble $string $postamble]
}