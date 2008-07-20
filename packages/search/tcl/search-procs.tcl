ad_library {
    full-text search engine

    @author Neophytos Demetriou (k2pts@yahoo.com)
    @cvs-id $Id: search-procs.tcl,v 1.42.2.3 2008-03-19 18:59:43 emmar Exp $
}

namespace eval search {}

ad_proc -public search::queue {
    -object_id
    -event
} {
    Add an object to the search_observer_queue table with
    an event.

    You should excercise care that the entry is not being
    created from a trigger (although search is robust for multiple
    entries so it will not insert or update the same object
    more than once per sweep).

    @param object_id acs_objects object_id
    @param event INSERT or UPDATE or DELETE

    @author Jeff Davis (davis@xarg.net)
} {
    if {$object_id ne ""
        && $event ne ""} {
        package_exec_plsql \
            -var_list [list \
                           [list object_id $object_id] \
                           [list event $event] ] \
            search_observer enqueue
    } else {
        ns_log warning "search::queue: invalid: called with object_id=$object_id event=$event\n[ad_print_stack_trace]\n"
    }
}

ad_proc -public search::dequeue {
    -object_id
    -event_date
    -event
} {
    Remove an object from the search queue

    @param object_id acs_objects object_id
    @param event_date the event date as retrieved from the DB (and which should not be changed)
    @param event INSERT or UPDATE or DELETE

    @author Jeff Davis (davis@xarg.net)
} {
    if {$object_id ne ""
        && $event_date ne ""
        && $event ne ""} {
            package_exec_plsql \
                -var_list [list [list object_id $object_id] \
                               [list event_date $event_date] \
                               [list event $event] ] \
                search_observer dequeue
    } else {
        ns_log warning "search::dequeue: invalid: called with object_id=$object_id event_date=$event_date event=$event\n[ad_print_stack_trace]\n"
    }
}

ad_proc -public search::is_guest_p {
} {
    Checks whether the logged-in user is a guest
} {
    set user_id [ad_conn user_id]
#    return [db_string get_is_guest_p {select dotlrn_privacy.guest_p(:user_id) from dual}]
    return 0
}

ad_proc -public -callback search::action {
     -action
     -object_id
     -datasource
     -object_type
} {
     Do something with a search datasource Called by the indexer
     after having created the datasource.

     @param action UPDATE INSERT DELETE
     @param datasource name of the datasource array

     @return ignored

     @author Jeff Davis (davis@xarg.net)
} -


ad_proc -private search::indexer {} {
    Search indexer loops over the existing entries in the search_observer_queue 
    table and calls the appropriate driver functions to index, update, or 
    delete the entry.

    @author Neophytos Demetriou
    @author Jeff Davis (davis@xarg.net)
} {

    set driver [ad_parameter -package_id [apm_package_id_from_key search] FtsEngineDriver]

    if { $driver eq ""
         || (![callback::impl_exists -callback search::index -impl $driver] && ! [acs_sc_binding_exists_p FtsEngineDriver $driver])} {
        # Nothing to do if no driver
        ns_log Debug "search::indexer: driver=$driver binding exists? [acs_sc_binding_exists_p FtsEngineDriver $driver]"
        return
    }
    # JCD: pull out the rows all at once so we release the handle
    foreach row [db_list_of_lists search_observer_queue_entry {}] {

        # DRB: only do Oracle shit for oracle (doh)
        if { [ns_config "ns/db/drivers" oracle] ne "" } {
            nsv_incr search_static_variables item_counter
            if {[nsv_get search_static_variables item_counter] > 1000} {
                nsv_set search_static_variables item_counter 0
                db_exec_plsql optimize_intermedia_index {begin
                    ctx_ddl.sync_index ('swi_index');
                    end;
                }
            }
        }

        foreach {object_id event_date event} $row { break }
        array unset datasource
        switch -- $event {
            UPDATE -
            INSERT {
                # Don't bother reindexing if we've already inserted/updated this object in this run
                if {![info exists seen($object_id)]} {
                    set object_type [acs_object_type $object_id]
                    ns_log debug "\n-----DB-----\n SEARCH INDEX object type = '${object_type}' \n------------\n "
                    if {[callback::impl_exists -callback search::datasource -impl $object_type] \
                            || [acs_sc_binding_exists_p FtsContentProvider $object_type]} {
                        array set datasource {mime {} storage_type {} keywords {}}
                        if {[catch {
                            # check if a callback exists, if not fall
                            # back to service contract
                            if {[callback::impl_exists -callback search::datasource -impl $object_type]} {
                                #ns_log notice "\n-----DB-----\n SEARCH INDEX callback datasource exists for object_type '${object_type}'\n------------\n "
                                array set datasource [lindex [callback -impl $object_type search::datasource -object_id $object_id] 0]
                            } else {
                                array set datasource  [acs_sc_call FtsContentProvider datasource [list $object_id] $object_type]
                            }
                            search::content_get txt $datasource(content) $datasource(mime) $datasource(storage_type) $object_id

                            if {[callback::impl_exists -callback search::index -impl $driver]} {
                                if {![info exists datasource(package_id)]} {
                                    set datasource(package_id) ""
                                }
                                #				set datasource(community_id) [search::dotlrn::get_community_id -package_id $datasource(package_id)]
                                
                                if {![info exists datasource(relevant_date)]} {
                                    set datasource(relevant_date) ""
                                }
                                callback -impl $driver search::index -object_id $object_id -content $txt -title $datasource(title) -keywords $datasource(keywords) -package_id $datasource(package_id) -community_id $datasource(community_id) -relevant_date $datasource(relevant_date) -datasource datasource 
                            } else {
                                acs_sc_call FtsEngineDriver \
                                    [ad_decode $event UPDATE update_index index] \
                                    [list $datasource(object_id) $txt $datasource(title) $datasource(keywords)] $driver
                            }
                        } errMsg]} {
                            ns_log Error "search::indexer: error getting datasource for $object_id $object_type: $errMsg\n[ad_print_stack_trace]\n"
                        } else {
                            # call the action so other people who do indexey things have a hook
                            callback -catch search::action \
                                -action $event \
                                -object_id $object_id \
                                -datasource datasource \
                                -object_type $object_type

                            # Remember seeing this object so we can avoid reindexing it later
                            set seen($object_id) 1

                            search::dequeue -object_id $object_id -event_date $event_date -event $event
                        }
                    }
                }
            }
            DELETE {
                if {[catch {
                    acs_sc_call FtsEngineDriver unindex [list $object_id] $driver
                } errMsg]} {
                    ns_log Error "search::indexer: error unindexing $object_id $object_type: $errMsg\n[ad_print_stack_trace]\n"
                } else {
                    # call the search action callbacks.
                    callback -catch search::action \
                        -action $event \
                        -object_id $object_id \
                        -datasource NONE \
                        -object_type {}

                    search::dequeue -object_id $object_id -event_date $event_date -event $event

                }

                # unset seen since you could conceivably delete one but then subsequently
                # reinsert it (eg when rolling back/forward the live revision).
                if {[info exists seen($object_id)]} {
                    unset seen($object_id)
                }
            }
        }

        # Don't put that dequeue in a default block of the swith above
        # otherwise objects with insert/update and delete operations in the same
        # run would crash and never get dequeued

        search::dequeue -object_id $object_id -event_date $event_date -event $event
    }

}

