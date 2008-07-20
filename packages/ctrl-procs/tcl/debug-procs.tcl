# -*- tab-width: 4 -*-
ad_library {
	Procs for working extracting debugging information.

	@author			helsleya@cs.ucr.edu (ACH)
	@creation-date	2005-05-06 13:15 PDT
	@cvs-id			$Id: debug-procs.tcl,v 1.1 2005/05/06 20:55:13 andy Exp $
}

namespace eval ctrl::debug {}

ad_proc -public ctrl::debug::message {
	{-message}
} {
	@param	message	The basic debugging information, usually a stack trace.
	@return			A new debug message including the values of important vars.
	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-05-06 13:15 PDT
} {
	if {![exists_and_not_null message]} {
		upvar #0 errorInfo message
	}
	set div "\n\n###############################################################################\n"
	regsub "^.*@" [db_get_sql_user] "" db_server_name	;# this may not work with postgres
	set www_server_name [string trim [exec hostname -s]]

	set message "[ad_system_name] Error Report, ($www_server_name/$db_server_name) @ ([ns_fmttime [ns_time] "%D %T"]):\n\n$message"

	############################################################################
	# NS_CONN variables ########################################################
	append message $div "ns_conn Variables:\n"
	foreach {conn_var} {driver peeraddr request protocol version query method host port url location} {
		append message "\t\[ns_conn $conn_var\]\t= \"[ns_conn $conn_var]\"\n"
	}

	# REFERER, etc.
	set headers [ns_conn headers]
	append message $div "\t\[ns_conn headers\]:\n"
	for {set i 0} {$i < [ns_set size $headers]} {incr i} {
		set key [ns_set key $headers $i]
		append message "\t\t\[ns_set iget \[ns_conn headers\] $key\]\t=\t\"[ns_set get $headers $key]\"\n"
	}
	append message $div "referer = \"[ns_set iget $headers referer]\"\n"

	# POST, GET, or multipart FORM variables:
	#//TODO// only display first 4096 bytes of each value
	append message $div "ns_getform Variables:\n"
	set form_vars [ns_getform]
	if {![empty_string_p $form_vars]} {
		for {set i 0} {$i < [ns_set size $form_vars]} {incr i} {
			append message "\t\[ns_set get \[ns_getform\] \"[ns_set key $form_vars $i]\"\]\t= \"[ns_set value $form_vars $i]\"\n"
		}
	}

	############################################################################
	# AD_CONN variables ########################################################
	append message $div "ad_conn Variables:\n"
	foreach {conn_var conn_val} [ad_conn all] {
		append message "\t\[ad_conn $conn_var\]\t= \"$conn_val\"\n"
	}
	append message "\t\[ad_conn url\]\t= \"[ad_conn url]\"\n"

	return message
}