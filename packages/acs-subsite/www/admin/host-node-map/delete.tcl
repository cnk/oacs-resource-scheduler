ad_page_contract {
    @author Mark Dettinger (mdettinger@arsdigita.com)
    @creation-date 2000-10-24
    @cvs-id $Id: delete.tcl,v 1.3 2003-05-17 10:00:22 jeffd Exp $
} {
    host
    node_id:integer
}

# Flush the cache
util_memoize_flush_regexp "rp_lookup_node_from_host"

db_dml host_node_delete {
    delete from host_node_map 
    where host = :host
    and node_id = :node_id
}

ad_returnredirect index