ad_proc -private search::content_get {
    _txt
    content
    mime
    storage_type
    object_id
} {
    @author Neophytos Demetriou

    @param content

    holds the filename if storage_type=file
    holds the text data if storage_type=text
    holds the lob_id if storage_type=lob
} {
    upvar $_txt txt

    set txt ""

    # lob and file are not currently implemented
    switch $storage_type {
        text {
            set data $content
        }
        file {
            set data [cr_fs_path][db_string get_filename "select content from cr_revisions where revision_id=:object_id"]
        }
        lob {
            set data [db_blob_get get_lob_data {}]
        }
    }
    
    search::content_filter txt data $mime
}

ad_proc -private search::content_filter {
    _txt
    _data
    mime
} {
    @author Neophytos Demetriou
} {
    upvar $_txt txt
    upvar $_data data

    switch -glob -- $mime {
        {text/*} {
            set txt $data
        }
        default { 
	    set txt [search::convert::binary_to_text -filename $data -mime_type $mime]
        }
    }
}

ad_proc -callback search::datasource {
    -object_id:required
} {
    This callback is invoked by the search indexer when and object is
    indexed for search. The datasource implementation name should be
    the object_type for the object.
} -

# define for all objects, not just search?

ad_proc -callback search::search {
    -query:required
    -user_id
    {-offset 0}
    {-limit 10}
    {-df ""}
    {-dt ""}
    {-package_ids ""}
    {-object_type ""}
} {
    This callback is invoked when a search is to be performed. Query
    will be a list of lists. The first list is required and will be a
    list of search terms to send to the full text search
    engine. Additional optional lists will be a two element list. THe
    first element will be the name of an advanced search operator. The
    second element will be a list of data to restrict search results
    based on that operator.
} -

ad_proc -callback search::unindex {
    -object_id:required
} {
    This callback is invoked to remove and item from the search index.
} -

ad_proc -callback search::url {
    -object_id:required
} {
   This callback is invoked when a URL needs to be generated for an
   object. Usually this is called from /o.vuh which defers URL
   calculation until a link is actually clicked, so generating a list
   of URLs for various object types is quick.
} -

ad_proc -callback search::index {
    -object_id 
    -content
    -title
    -keywords
    -community_id
    -relevant_date
    {-description ""}
    {-datasource ""}
    {-package_id ""}    
} {
    This callback is invoked from the search::indexer scheduled procedure
    to add an item to the index
} -

ad_proc -callback search::update_index {    
    -object_id 
    -content
    -title
    -keywords
    -community_id
    -relevant_date
    {-description ""}
    {-datasource ""}
    {-package_id ""}    
} {
    This callback is invoked from the search::indexer scheduled procedure
    to update an item already in the index
} -

ad_proc -callback search::summary {
    -query
    -text
} {
    This callback is invoked to return an HTML fragment highlighting the terms in query
} - 

ad_proc -callback search::driver_info {
} {
    This callback returns information about the search engine implementation
} -

# dotlrn specific procs

namespace eval search::dotlrn {}

ad_proc -public search::dotlrn::get_community_id {
    -package_id
} {
    if dotlrn is installed find the package's community_id
    
    @param package_id Package to find community

    @return dotLRN community_id. empty string if package_id is not under a dotlrn package instance
} {
    if {[apm_package_installed_p dotlrn]} {
	set site_node [site_node::get_node_id_from_object_id -object_id $package_id]
	set dotlrn_package_id [site_node::closest_ancestor_package -node_id $site_node -package_key dotlrn -include_self]
	set community_id [db_string get_community_id {select community_id from dotlrn_communities_all where package_id=:dotlrn_package_id} -default [db_null]]
	return $community_id
    } 
    return ""
}
