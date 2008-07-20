# -*- tab-width: 4 -*-
# /packages/acs-4x/tcl/encoding-procs.tcl
ad_library {

	Helpers for processing text and OACS objects.

	@author helsleya@cs.ucr.edu (AH)
	@creation-date 2003/07/23
	@cvs-id $Id: encoding-procs.tcl,v 1.6 2005/04/04 19:07:04 andy Exp $
}

namespace eval ctrl {}

ad_proc -public ctrl::quote_js {
	str_to_quote
	{quote "'"}
} {
	Quotes a string to be used as a Javascript string.

	@author helsleya@cs.ucr.edu (AH)
	@creation-date 2003/07/23

	@param	str_to_quote	The string that will eventually be placed into some
							JavaScript as a JavaScript string.
	@param	quote			The quote-character that will be used (note that
							<code>quote_js</code> will not place this around the
							string that you pass to it).
	@return The string quoted for Javascript
} {
	regsub -all $quote $str_to_quote \\$quote quoted_str
	return $quoted_str
}

ad_proc -public ctrl::data_size {
	{-max_digits}
	{-min_digits}
	{-bytes}
	{-bits}
	{-tens:boolean}
} {
	Produces a string representing a number of bytes in <q>human-readable</q> form.

	@author helsleya@cs.ucr.edu (AH)
	@creation-date 2004/05/19

	@param	The number to convert to a human-readable representation.
	@return The string representing the amount of data in human-readable format.
} {
	# determine the suffix and the divisor
	if {$bytes >= 1073741824} {
		set suffix	" GB"
		set divisor	1073741824.0
	} elseif {$bytes >= 1048576} {
		set suffix	" MB"
		set divisor	1048576.0
	} elseif {$bytes >= 1024} {
		set suffix	" KB"
		set divisor	1024.0
	} else {
		set suffix " B"
		set divisor 1.0
	}

	# calculate the fraction
	set n [expr $bytes / $divisor]

	# trim to the right number of digits, only remove digits from fractional part of number
	if {[exists_and_not_null max_digits]} {
		regexp {([+-])?([0-9]+)(.[0-9]+)?} $n all sign whole frac
		set frac_goal_len [expr $max_digits - [string length $whole]]
		set frac [string range $frac 0 $frac_goal_len]
		regsub {^.0+$} $frac {} frac

		append result $sign $whole $frac $suffix
	} else {
		append result $n $suffix
	}

	return $result
}

ad_proc -public ctrl::coalesce {
	{-default ""}
	args
} {
	This function is similar to SQL&apos;s <code>coalesce</code> function.
	The inputs to this function should be a list of references to TCL variables.
	The value of the first defined, non-empty variable is returned.

	@param	<i>ref</i>...	The variable references
	@return					The value of the first defined, non-empty variable,
							<code>$default</code> if there are none.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-03-28 20:53 PST
} {
	foreach ref $args {
		upvar $ref var
		if {[array exists var] || ([info exists var] && $var != "")} {
			return $var
		}
	}
	return $default
}