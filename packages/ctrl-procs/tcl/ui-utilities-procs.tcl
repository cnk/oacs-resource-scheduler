# -*- tab-width: 4 -*-
ad_library {

    Utility Procs for CTRL

    @author Jeff Wang
    @creation-date 1/22/2004
    @cvs-id $Id: ui-utilities-procs.tcl,v 1.3 2005/08/09 03:26:17 avni Exp $
}

namespace eval ctrl {}

ad_proc -public ctrl::modified_column {
	{-object_id:required}
	{-by:boolean}
	{-from:boolean}
	{-time:boolean}
} {
	Produces an HTML widget describing the modification status of an
	object.

	@author helsleya@cs.ucr.edu (AH)
	@creation-date 2004/03/09

	@param	-object_id	The object_id of the object to return formatted modification info for.
	@param	-by			(optional) Controls display of 'Modified by' (an OACS user-name)
	@param	-from		(optional) Controls display of 'Modified from' (an IP address/Host name)
	@return The string quoted for Javascript
} {
	db_1row modification_info {
		select	to_char(last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(last_modified, 'hh:mi am')		as modified_at,
				party.name(modifying_user)				as modified_by,
				modifying_ip							as modified_from
		  from	acs_objects
		 where	object_id = :object_id
	}

	set tbl_html [subst {
		<table class="layout" style="font-size: 9pt; font-style: italic">
			<tr><th class="secondary-header" align="left" colspan="2">
					Last Updated
				</th>
			</tr>
			<tr><th class="secondary-header" align="right">
					on</th><td>$modified_on</td>
			</tr>
	}]

	if {$by_p && [exists_and_not_null modified_by]} {
		append tbl_html [subst {
			<tr><th class="secondary-header" align="right">
					by</th><td>$modified_by</td>
			</tr>
		}]
	}

	if {$from_p && [exists_and_not_null modified_from]} {
		append tbl_html [subst {
			<tr><th class="secondary-header" align="right">
					from</th><td>$modified_from</td>
			</tr>
		}]
	}

	append tbl_html {
		</table>
	}
	return $tbl_html
}

ad_proc -public ctrl::modified_html {
	{-object_id:required}
	{-by:boolean}
	{-from:boolean}
	{-time:boolean}
} {
	Produces an HTML widget describing the modification status of an
	object.

	@author helsleya@cs.ucr.edu (AH)
	@creation-date 2004/03/09

	@param	-object_id	The object_id of the object to return formatted modification info for.
	@param	-by			(optional) Controls display of 'Modified by' (an OACS user-name)
	@param	-from		(optional) Controls display of 'Modified from' (an IP address/Host name)
	@return The string quoted for Javascript
} {
	db_1row modification_info {
		select	to_char(last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(last_modified, 'hh:mi am')		as modified_at,
				party.name(modifying_user)				as modified_by,
				modifying_ip							as modified_from
		  from	acs_objects
		 where	object_id = :object_id
	}

	set tbl_html [subst {
		<table class="layout" style="font-size: 9pt; font-style: italic">
			<tr><th class="secondary-header" align="left" colspan="2">
					Last Updated
				</th>
				<th class="secondary-header" align="right">
					on
				</th><td>$modified_on</td>
				<th class="secondary-header" align="right">
					at
				</th><td>$modified_at</td>
	}]

	if {$by_p && [exists_and_not_null modified_by]} {
		append tbl_html [subst {
			<th class="secondary-header" align="right">
					by</th><td>$modified_by</td>
		}]
	}

	if {$from_p && [exists_and_not_null modified_from]} {
		append tbl_html [subst {
			<th class="secondary-header" align="right">
					from</th><td>$modified_from</td>
		}]
	}

	append tbl_html {
		</tr></table>
	}
	return $tbl_html
}

ad_proc -public ctrl::created_column {
	{-object_id:required}
	{-by:boolean}
	{-from:boolean}
	{-time:boolean}
} {
	Produces an HTML widget describing the creation status of an
	object.

	@author helsleya@cs.ucr.edu (AH)
	@creation-date 2004/03/09

	@param	-object_id	The object_id of the object to return formatted creation info for.
	@param	-by			(optional) Controls display of 'Created by' (an OACS user-name)
	@param	-from		(optional) Controls display of 'Created from' (an IP address/Host name)
	@return The string quoted for Javascript
} {
	db_1row creation_info {
		select	to_char(creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(creation_date, 'hh:mi am')		as created_at,
				party.name(creation_user)				as created_by,
				creation_ip								as created_from
		  from	acs_objects
		 where	object_id = :object_id
	}

	set tbl_html [subst {
		<table class="layout" style="font-size: 9pt; font-style: italic">
			<tr><th class="secondary-header" align="center" colspan="2">
					Created
				</th>
			</tr>
			<tr><th class="secondary-header" align="right">
					on</th><td>$created_on</td>
			</tr>
	}]

	if {$by_p && [exists_and_not_null created_by]} {
		append tbl_html [subst {
			<tr><th class="secondary-header" align="right">
					by</th><td>$created_by</td>
			</tr>
		}]
	}

	if {$from_p && [exists_and_not_null created_from]} {
		append tbl_html [subst {
			<tr><th class="secondary-header" align="right">
					from</th><td>$created_from</td>
			</tr>
		}]
	}

	append tbl_html {
		</table>
	}
	return $tbl_html
}

ad_proc -public ctrl::created_html {
	{-object_id:required}
	{-by:boolean}
	{-from:boolean}
	{-time:boolean}
} {
	Produces an HTML widget describing the creation status of an object.

	@author helsleya@cs.ucr.edu (AH)
	@creation-date 2004/03/09

	@param	-object_id	The object_id of the object to return formatted creation info for.
	@param	-by			(optional) Controls display of 'Created by' (an OACS user-name)
	@param	-from		(optional) Controls display of 'Created from' (an IP address/Host name)
	@return The string quoted for Javascript
} {
	db_1row creation_info {
		select	to_char(creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(creation_date, 'hh:mi am')		as created_at,
				party.name(creation_user)				as created_by,
				creation_ip								as created_from
		  from	acs_objects
		 where	object_id = :object_id
	}

	set tbl_html [subst {
		<table class="layout" style="font-size: 9pt; font-style: italic">
			<tr><th class="secondary-header" align="center" colspan="2">
					Created
				</th>
				<th class="secondary-header" align="right">on</th>
				<td>$created_on</td>
				<th class="secondary-header" align="right">at</th>
				<td>$created_at</td>
	}]

	if {$by_p && [exists_and_not_null created_by]} {
		append tbl_html [subst {
				<th class="secondary-header" align="right">
					by
				</th><td>$created_by</td>
		}]
	}

	if {$from_p && [exists_and_not_null created_from]} {
		append tbl_html [subst {
				<th class="secondary-header" align="right">
					from
				</th><td>$created_from</td>
		}]
	}

	append tbl_html {
		</tr></table>
	}
	return $tbl_html
}
