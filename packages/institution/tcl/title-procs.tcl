# -*- tab-width: 4 -*-
# /packages/institution/tcl/title-procs.tcl
ad_library {
    Procs for building SQL to extract personnel-titles for display on subsites.

    @author			helsleya@cs.ucr.edu
    @creation-date	2005-02-16
    @cvs-id			$Id: title-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

    @title::vw_title_sql
}

namespace eval title {}

ad_proc -public title::vw_titles_sql {
	{-subsite_id	{:subsite_id}}
	{-personnel_id}
} {
	<p>Produce a chunk of SQL for extracting a person's titles as they should be
	displayed on a given subsite.  The parameters passed into this proc are very
	flexible.  Typically they are the names of bind variables or qualified
	column references from the enclosing SQL.  Avoid passing dereferenced TCL
	variables as this may open security holes and prevent the database server
	from utilizing cached queries.</p>

	<p><h3>Example:</h3>
	<pre><code>
    # Get a bunch of personnel titles for a single subsite which will be passed
    # as a bind-variable.
    db_multirow all_personnel_titles personnel_titles_sql "
        select  psnl.employee_number,
                nvl(ttls.title, cttl.name)  as title,
                grps.group_name             as group,
                csts.name                   as status,
                ttls.start_date,
                ttls.end_date
          from  inst_personnel                          psnl,
                categories                              cttl,
                inst_groups                             grps,
                categories                              csts,
                <b style='color: red'>[title::vw_title_sql                    &#92;
                    -personnel_id   {psnl.personnel_id} &#92;
                    -subsite_id     {:subsite_id}]      ttls</b>
         order  by  psnl.employee_number,
                    ttls.priority,
                    grps.group_name,
                    cttl.name,
                    ttls.start_date
    " {
    }
	</code></pre></p>

	@param	subsite_id		The piece of SQL that should be placed into the
							subquery to denote the desired subsite.
	@param	personnel_id	The piece of SQL that should be placed into the
							subquery to denote the desired person.
	@return					An SQL subquery that produces a table of 0 or more
							titles for 0 or more people.  The schema for the
							'table' is:
							<blockquote>
								title_id<br>
								title (this is not-NULL iff the text of the title is in the main table and thus should not be taken from categories)<br>
								group_id<br>
								status_id<br>
								start_date<br>
								end_date<br>
								priority (lower numbers indicate titles that
										  should be shown earlier)
							</blockquote>

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-02-16 19:09 PST
} {
	set x 1
	return "select 1 as x from dual"
}
