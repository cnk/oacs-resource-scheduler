# /packages/ctrl-procs/tcl/tdom-parse-procs.tcl

ad_library {
    
    Procedures to make parsing XML using 
    TDOM a little easier

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/10/19
    @cvs-id $Id: tdom-parse-procs.tcl,v 1.2 2005/01/20 00:39:17 avni Exp $
}

namespace eval ctrl_procs {}
namespace eval ctrl_procs::tdom {}

ad_proc -public ctrl_procs::tdom_get_node_pointer {
    parent_node_pointer
    args
} {
    Returns a pointer to the args given
    If the pointer doesn't exist or the value is null, return null

    <pre>
    Example -----------------------------------------------------
    XML:     &lt;experiment&gt;
                 &lt;experimenter&gt;
                     &lt;first-name&gt;Annabelle Lee&lt;/first-name&gt;
                     &lt;last-name&gt;Poe&lt;/last-name&gt;
                 &lt;/experimenter&gt;
             &lt;/experiment&gt;
    Params:  parent_node_pointer=$pointer_to_experiment
             args=experimenter experimenter_two
    Returns: Pointer to experimenter node
    End Example -------------------------------------------------
    </pre>
} {
    # Do a loop for the args. The first non null result is returned
    set node_pointer ""
    foreach node_name $args {
	catch {set node_pointer [$parent_node_pointer getElementsByTagName "$node_name"]}
	if {![empty_string_p [string trim $node_pointer]]} {
	    return $node_pointer
	}
    }

    return $node_pointer
}

ad_proc -public ctrl_procs::tdom_get_tag_value {
    node_pointer
    args
} {
    Returns the tag value of the tag_name passed in
    If tag doesn't exist or the value is null, returns null

    <pre>
    Example -----------------------------------------------------
    XML:     &lt;experiment-id&gt;1222&lt;/experiment-id&gt;
    Params:  node_pointer=$document 
             args=experiment-id EXPERIMENT-ID
    Returns: 1222
    End Example -------------------------------------------------
    </pre>
} {
    # Do a loop for the args. The first non null result is returned
    set tag_value ""
    foreach tag_name $args {
	catch {set tag_value [[$node_pointer getElementsByTagName "$tag_name"] text]}
	if {![empty_string_p [string trim $tag_value]]} {
	    return $tag_value
	}
    } 
    
    return $tag_value
}

ad_proc ctrl_procs::tdom::get_children_nodes_text_value {
    -node:required
    {-children_name_list ""}
} {
    Returns node's children nodes that have a single text value and its attributes
    For example:
       &nbsp;ford_automobile_list&lt;
           &nbsp;automobile id="1" type="compact"&lt;Focus&nbsp;/automobile&lt;
           &nbsp;automobile id="2" type="truck"&lt;Ranger&nbsp;/automobile&lt;
           &nbsp;automobile id="3" type="sedan"&lt;Fusion&nbsp;/automobile&lt;
       &nbsp;/car_list&lt;  
    
    Each node is an element in the return list represented a triple:
    <ul>
        <li>node name</li>
        <li>node's child text node value</li>
        <li>a list of property name and value alternating between odd and even positions </li>
    </ul>

    In the example above the return list is 3 element list:
    {automobile Focus {id 1 type compact}} {automobile Ranger {id 2 type truck}} 
    {automobile Fusion {id 3 type sedan}} 
         
    @param node the node with the children nodes with a single text node 
    @param children_name_list returns only the child nodes that has 
           a name in this list, If empty then return a list for each child node
    @return a list containing an element for each child node
} {
    if ![$node hasChildNodes] {
        return ""
    }
    set child_node_list [$node childNodes]
    set return_list [list]
    foreach child_node $child_node_list {
        set name [$child_node nodeName]
        if ![empty_string_p $children_name_list] {
            if {[lsearch -exact $children_name_list $name] < 0} {
                continue
            }
        }
        set text_node_value [ctrl_procs::tdom::get_node_text_value $child_node]
	set attribute_list [$child_node attributes]
	set attribute_pair_list [list]
	foreach attribute $attribute_list {
	    lappend attribute_pair_list $attribute [$child_node getAttribute $attribute]
	}
        lappend return_list [list $name $text_node_value $attribute_pair_list]
    }
    return $return_list
}

ad_proc ctrl_procs::tdom::get_node_text_value {
    node_with_text_node
} {
    Returns the value of the single text node under the passed in node
    @param node_with_text_node tdom node with a single child text node
    @return the value of the text node
} {
    if ![$node_with_text_node hasChildNodes]  {
        error "Invalid node"
    }
    return [[$node_with_text_node firstChild] nodeValue]
}
