ad_library {

    Set up a scheduled process to send out email messages.

    @cvs-id $Id: acs-messaging-init.tcl,v 1.2 2002-09-10 22:22:10 jeffd Exp $
    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-10-28

}

# Schedule every 15 minutes.  Its own thread. since ns_sendmail does
# network activity.
ad_schedule_proc -thread t 900 acs_messaging_process_queue

