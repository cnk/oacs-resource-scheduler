# /packages/ctrl-calendar/tcl/ctrl-cal-search-procs.tcl		-*- tab-width: 4 -*-
ad_library {
	
	Calendar Search Widget Procedures
	
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2007/08/08
	@cvs-id			$Id$
}

namespace eval ctrl::cal::search {}

ad_proc -public ctrl::cal::search::build_filter_sql {} {
	This procedure returns and events search query based on the parameters
	selected in the search widget.  The SQL should be used as a filter in
	another chunk of SQL, either in the FROM clause or the WHERE clause:
	<blockquote>
	<h5>... in the .XQL:</h5>
	<pre>
        ...
        &lt;fullquery name="my_events"&gt;
         &lt;querytext&gt;
            select  ...
              from  ctrl_events                             e,
                    ([ctrl::cal::search::build_filter_sql]) filter
             where  e.event_id = filter.event_id
                ...
         &lt;/querytext&gt;
        &lt;/fullquery&gt;
        ...
	</pre>

	<h5>... in the .ADP:</h5>
	<pre>
        ...
        &lt;include src="/packages/ctrl-calendar/www/events/search-box" /&gt;
        ...
        &lt;multiple name="my_events"&gt;
            ...
        &lt;/multiple&gt;
        ...
	</pre>
	</blockquote>
	You'll notice that we don't rely upon the calling page's contract to get our
	variables or validate them.  This approach makes using the search widget
	much simpler since the calling page just needs to <code>include</code> the
	widget (without any parameters) and use this proc to build its SQL.
	Similarly, the <code>include</code> takes care of its own variables so that
	the ADP is also greatly simplified.

	@return	An SQL sub-query which limits events to the constraints specified
			(presumably) in the search widget.

	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2007/08/08
} {
	set csw csw

	############################################################################
	# Bring in the variables from the HTTP request.  Also place them into the
	# parent stack frame.  We use shorter, more convenient names locally and
	# longer (less likely to collide) names in the parent frame & HTTP request.
	foreach	{external_varname	local_varname} {
			 csw_mm_yyyy		mm_yyyy
			 csw_calendar_ids	calendar_ids
			 csw_category_ids	category_ids
			 csw_title			title
	} {
		upvar $external_varname $local_varname
		if {[ns_queryexists $external_varname]} {
			set $local_varname [ns_queryget $external_varname]
		}
	}

	############################################################################
	# Based upon submitted values from the search widget (if any), build small
	# SQL fragments which will be combined later.  All of the validation that is
	# needed is done below.
	if {[exists_and_not_null mm_yyyy]} {
		regexp		{\s*(\D{1,2})?\s+(\D{1,4})?\s*} $mm_yyyy _ mm yyyy	;# extract sub-fields of date
		set mm		[format "%02s" [string trim [lindex $mm_yyyy 0]]]	;# pad month to 2 digits
		set yyyy	[format "%04s" [string trim [lindex $mm_yyyy 1]]]	;# pad year to 4 digits (silly, I know)

		if {[exists_and_not_null yyyy]} {
			upvar	csw_yyyy		csw_yyyy
			set		csw_yyyy		$yyyy
			lappend	event_matches_p	"to_char(evt_.end_date, 'yyyy') = :csw_yyyy"
		}

		if {[exists_and_not_null mm]} {
			upvar	csw_mm			csw_mm
			set		csw_mm			$mm
			lappend event_matches_p	"to_char(evt_.end_date, 'mm') = :csw_mm"
		}

		if {![exists_and_not_null event_matches_p]} {
			ad_return_error "Formatting Error" "
				There is a formatting error with the dates you selected. Please
				contact your system administrator at [ad_host_administrator] to
				resolve this problem. Thank you.
			"
			return
		}
	} else {
		lappend event_matches_p	"evt_.end_date >= sysdate"
	}

	if {[exists_and_not_null title]} {
		lappend event_matches_p	{lower(evt_.title) like '%'||:csw_title||'%'}
	}

	if {[exists_and_not_null category_ids]} {
		lappend event_matches_p	"cat_.category_id in ([join $category_ids ","])"
	}

	if {[exists_and_not_null calendar_ids]} {
		lappend event_matches_p	"cal_.cal_id in ([join $calendar_ids ","])"
	}

	if {[exists_and_not_null event_matches_p]} {
		set event_matches_p [join $event_matches_p "\n\t and "]
	} else {
		set event_matches_p "1=1"
	}

	############################################################################
	# Build the fragments into a larger subquery which can be used like a table
	# or in an SQL clause like: ... where X in (SUBQUERY) ....
	# We append '_' to prevent the any outer queries from inadvertently
	# interfering with the functioning of this query when used as a subquery in
	# the WHERE clause.
	set filter_sql "
		select	evt_.event_id
		  from	ctrl_calendars			cal_,
				ctrl_calendar_event_map	cem_,
				ctrl_event_categories	cat_,
				ctrl_events				evt_
		 where	cal_.cal_id(+)			= cem_.cal_id		-- <joins>
		   and	cem_.event_id	        = evt_.event_id		-- ...
		   and	evt_.event_id		    = cat_.event_id(+)	-- </joins>
		   and	evt_.repeat_template_p	= 'f'		        -- standard constraints
		   and	cal_.owner_id			is null
		   and	$event_matches_p		                    -- dynamic constraints

	"

	return $filter_sql
}
