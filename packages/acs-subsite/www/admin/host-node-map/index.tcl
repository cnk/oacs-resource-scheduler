ad_page_contract {
    @author Mark Dettinger (mdettinger@arsdigita.com)
    @author Michael Steigman (michael@steigman.net)
    @creation-date 2000-10-24
    @cvs-id $Id: index.tcl,v 1.8 2005-03-13 00:59:52 michaels Exp $
} {
}

set page_title "Host-Node Map"
set context [list "Host-Node Map"]

template::list::create \
    -name host_node_pairs \
    -multirow host_node_pairs \
    -key node_id \
    -elements {
	host {
	    label "Hostname"
	}
	node_id {
	    label "Root Node"
	} 
	url {
	    label "Root URL"
	}
	delete_url {
	    display_template "<if @host_node_pairs.delete_url@ not nil><a href=\"@host_node_pairs.delete_url@\" title=\"Delete this mapping\">delete</a></if>"
	}
    }
	    
template::multirow create host_node_pairs host node_id url delete_url
template::multirow append host_node_pairs \
    [ns_config ns/server/[ns_info server]/module/nssock Hostname] \
    [db_string root_id  "select site_node.node_id('/') from dual"] \
    "/" \
    ""

db_multirow -extend {delete_url} -append host_node_pairs select_host_node_pairs {} {
    set delete_url [export_vars -base delete {host node_id}]
}

set node_list [list]
foreach node_id [site_node::get_children -all -element node_id -node_id [site_node::get_node_id -url "/"]] { 
    lappend node_list [list [site_node::get_element -node_id $node_id -element url] $node_id]
}
set sorted_node_list [lsort $node_list]

ad_form -name add_host_node_mapping -form {
    {host:text(text)
	{label "Hostname"}
	{html {size 40}}
	{value "mydomain.com"}
	{help_text "Hostname must be unique"}
    }
    {root:text(radio)
	{label "Root Node"}
	{options $sorted_node_list}
	{help_text "Site node you would like to map hostname to"}
    }
    {submit:text(submit)
	{label "Add Pair"}
    }
} -validate {
    {host
	{![db_string check_host "select 1 from host_node_map where host = :host" -default 0]}
         "Host must be unique"
    }
} -on_submit {
    util_memoize_flush_regexp "rp_lookup_node_from_host"
    db_dml host_node_insert {}
} -after_submit {
    ad_returnredirect index
}
