# /packages/ctrl-procs.tcl/subsite-procs.tcl				-*- tab-width: 4 -*-
ad_library {

	Subsite Helper Procedures

	@creation-date 11/11/2004
	@cvs-id $Id: subsite-procs.tcl,v 1.5 2007/06/25 21:38:02 andy Exp $
}

namespace eval ctrl_procs::subsite {}

ad_proc -public ctrl_procs::subsite::get_subsite_node_id {
	{-node_id}
} {
	Get the subsite_node_id nearest node_id or the top level subsite id
	if node_id is not passed in

	@author Jeff Wang
	@creation-date 11/11/2004

} {
	if [exists_and_not_null node_id] {
		set parent_node_id [site_node::get_parent_id -node_id $node_id]
		set subsite_package_id [site_node::get_object_id -node_id $parent_node_id]
	} else {
		set subsite_package_id [site_node_closest_ancestor_package "acs-subsite"]
	}

	set subsite_node_id	 [site_node::get_node_id_from_object_id -object_id $subsite_package_id]
	return $subsite_node_id
}


ad_proc -public ctrl_procs::subsite::get_subsite_url {
} {
	Get the url of this subsite

	@author Jeff Wang
	@creation-date 11/11/2004

} {
	set subsite_node_id [ctrl_procs::get_subsite_node_id]
	return [site_node::get_url -node_id $subsite_node_id]
}

ad_proc -public ctrl_procs::subsite::get_subsites {} {
	Get all the subsites under the current subsite, including the
	current subsite.

	@return a list of subsite_ids mounted under current subsite_id, including the current subsite_id
	@author Jeff Wang
	@creation-date 11/11/2004

} {
	set subsite_node_id [scp::util::get_subsite_node_id]
	return [db_list get_subsites {}]
}

ad_proc -public ctrl_procs::subsite::get_main_subsite_id {} {

	Returns the subsite_id of the main(default) subsite

	@author Avni Khatri (avni@ctrl.ucla.edu)
	@creation-date 11/11/2004
} {
	return [site_node_closest_ancestor_package -url "/" "acs-subsite"]
}

namespace eval ctrl::subsite {}
ad_proc -private ctrl::subsite::best_url {
	{-subsite_id	"[ad_conn subsite_id]"}
	{-subsite_url	[site_node_closest_ancestor_package_url]}
} {
	<p>This proc returns a URL that is the "best" to access the root of the given
	subsite.</p>

	<h3>The meaning of "best":</h3>
	<p>
	The heuristics for choosing the "best" host-node-map entry, in order of
	preference are:
	<blockquote>
		<ol>
		<li>proximity in the site-map to the input subsite_url
		<li>comparison with the hostname from the HTTP "Host" header
		<li>comparison with the hostname from the AOLserver configuration file
		<li>length of hostname
		</ol>

		... and if there are no host-node-map entries for subsites which are
		prefixes of the input subsite_url, then the HTTP "host" header is used.
	</blockquote>
	Except for the last possibility, all of the above preferences (1-4) are
	implemented in an SQL query.
	</p>

	<h3>Motivation:</h3>
	<p>???//TODO//???</p>

	<p>
	<span style="color: maroon">WARNING:</span> because this proc uses the HTTP
	"Host" header in the algorithm to find the "best" url for the subsite,
	caching of this using
	<a href="/api-doc/proc-view?proc=util%5fmemoize">util_memoize</a> could
	allow a cache-poisoning Denial-of-Service (DOS) attack.  Memoization of
	additional parameters may mitigate this, but at the cost of elminating most
	the savings gained.
	</p>

	@param	subsite_id	ID of the subsite
	@param	subsite_url	"URL" used to access the subsite.  This is really the
						full path to the subsite as found in the /admin/site-map
						and the /admin/host-node-map tables.

	@return				The URL that is the "best" to access the root of the
						given subsite.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-04-26 17:51 PDT
} {
	# Process default values since ad_proc isn't as flexible as ad_page_contract
	set subsite_id	[subst $subsite_id]
	set subsite_url [subst $subsite_url]

	# Get server configuration information
	set	nssock_cfg				ns/server/[ns_info server]/module/nssock
	set	ip_from_server			[ns_config $nssock_cfg address]			;#//TODO// won't this break in a NAT'd cluster?
	set	hostname_from_server	[ns_config $nssock_cfg hostname]

	# Get request URL information
	ctrl::url::parse -url		[ns_conn location] -into request_url
	set protocol				$request_url(protocol)
	set port					$request_url(_port)
	set hostname_from_request	[ad_host]

	# Choose the "best" match from the nearest site-node in the Host-Node Map.
	# "best" is measured by (in order of priority):
	#	proximity in the site-map to the input subsite_url
	#	comparison with the hostname from the HTTP "Host" header
	#	comparison with the hostname from the AOLserver configuration file
	#	length of hostname
	db_foreach candidate_url_info {} {
		# To avoid the exec of 'dig', we assume that all names in the Host-Node
		# Map refer to the IP this AOLserver instance listens on.  Two
		# important cases exist where this assumption is not true and therefore
		# this check would be useful:
		#
		#	1. Administrator registers a host-node-map entry prior to creating a
		#		DNS name that points to the IP this AOLserver instance is
		#		already listening on.
		#
		#	2. Administrator registers a host-node-map entry prior to changing
		#		an existing DNS name to point to the IP this AOLserver instance
		#		is already listening on.
		#
		# In these cases, the check would help us avoid building obviously-bad
		# URLs while the DNS information is in limbo.

		#-set cnddt_ip [exec dig +short $cnddt_hostname | tail -n 1]
		#-if {$cnddt_ip == $ip_from_server} {
			set best_hostname		$cnddt_hostname
			set best_subsite_url	$cnddt_subsite_url
			break
		#-}
	}

	if {![exists_and_not_null best_hostname]} {
		set best_hostname		$hostname_from_request
		set best_subsite_url	"/"
	}

	# subtract best_subsite_url from the beginning of subsite_url
	regsub "^$best_subsite_url" $subsite_url "" subsite_url

	set url_base "${protocol}://$best_hostname$port/$subsite_url"
	return $url_base
}
