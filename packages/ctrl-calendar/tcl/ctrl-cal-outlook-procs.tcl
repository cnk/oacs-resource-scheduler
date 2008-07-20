# /packages/ctrl-calendar/tcl/ctrl-cal-outlook-procs.tcl

ad_library {
    Utility functions for syncing Calendar with Outlook

    taken from SloanSpace v1, hacked for OpenACS by Ben.

    @author wtem@olywa.net
    @author ben@openforce.biz
    @author avni@ctrl.ucla.edu (AK) - modifications for ctrl

    @creation-date ?
    @cvs-id $Id$
    
}

namespace eval ctrl_calendar::outlook {

    ad_proc ics_timestamp_format {
        {-timestamp:required}
    } {
        the timestamp must be in the format YYYY-MM-DD HH24:MI:SS
    } {
        regsub { } $timestamp {T} timestamp
        regsub -all -- {-} $timestamp {} timestamp
        regsub -all {:} $timestamp {} timestamp
        
        append timestamp ""
        return $timestamp
    }

    ad_proc cal_outlook_gmt_sql {{hours 0} {dash ""}} {formats the hours to substract or add to make the date_time be in gmt} {
        # east of gmt is notated as "-",
        # in order to get gmt (to store the date_time for outlook)
        # we need to have the hour equal gmt at the same time as the client
        # i.e. if its noon gmt, then its 4am in pst
        # 
        if ![empty_string_p $dash] {
            set date_time_math "- $hours/24"
        } else {
            set date_time_math "+ $hours/24"
        }

        return $date_time_math
    }

    ad_proc -public format_item {
	{-cal_event_id:required}
        {-all_occurences_p 0}
        {-client_timezone 0}
    } {
        the cal_item_id is obvious.
        If we want all occurrences, we set all_occurences_p to true.

        The client timezone helps to make things right. 
        It is the number offset from GMT.
    } {
	### Get start and end time in ansi format
	ctrl_event::get -event_id $cal_event_id -array "cal_item" -date_format "'YYYY-MM-DD HH24:MI:SS'"
	set cal_item(start_date) [lc_time_local_to_utc $cal_item(start_date)]
	set cal_item(end_date) [lc_time_local_to_utc $cal_item(end_date)]

	# Start_time End_time Title Description Location Speaker
        set DTSTART [ics_timestamp_format -timestamp $cal_item(start_date)]
        set DTEND [ics_timestamp_format -timestamp $cal_item(end_date)]

        # Put it together
        set vcs_event "BEGIN:VCALENDAR\r\nPRODID:-//OpenACS//OpenACS 5.0 MIMEDIR//EN\r\nVERSION:2.0\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nDTSTART:$DTSTART\r\nDTEND:$DTEND\r\n"
	
        regexp {^([0-9]*)T} $DTSTART all CREATION_DATE
	
	set SPEAKER [ad_html_to_text [string trim $cal_item(speakers)]]
	if {![empty_string_p $SPEAKER]} {
	    set TITLE $SPEAKER
	} else {
	    set TITLE [ad_html_to_text $cal_item(title)]
	}

	regsub -all {\r\n} $TITLE "=0D=0A" TITLE
	regsub -all {\n\n} $TITLE "=0D=0A=0D=0A" TITLE
	regsub -all {\n} $TITLE "=0D=0A" TITLE


	set DESCRIPTION "$cal_item(title)<br><br>"
	if {![empty_string_p $SPEAKER]} {
	    append DESCRIPTION "Speaker(s): $SPEAKER<br><br>"
	}
	
	append DESCRIPTION "$cal_item(notes)"
        set DESCRIPTION [ad_html_to_text $DESCRIPTION]
	regsub -all {\r\n} $DESCRIPTION "=0D=0A" DESCRIPTION
	regsub -all {\n\n} $DESCRIPTION "=0D=0A=0D=0A" DESCRIPTION
	regsub -all {\n} $DESCRIPTION "=0D=0A" DESCRIPTION


	set LOCATION [ad_html_to_text $cal_item(location)]

	regsub -all {\r\n} $LOCATION "=0D=0A" LOCATION
	regsub -all {\n\n} $LOCATION "=0D=0A=0D=0A" LOCATION
	regsub -all {\n} $LOCATION "=0D=0A" LOCATION
       
        append vcs_event "LOCATION;ENCODING=QUOTED-PRINTABLE:$LOCATION\r\nTRANSP:OPAQUE\r\nSEQUENCE:0\r\nUID:$cal_event_id\r\nDTSTAMP:$CREATION_DATE\r\nDESCRIPTION;ENCODING=QUOTED-PRINTABLE:$DESCRIPTION\r\nSUMMARY;ENCODING=QUOTED-PRINTABLE:$TITLE\r\nPRIORITY:5\r\nCLASS:PUBLIC\r\n"

        append vcs_event "END:VEVENT\r\nEND:VCALENDAR\r\n"

        return $vcs_event
    }

}
