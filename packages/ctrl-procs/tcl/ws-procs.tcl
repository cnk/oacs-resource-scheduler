ad_library {

    Procedures to handle the webservice calls

    @author KH
    @cvs-id $Id: ws-procs.tcl,v 1.7 2005/11/20 08:37:48 nsadmin Exp $
    @creation-date 2005-09-07
}

namespace eval ctrl::ws::soap {

    ad_proc -private create_message {
	{-header ""}
	-body 
    } {
	Encloses the head and body in an soap envelope

	@param header header
	@param body the body
	@return returns the soap message
    } {
	if ![empty_string_p $header] {
	    set header_msg "<soap:Header>$header</soap:Header>"
	} else {
	    set header_msg ""
	}
	if ![empty_string_p $body] {
	    set body_msg "<soap:Body>$body</soap:Body>"
	}

	set soap_message "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">
	${header_msg}
	${body_msg}
	</soap:Envelope>"
	return $soap_message
    }

    ad_proc -public rpc_call_and_response {
	-endpoint 
	-soap_action 
	-soap_message 
	{-timeout 30}
	{-referer ""}
    } {
	calls the remote procedure call and returns the result
	
	@param end_point the location to post the soap_message
	@param action the action at the end point
	@param soap_message the actual soap message
	@param timeout 
	@param referrer
	
	@return a list of the soap header and footer 
	@exception throws an error when soap fault occurrs - the return format is a triple
                   the first element is either: soap_fault or internal_failure
	           the second selement is soap error code or internal error code
	           the third element is soap error message or internal error message
	           the fourth element is soap detail or other 
    } {
	#ns_returnnotice 200 $soap_message
	#return

	
	set response_list [send_request -endpoint $endpoint \
		-soap_action $soap_action -soap_message $soap_message \
		-timeout $timeout -referer $referer]
	
	set headers [lindex $response_list 0]
	set soap_message [lindex $response_list 1]
	set response [ns_set name $headers]
	set status [lindex $response 1]

	set first_index [string first "<\?xml" $soap_message]
	set last_index [string first "?>" $soap_message]

	if {$first_index > -1} {
	    set soap_message [string range $soap_message [expr $last_index+2] end]
	} else {
	    error [list internal_failure invalid_response "HTML status -> $status"]
	}
	set soap_header_body [get_elements -soap_message $soap_message]
	set header [lindex $soap_header_body 0]
	set body [lindex $soap_header_body 1]
	# check for soap fault
	set body [string trim $body]
	set fault_exist_loc [string first "<soap:Fault" $body]

	if {$fault_exist_loc == 0} {
	    set fault_elements [get_fault_elements -soap_fault_xml $body]
#	    set fault_elements [lindex $fault_elements 0 soap_fault]
	    return $fault_elements
	}
	return $soap_header_body
    }
    
