# /packages/ctrl-procs/tcl/utilities-procs.tcl
ad_library {

    Utility Procs for CTRL

    @creation-date 1/22/2004
    @cvs-id $Id: utilities-procs.tcl,v 1.1 2005/08/09 03:26:49 avni Exp $
}

namespace eval ctrl_procs::util {}

ad_proc -public ctrl_procs::util::pagination {
    {-total_items:required}
    {-current_page:required}
    {-row_num:required}
    {-path:required}
} {
    
    IMPORTANT:  In order for pagination to work you must have 2 page variables: row_num and current_page.  Row_num is the default number of items per pages.  Usually set to 10.  current_page is the default page to start on when viewing the list. This is usually 0 - the first page.
 
   <pre>
    Return a 3 element list of the following items : 
    (1) The numerical value of the first item to be display
    (2) the numerical value of the last number to be displayed
    (3) links for pagination that can simply be display on the .adp page
    </pre>



    <pre>
    Example:
    
    
    the .tcl file
    
    two variables in the page contract:
    <code>
    {current_page:naturalnum 0}
    {row_num:naturalnum 10}
    </code>

    code to call proc: 
    <code>
    db_1row num_divisions {}


    set page_list [patient_notes::pagination \
	    -total_items $num_divisions \
	    -current_page $current_page \
	    -row_num $row_num \
	    -path "division-list?[export_url_vars status department_id]" ]
    
    set first_number [lindex $page_list 0]
    set last_number  [lindex $page_list 1]
    set nav_bar      [lindex $page_list 2]

    db_multirow get_divisions get_divisions {} {
    }

    
    </code>

    the .xql file contains two queries.

    select count(*) as num_divisions
    from pn_divisions

    select division_name, division_id
    from (select division_name, division_id, rownum as num_count from pn_divisions order by division_name)
    where num_count >= :first_number and num_count <= :last_number
    
    the .adp will display everything in a multiple.
    
    


    @param total_items The Actual number of items that we are trying to paginate
    @param current_page What page we are trying to view
    @param row_num The number of items viewable on each page
    @param path The path of the list file with regard to the root of your package. Also make sure to pass in any extra variables that you need to pass to the page.

    @author Jeff Wang
    @creation-date 1/22/2004

} {
    
    # Pagination Step 1: Create bounds for page select
    set first_number [expr $current_page*$row_num+1]
    if {$total_items < $first_number} {
	set current_page 0
    }
    set last_number [expr $first_number+$row_num-1]
    
    # Pagination Step 2: Build the navigation bar
    set row_count $total_items
    set pages [expr $row_count/$row_num]
    set remainder [expr $row_count%$row_num]
    
    if {$remainder > 0} {
	incr pages 1
    }
        
    set index 0
    set start 1
    set passed_page_start $current_page
    set navigation_bar [list]
    if {$passed_page_start > 0} {
    set current_page [expr $passed_page_start-1]
	set original_page_start $current_page
    }

    set max_link 20
    set link_count 1
    set more_pages 0
    set index [expr $passed_page_start/$max_link]
    set index [expr $index*$max_link]
    set started_index $index
    
    
    while {$index < $pages} {
	set start [expr $index*$row_num+1]
	set end [expr ($index+1)*$row_num]
	
	if {$passed_page_start == $index} {
	    lappend navigation_bar "[expr $index+1]"
	} else {
	    set current_page $index
	    
	    #append to the path
	    if [regexp {.*[?].*} $path] {
		set new_path  "$path&current_page=$current_page&row_num=$row_num"
	    } else {
		set new_path  "$path?current_page=$current_page&row_num=$row_num"
	    }

	    lappend navigation_bar "<a href=\"$new_path\">[expr $index+1]</a>"
	    
	}
	
	incr index 1
	incr link_count
	if {$link_count > $max_link} {
	    set more_pages 1
	    break
	}
    }
    
    if {$passed_page_start > 0} {
	set current_page $original_page_start
	if {$started_index == 0} {

	    if [regexp {.*[?].*} $path] {
		set new_path  "$path&current_page=$current_page&row_num=$row_num"
	    } else {
		set new_path  "$path?current_page=$current_page&row_num=$row_num"
	    }

	    set navigation_bar [linsert $navigation_bar 0 "<a href='$new_path'>&lt;&lt;&lt;</a>"]
	} else {
	    
	    if [regexp {.*[?].*} $path] {
		set new_path  "$path&current_page=$current_page&row_num=$row_num"
	    } else {
		set new_path  "$path?current_page=$current_page&row_num=$row_num"
	    }

	    set navigation_bar [linsert $navigation_bar 0 "<a href='$new_path'>&lt;&lt;&lt;</a>..."]
	}
    }
    
    if {[expr $passed_page_start+1] < $pages} {
	set current_page [expr $passed_page_start+1]
	if {$more_pages == 1} {

	    if [regexp {.*[?].*} $path] {
		set new_path  "$path&current_page=$current_page&row_num=$row_num"
	    } else {
		set new_path  "$path?current_page=$current_page&row_num=$row_num"
	    }

	    lappend navigation_bar "...<a href='$new_path'>&gt;&gt;&gt;</a>"
	} else {

	    if [regexp {.*[?].*} $path] {
		set new_path  "$path&current_page=$current_page&row_num=$row_num"
	    } else {
		set new_path  "$path?current_page=$current_page&row_num=$row_num"
	    }
	    
	    lappend navigation_bar "<a href='$new_path'>&gt;&gt;&gt;</a>"
	}
    }
    
    set navigation_display "Pages: "
    
    foreach item $navigation_bar {
	append navigation_display "$item "
    }
    
    return [list $first_number $last_number $navigation_display]
}

