ad_library {

  @author rhs@mit.edu
  @creation-date 2000-09-07
  @cvs-id $Id: site-nodes-init.tcl,v 1.4 2003-11-27 15:25:18 timoh Exp $

}

nsv_set site_nodes_mutex mutex [ns_mutex create]

site_node::init_cache