    ad_proc -private send_request {
	-endpoint 
	-soap_action 
	-soap_message 
	{-timeout 30}
	{-referer ""}
    } {
	Uses http as the transport protocl for sending soap messages

	@param end_point the location to post the soap_message
	@param action the action at the end point
	@param soap_message the actual soap message
    } {
	set is_http [string match http://* $endpoint]
	set is_https [string match https://* $endpoint]
#	doc_return 200 text/html "is_http -> $is_http $endpoint"
	if {!$is_http && !$is_https} {
	    return -code error "Invalid url \"$endpoint\":  http open only supports HTTP or HTTPS"
	} 

	if $is_http {
	    return [send_request_http -endpoint $endpoint -soap_action $soap_action -soap_message $soap_message -timeout $timeout -referer $referer]
	} else {
	    return [send_request_https -endpoint $endpoint -soap_action $soap_action -soap_message $soap_message -timeout $timeout -referer $referer]
	}
    }


    ad_proc -private send_request_http {
	-endpoint 
	-soap_action 
	-soap_message 
	{-timeout 30}
	{-referer ""}
	{-server_host ""}
    } {
	Uses http as the transport protocl for sending soap messages

	@param endpoint the location to post the soap_message
	@param action the action at the end point
	@param soap_message the actual soap message
    } {
	if [empty_string_p $server_host] {
	    set server_loc [ns_conn location]
	    set server_url [split $server_loc /]
	    set server_hp [split [lindex $server_url 2] :]
	    set server_host [lindex $server_hp 0]
	}

	set url [split $endpoint /]
	set hp [split [lindex $url 2] :]
	set host [lindex $hp 0]
	set port [lindex $hp 1]
	if [string match $port ""] {
	    set port 80
	}

	set content_length [string length $soap_message]
	set uri /[join [lrange $url 3 end] /]

#	ns_log notice "Sending message WS Call"
#	ns_log notice "---------------------------------------"
#	ns_log notice $soap_message"
#	ns_log notice "---------------------------------------"
	set fds [ns_sockopen -nonblock $host $port]
	set rfd [lindex $fds 0]
	set wfd [lindex $fds 1]

#	doc_return 200 text/html "uri => $uri, host => $host, server_Host => $server_host, $content_length"
	if [catch {
	    _ns_http_puts $timeout $wfd "POST $uri HTTP/1.1\r"
	    _ns_http_puts $timeout $wfd "Host: $host\r"
#	    _ns_http_puts $timeout $wfd "Accept:*/*\r"
	    _ns_http_puts $timeout $wfd "Content-Type: text/xml\r"
	    _ns_http_puts $timeout $wfd "Content-length: ${content_length}\r"
	    _ns_http_puts $timeout $wfd "SOAPAction: \"$soap_action\"\r"
	    _ns_http_puts $timeout $wfd "\r"
	    _ns_http_puts $timeout $wfd "$soap_message\r"
	    flush $wfd
	    close $wfd
	    set wfd ""

	    set rpset [ns_set new [_ns_http_gets $timeout $rfd]]
	    while 1 {
		set line [_ns_http_gets $timeout $rfd]
		if ![string length $line] break
		ns_parseheader $rpset $line
	    }
	    set headers $rpset
	    set response [ns_set name $headers]
	    set status [lindex $response 1]
	    set page ""
	    set length [ns_set iget $headers content-length]
	    doc_return 200 text/html "Length is => $length"
	    ad_script_abort 

	    while {1} {
		set buf [_ns_http_read $timeout $rfd $length]
		append page $buf
		break
		#if [string match "" $buf] break
		#
		#if {$length > 0} {
		#    incr length -[string length $buf]
		#    if {$length <= 0} break
		#}
	    }
	    close $rfd
	    set rfd ""
	} errmsg] {
	    if {![empty_string_p  $rfd]} {
		close $rfd
	    }
	    if {![empty_string_p  $wfd]} {
		close $wfd
	    }
	    error "An error ocurred while trying to post \"$errmsg\""
	}
	return [list $headers $page]
    }

    ad_proc -private send_request_https {
	-endpoint 
	-soap_action 
	-soap_message 
	{-timeout 60}
	{-referer ""}
	{-server_host ""}
    } {
	Uses http as the transport protocl for sending soap messages

	@param endpoint the location to post the soap_message
	@param action the action at the end point
	@param soap_message the actual soap message
    } {
	if [empty_string_p $server_host] {
	    set server_loc [ns_conn location]
	    set server_url [split $server_loc /]
	    set server_hp [split [lindex $server_url 2] :]
	    set server_host [lindex $server_hp 0]
	}

	set url [split $endpoint /]
	set hp [split [lindex $url 2] :]
	set host [lindex $hp 0]
	set port [lindex $hp 1]
	if [string match $port ""] {
	    set port 443
	}
	set content_length [string length $soap_message]
	set uri /[join [lrange $url 3 end] /]

	#ns_returnnotice 200 $uri
	#return


	
#	ns_log notice "Sending message WS Call"
#	ns_log notice "---------------------------------------"
#	ns_log notice $soap_message"
#	ns_log notice "---------------------------------------"
	#set fds [ns_openssl_sockopen -nonblock $host $port]
	set fds [ns_sockopen -nonblock $host $port]
	set rfd [lindex $fds 0]
	set wfd [lindex $fds 1]

	#ns_returnnotice 200 $fds
#return

	if [catch {
	    _ns_https_puts $timeout $wfd "POST $uri HTTP/1.0\r"
	    _ns_https_puts $timeout $wfd "Host: $host\r"
	    _ns_https_puts $timeout $wfd "Accept:*/*\r"
	    _ns_https_puts $timeout $wfd "Content-Type: text/xml\r"
	    _ns_https_puts $timeout $wfd "Content-length: ${content_length}\r"
	    _ns_https_puts $timeout $wfd "SOAPAction: \"$soap_action\"\r"
	    _ns_https_puts $timeout $wfd "\r"
	    _ns_https_puts $timeout $wfd "$soap_message\r"
	    flush $wfd
	    close $wfd
	    set wfd ""

	    set rpset [ns_set new [_ns_https_gets $timeout $rfd]]
	    while 1 {
		set line [_ns_https_gets $timeout $rfd]
		if ![string length $line] break
		ns_parseheader $rpset $line
	    }
	    
	    set headers $rpset
	    set response [ns_set name $headers]
	    set status [lindex $response 1]
	    set page ""
	    set length [ns_set iget $headers content-length]
set length ""  
#	    set header_size [ns_set size $headers]
#	    set header_content ""
#	    for {set i 0} {$i < $header_size} {incr i} {
#		append header_content "[ns_set key $headers $i] --> [ns_set value $headers $i] <br>" 
#	    }

#	    doc_return  200 text/html "[ns_set size $headers] ($length) $header_content "
#	    ad_script_abort

#	    if {[empty_string_p $length]} {
#		set length 5000
#	    }

	    while {1} {
#		set buf [_ns_https_read $timeout $rfd $length]
#		doc_return 200  text/html $buf
#	return
		set buf [_ns_http_read $timeout $rfd $length]
		append page $buf
		if [string match "" $buf] break
		if {$length > 0} {
		    incr length -[string length $buf]
		    if {$length <= 0} break
		}
	    }
	    close $rfd
	    set rfd ""
	} errmsg] {
	    if {![empty_string_p  $rfd]} {
		close $rfd
	    }
	    if {![empty_string_p  $wfd]} {
		close $wfd
	    }
	    error "An error ocurred while trying to post \"$errmsg\""
	}
	ns_log notice "*** Testing https is working ***"
	ns_log notice "$page"
	ns_log notice "*** END Testing https is working ***"
#	doc_return 200  text/html $page
#	ad_script_abort
	return [list $headers $page]
    }


    ad_proc -public get_elements {
	-soap_message
	{-soap_prefix  soap}
    } {

	Returns the elements of the soap request - return code, header, footer
	@param soap_message
	@param soap_prefix the soap prefix
	@param indent indentation, the default is 5

	@returns the a two element list - html status code, header (if any), body
    } {
	set first_index [string first "<\?xml" $soap_message]
	set last_index [string first "?>" $soap_message]

	if {$first_index > -1} {
	    set soap_message [string range $soap_message [expr $last_index+2] end]
	}
	set doc ""
	set body_xml ""
	set result [catch {
	    dom parse $soap_message doc
	    set soap_envelope [$doc getElementsByTagName $soap_prefix:Envelope]

	    # Retrieve the headers of the soap message
	    set soap_header_text ""
	    set soap_header [$soap_envelope getElementsByTagName $soap_prefix:Header]
	    if ![empty_string_p $soap_header] {
		set header_child_node_list [$soap_header childNodes]		
		foreach child_node $header_child_node_list {
		    append soap_header_text [$child_node asXML ]
		}
	    }

	    # Retrieve the body of the soap message
	    set soap_body [$soap_envelope getElementsByTagName $soap_prefix:Body]
	    set body_child_node_list [$soap_body childNodes]
	    set soap_body_text ""
	    foreach child_node $body_child_node_list {
		append soap_body_text [$child_node asXML ]
	    }

	    set return_msg [list $soap_header_text $soap_body_text]
	} errmsg]

	if ![empty_string_p $doc] {
	    $doc delete 
	}

	if {$result != 0} {
	    error "Invalid soap message - $errmsg"
	}
	return $return_msg
    }
    
    ad_proc -private get_fault_elements {
	-soap_fault_xml
	{-prefix soap}
    } {
	@param soap_fault_xml
	@parma prefix the prefix for soap
	@return the elements of soap fault
    } {
	set doc ""
	set return_list [list]
	set result [catch {
	    dom parse $soap_fault_xml doc
	    set fault_msg [$doc getElementsByTagName $prefix:Fault]
	    set fault_code [$fault_msg getElementsByTagName faultcode]
	    if {![empty_string_p $fault_code] && ![empty_string_p [$fault_code firstChild]]} {
		lappend return_list [[$fault_code firstChild] nodeValue]
	    } else {
		lappend return_list ""
	    }

	    set fault_string [$fault_msg getElementsByTagName faultstring]
	    if {![empty_string_p $fault_string] && ![empty_string_p [$fault_string firstChild]]} {
		lappend return_list [[$fault_string firstChild] nodeValue]
	    } else {
		lappend return_list ""
	    }
	    set fault_detail [$fault_msg getElementsByTagName detail]
	    if {![empty_string_p $fault_detail] && ![empty_string_p [$fault_detail firstChild]]} {
		lappend return_list [[$fault_detail firstChild] nodeValue]
	    } else {
		lappend return_list ""
	    }
	} errmsg]

	if ![empty_string_p $doc] {
	    $doc delete 
	}

	if {$result != 0} {
	    error "Invalid format - $errmsg"
	}
	return $return_list
    }

} 