ad_proc ctrl_procs::util::get_ip {hostname port} {
    Returns the IP of given hostname and port
} {
    if { [ catch {
	set sid [ socket $hostname $port]
	set ip  [ lindex [ fconfigure $sid -peername ] 0 ]
	::close $sid
    } err ] } {
	catch { ::close $sid }
	puts stderr "myIP error: '$err' on port 22 (sshd). using 127.0.0.1"
    }
    return $ip
}

ad_proc -public ctrl_procs::util::write_binary_file {
    {-from_abs_path:required}
    {-to_abs_path:required}
} {
    Write binary data (ie: .jpg, .gif files) from one file to another file. Will create a file
    if it doesn't exists or overwrite existing files. This proc may work on text files, although
    not thoroughly tested.  Try template::util::write for text files.
    
    @param from_abs_path the absolute path to read a binary file from
    @param to_abs_path the absolute path (and file name) of the new file
} {
    #open a channel to read binary data
    set img_channel [open $from_abs_path]
    #configure the channel to specify binary data
    fconfigure $img_channel -translation binary -encoding binary

    #open a channel to write to
    set write_channel [open $to_abs_path "w+"]
    #configure the write channel
    fconfigure $write_channel -translation binary -encoding binary
    
    #read from the img_channel
    set data [read $img_channel]
    #write the data to the write_channel
    puts $write_channel $data
    
    #close both channels
    close $img_channel
    close $write_channel
}

ad_proc -public ctrl_procs::util::encode {
    password
} {
	Base64 enode a password or any other string.

    @param password the password, or string to encrypt
    @return the encrypted value
} {
    set encoded_string [exec echo $password | openssl enc -base64]
    return $encoded_string
}


ad_proc -public ctrl_procs::util::decode {
    password
} {
    Decode the base64 value to the original value.

    @param The encoded value
    @return the password
} {
    set password [exec echo $password | openssl enc -base64 -d]
    return $password
}



ad_proc ctrl_procs::util::verify_password {password} {
    Verify the password is at least 6 characters and contains at least one special character (numeral, @, -, $ etc).
} {
    set err_msg ""

    if {[string length $password] < 6} {
	append err_msg "Your password must contain at least 6 character."
    }
    
    if {[string is alpha $password] || [string is integer $password]} {
	append err_msg "The password must contain consist of alpha-numeric (letters/numbers). Special characters like $ or - may also be used."
    }
    
    if {![empty_string_p $err_msg]} {
	ad_return_complaint 1 $err_msg
	ad_script_abort
    } else {
	return 1
    }
}

ad_proc ctrl_procs::util::demoronise {
	ms_text
} {

	Removes offending characters from textare
} {
	#   Eliminate idiot MS-DOS carriage returns from line terminator,
    #   map strategically incompatible non-ISO characters in the
    #   range 0x82 -- 0x9F into plausible substitutes where
    #   possible. 
    # Thanks Michael Cleverly for the string map optimization
    return [string map [list \r\n \n \x82 ,        \x83 f        \x84 ,,       \x85 ...      \x88 ^        \x89 " */**"  \x8B <        \x8C Oe       \x91 `        \x92 '        \x93 \"       \x94 \"       \x95 *        \x96 -        \x97 --       \x98 ~        \x99 (tm)     \x9B >        \x96 oe] $ms_text]
}
