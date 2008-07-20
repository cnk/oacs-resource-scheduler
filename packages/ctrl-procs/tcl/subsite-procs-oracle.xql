<?xml version="1.0"?>
<queryset>
	<fullquery name="ctrl_procs::subsite::get_subsites.get_subsites">
	 <querytext>
		select	o.object_id
		  from	(select	object_id, name
				   from	site_nodes
				connect	by prior node_id	= parent_id
				  start	with node_id		= :subsite_node_id) n,
				acs_objects		o,
				apm_packages	p
		 where	p.package_key	= 'acs-subsite'
		   and	o.object_id		= p.package_id
		   and	o.object_id		= n.object_id
	 </querytext>
	</fullquery>

	<!--
		This query returns a list of the best hostnames that can be found for
		the subsite uniquely identified by <:subsite_id,:subsite_url>, in order
		of proximity to that subsite (how close it is in the site-map to the
		input <:subsite_id,	:subsite_url>).  The proximity is calculated and
		then prioritized using an Oracle "connect by" query followed by a sort
		on the "level" pseudo-column.  If multiple names match at the same
		level, a heuristic that compares the hostname from the host-node-map
		to the hostname used in the HTTP request is used.  If there is no match,
		then the name is compared to the name used for the root subsite.  If
		there is still no match, then the shortest hostname is used.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-04-26 16:50 PDT
	-->
	<fullquery name="ctrl::subsite::best_url.candidate_url_info">
	 <querytext>
		select	hnm.host					as cnddt_hostname,
				site_node.url(sn.node_id)	as cnddt_subsite_url,
				decode(hnm.host, :hostname_from_request, 1, 0)
					as cnddt_hostname_eq_request_p,
				decode(hnm.host, :hostname_from_server, 1, 0)
					as cnddt_hostname_eq_server_p
		  from	(select	sn1.node_id,
						sn1.object_id,
						level		as depth
				   from	site_nodes	sn1
				connect	by sn1.node_id = prior sn1.parent_id
				  start	with sn1.node_id =
						(select	sn2.node_id
						   from	site_nodes sn2
						  where	sn2.object_id				= :subsite_id
							and	site_node.url(sn2.node_id)	= :subsite_url))	sn,
				host_node_map													hnm
		 where	hnm.node_id					= sn.node_id
		 order	by depth					asc,
				cnddt_hostname_eq_request_p	desc,
				cnddt_hostname_eq_server_p	desc,
				length(host)				asc
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
