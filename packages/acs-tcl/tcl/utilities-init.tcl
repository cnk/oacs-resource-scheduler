ad_library {

    Initializes datastructures for utility procs.

    @creation-date 02 October 2000
    @author Bryan Quinn
    @cvs-id $Id: utilities-init.tcl,v 1.7 2005-04-26 14:36:32 jader Exp $
}

# initialize the random number generator
randomInit [ns_time]

# Create mutex for util_background_exec
nsv_set util_background_exec_mutex . [ns_mutex create]

# if maxbackup in config is missing or zero, don't run auto-logrolling
set maxbackup [ns_config -int "ns/parameters" maxbackup 0]

if { $maxbackup } {
    ad_schedule_proc -all_servers t -schedule_proc ns_schedule_daily \
	[list 00 00] util::roll_server_log
}
