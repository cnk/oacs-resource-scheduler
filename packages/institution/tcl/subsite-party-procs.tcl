# -*- tab-width: 4 -*-
# /packages/institution/tcl/subsite-party-procs.tcl
ad_library {
	Procs for building subqueries returning party_ids of parties related to a
	subsite.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/05/19
	@cvs-id			$Id: subsite-party-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@subsite::for_any_party_p
	@subsite::parties_sql
	@subsite::party_admin_detail_url
}

namespace eval subsite {}


ad_proc -public subsite::for_any_party_p {
	{-subsite_id}
} {
	Returns 1 if this subsite is for one or more parties, otherwise return 0.
} {
	if {![exists_and_not_null subsite_id]} {
		set subsite_id [ad_conn subsite_id]
	}
	return [db_string root_parties_exist_p {} -default 0]
}


# //TODO// add boolean to also select groups that have subsite_for_party_rel
#	ROOTS, TRUNK
ad_proc -public subsite::parties_sql {
	{-subsite_id}
	{-only:boolean}
	{-root:boolean}
	{-trunk:boolean}
	{-persons:boolean}
	{-groups:boolean}
	{-party_id ""}
} {
	<p>This proc returns a block of SQL that should be used either as a
	predicate-subquery in a SQL <code>where</code> clause or in an SQL
	<code>in</code> clause within the <code>where</code> clause.  The first
	approach requires passing an appropriate string for <code>-party_id</code>
	and returns an <code>exists</code> predicate-subquery.  The second approach
	provides a subquery that lists the <code>party_id</code>&apos;s of those
	parties who belong to the subsite.</p>

	<p>If <code>-root</code> is passed, then it only selects those parties that
	belong at the <q>top level</q> of the site (i.e. they are the <q>root</q>
	groups and/or people who are directly members of the root groups).  Groups
	are considered to be at the top-level if they are a sub-group of a group
	which is directly associated to the subsite via a
	<code>subsite_for_party_rel</code> OR if there is no
	<code>subsite_for_party_rel</code> for the subsite and the group has a
	<q>null</q> <code>parent_group_id</code>.</p>

	<p>By calling the proc with the <code>-persons</code> or
	<code>-groups</code> flags, the resulting SQL fragment will only select
	parties of the corresponding type.  If neither boolean is used, a query that
	selects boths kinds of parties is returned.</p>

	<code><pre>
    set user_in_subsite_p [subsite::parties_sql -persons -party_id "u.user_id"]
    set subsite_user_ids  [db_list subsite_user_ids "
        select user_id
          from users u
         where $user_in_subsite_p
    "]
	</pre></code>

	For <code>-party_id</code> you can use a column reference from an outter
	query, a bind variable, a single-valued subquery, or even a constant.
	</p>

	<p>Note that running this query requires that the bind variable
	<code>:subsite_id</code> exist when the query is eventually run.  Be
	especially careful the appropriate value for subsite_id is passed when this
	query is passed to an <code>include</code>-ed page.</p>

	@author helsleya@cs.ucr.edu

	@param subsite_id	(defaults to <code>[ad_conn subsite_id]</code>)
	@param only			When combined with -root and -trunk, selects only those
						nodes.
	@param root			SQL should match/select <q>top-level</q> parties.
	@param trunk		SQL should match/select <q>2nd-level</q> parties.
	@param groups		Match/select groups pertaining to the subsite.
	@param persons		Match/select people pertaining to the subsite.
	@param party_id		Compare all otherwise-matched <code>party_id</code>s
						with the given party_id.
	@return SQL subquery to help select subsite parties
} {
	# //TODO// temporary
	#	Onl	Rt	Trk
	#	0	0	X	Trunk and Lower
	#	0	1	0	Root and Below Trunk
	#	0	1	1	All
	#	1	0	0	Non-Root/Trunk
	#	1	0	1	Only Trunk
	#	1	1	0	Only Root
	#	1	1	1	Only Root and Trunk

	# Wish we had full use of ad_page_contract-style parameter parsing...
	if {![exists_and_not_null subsite_id]} {
		set subsite_id	[ad_conn subsite_id]
	}

	# Setup sensible defaults when neither boolean is passed in
	if {![exists_and_not_null groups_p] && ![exists_and_not_null persons_p]} {
		set groups_p	1
		set persons_p	1
	}

	# Decide which is the best view to use
	if {$groups_p == $persons_p} {
		set base_view "vw_group_element_map"
	} elseif {$groups_p} {
		set base_view "vw_group_component_map"
	} elseif {$persons_p} {
		set base_view "vw_group_member_map"
	}

	# See if there are root-parties for the subsite
	set subsite_roots_exist_p [subsite::for_any_party_p -subsite_id $subsite_id]

	ns_log notice "subsite::parties_sql subsite_id=$subsite_id only=$only_p root=$root_p trunk=$trunk_p groups=$groups_p persons=$persons_p party_id=\"$party_id\" (subsite_roots_exist=$subsite_roots_exist_p)"

	# Build a fragment designed to filter out the 'root-groups' which will not
	#	be displayed on the subsite unless the subsite is not affiliated with
	#	any particular party
	if {$subsite_roots_exist_p} {
		set rels			rels	;#-"t[string range [ns_rand] 2 end]"	;# use string-range to drop the sign of the random variable
		set root_group_id	"$rels.object_id_two"
		set subsite_root_groups_sql	{
			  from	acs_rels			$rels
			 where	$rels.rel_type		= 'subsite_for_party_rel'
			   and	$rels.object_id_one	= :subsite_id
		}
	} else {
		if {$only_p && $root_p && $groups_p} {
			if {[exists_and_not_null party_id]} {
				set sql "
					exists
					(select	1
					   from	inst_groups	g__
					  where	g__.parent_group_id	is null
						and	g__.group_id			= $party_id)
				"
			} else {
				set sql "
					select	g__.group_id
					  from	inst_groups	g__
					 where	g__.parent_group_id	is null
				"
			}
			#-ns_log notice "subsite::parties_sql: $sql"
			return $sql
		} elseif {!$only_p && !$root_p && !$trunk_p} {
			# if there is no subsite_root, we are selecting all, not just root
			# and/or trunk, then all personnel/groups are fair game
			set sql " 1 = 1 "
			#-ns_log notice "subsite::parties_sql: $sql"
			return $sql
		}

		set grps			grps	;#-"t[string range [ns_rand] 2 end]"	;# use string-range to drop the sign of the random variable
		set root_group_id	"$grps.group_id"
		set subsite_root_groups_sql	{
			  from	inst_groups				$grps
			 where	$grps.parent_group_id	is null
		}

		# Because of the above 'if', we could leave out
		# !$subsite_root_groups_p, but its left in for clarity because it is
		# SUPER important.
		if {$trunk_p && $groups_p && !$persons_p && !$subsite_roots_exist_p} {
			# If we only want root groups and none exist specifically for this
			#	subsite, these are easily found with the plain query above...
			if {[exists_and_not_null party_id]} {
				set sql "exists
						(select 1
						[subst $subsite_root_groups_sql]
						   and $grps.group_id = $party_id)"
			} else {
				set sql "select $root_group_id as party_id
						[subst $subsite_root_groups_sql]"
			}
			#-ns_log notice "subsite::parties_sql: $sql"
			return $sql
		}
	}

	# Figure out which column to use when constraining the ancestor of the party
	#	The parent_id column will restrict the party to being directly related
	#	to the 'root' group while using the 'ancestor_id' column will allow any
	#	indirect descendants to be considered part of the selected set.
	set elms elms					;#-"t[string range [ns_rand] 2 end]"	;# use string-range to drop the sign of the random variable
	if {$trunk_p} {
		set ancstr_group_column_name "$elms.parent_id"
	} else {
		set ancstr_group_column_name "$elms.ancestor_id"
	}

	# If the caller passed in an expression for 'party_id', make the
	#	outter query into an 'exists' query as well
	if {[exists_and_not_null party_id]} {
		set subsite_parties_sql " exists (select 1 "
	} else {
		set subsite_parties_sql " select $elms.child_id as party_id "
	}

	# Build the query using the most appropriate view and subsite-root-parties
	append subsite_parties_sql "
		  from	$base_view						$elms
		 where	exists
				(select	1
				 [subst	$subsite_root_groups_sql]
					and	$root_group_id			= $ancstr_group_column_name)
	"

	# If the caller wanted an 'exists' query, this test needs to be inside
	#	this subquery and compare against parties that are selected as
	#	part of the subsite
	if {[exists_and_not_null party_id]} {
		append subsite_parties_sql " and $elms.child_id = $party_id "
	}

	# If there were no subsite roots, make sure to include default roots
	if {$groups_p && !$subsite_roots_exist_p} {
		append	subsite_parties_sql " union select $root_group_id " \
				[subst $subsite_root_groups_sql]

		# Apply the same criteria applied to subsite parties above to
		#	displayed root-groups
		if {[exists_and_not_null party_id]} {
			append subsite_parties_sql " and $root_group_id = $party_id "
		}
	}

	# //TODO// rewrte: this is ugly and doesn't work as expected in all cases
	# Add in 'roots'
	if {$root_p} {
		set		rels rels
		if {$only_p} {
			if {[exists_and_not_null party_id]} {
				set subsite_parties_sql " exists (select 1 "
			} else {
				set subsite_parties_sql " select $rels.object_id_two as party_id "
			}
		} else {
			append	subsite_parties_sql " union select $rels.object_id_two "
		}
		append	subsite_parties_sql "
				 from	acs_rels		$rels
				where	$rels.object_id_one	= :subsite_id
				  and	$rels.rel_type		= 'subsite_for_party_rel'
		"

		# Apply the same criteria applied to subsite parties above to
		#	displayed root-groups
		if {[exists_and_not_null party_id]} {
			append subsite_parties_sql " and $rels.object_id_two = $party_id "
		}
	}

	# Close the parenthesis from "exists (select 1"
	if {[exists_and_not_null party_id]} {
		append subsite_parties_sql ") "
	}

	#-ns_log notice "subsite::parties_sql: $subsite_parties_sql"
	return $subsite_parties_sql
}

ad_proc -public subsite::parties_sql_from_index {
	{-subsite_id}
	{-only:boolean}
	{-root:boolean}
	{-trunk:boolean}
	{-persons:boolean}
	{-groups:boolean}
	{-party_id}
} {
} {
	#	Onl	Rt	Trk
	#	0	0	0	Below Trunk				-> 001
	#	0	0	1	Trunk and Lower
	#	0	1	0	Root and Below Trunk	-> 011
	#	0	1	1	All
	#	1	0	0	Non-Root/Trunk
	#	1	0	1	Only Trunk
	#	1	1	0	Only Root
	#	1	1	1	Only Root and Trunk

	# Wish we had full use of ad_page_contract-style parameter parsing...
	if {![exists_and_not_null subsite_id]} {
		set subsite_id	[ad_conn subsite_id]
	}

	# See if there are root-parties for the subsite
	set subsite_roots_exist_p [subsite::for_any_party_p -subsite_id $subsite_id]

	#ns_log notice "subsite::parties_sql_from_index subsite_id=$subsite_id only=$only_p root=$root_p trunk=$trunk_p groups=$groups_p persons=$persons_p party_id=\"$party_id\" (subsite_roots_exist=$subsite_roots_exist_p)"
	if {!$subsite_roots_exist_p} {
		return "**ERROR**"
	}

	# Produce the party_type_matches_p predicate
	switch "$groups_p$persons_p" {
		"00" { set party_type_matches_p	"1 = 1"					}
		"01" { set party_type_matches_p	"party_is_person_p = 1"	}
		"10" { set party_type_matches_p	"party_is_person_p = 0"	}
		"11" { set party_type_matches_p	"1 = 1"					}
	}

	# Produce the depth_matches_p predicate
	switch "$only_p$root_p$trunk_p" {
		"000" -
		"001" { set depth_matches_p	"depth >  0"		}
		"010" { set depth_matches_p	"depth <> 1"		}
		"011" { set depth_matches_p	"depth  = depth"	}

		"100" { set depth_matches_p	"depth > 1"			}
		"101" { set depth_matches_p	"depth  = 1"		}
		"110" { set depth_matches_p	"depth <  1"		}
		"111" { set depth_matches_p	"depth <= 1"		}
	}

	# Return the proper type of subquery:
	#	Type 1 advantages: simple, usable in FROM or WHERE clause
	#	Type 2 advantages: performance(?), reduced interference with column-name set in parent queries
	if {![exists_and_not_null party_id]} {
		return "
			select	party_id
			  from	inst_subsite_party_index
			 where	subsite_id	= :subsite_id
			   and	$depth_matches_p
			   and	$party_type_matches_p
		"
	} else {
		return "
			exists (
				select	1
				  from	inst_subsite_party_index
				 where	subsite_id	= :subsite_id
				   and	$depth_matches_p
				   and	$party_type_matches_p
				   and	party_id	= $party_id
			)
		"
	}
}

ad_proc -public subsite::parties_sql_new {
	{-subsite_id}
	{-only:boolean}
	{-root:boolean}
	{-trunk:boolean}
	{-persons:boolean}
	{-groups:boolean}
	{-party_id}
} {} {
	# //TODO// temporary (Exp = Expired Title?, Onl = Only, Rt = Root, Trk = Trunk)
	#	Exp	Onl	Rt	Trk
	#	0 	0	0	0								--> 1
	#	0 	0	0	1	Trunk and Lower
	#	0 	0	1	0	Root and Below Trunk	**	--> 3
	#	0 	0	1	1	All
	#	0 	1	0	0	Non-Root/Trunk			**
	#	0 	1	0	1	Only Trunk
	#	0 	1	1	0	Only Root
	#	0 	1	1	1	Only Root and Trunk

	set subsite_id [subst $subsite_id]

	# Setup sensible defaults when neither boolean is passed in
	if {![exists_and_not_null groups_p] && ![exists_and_not_null persons_p]} {
		set groups_p	1
		set persons_p	1
	}

	set sql_select(select\	1)									1
	set sql_from(acs_rels\	\	r)								1
	set sql_where(r.rel_type\	\	=\ 'subsite_for_party_rel')	1
	set sql_where(r.object_id_one\	=\ :subsite_id)				1

	switch "$only_p$root_p$trunk_p" {
		"000" -
		"001" {
			set 
		}

		"010" -
		"011" {
		}

		"100" {
			set	party_id_col	"cid"
			set	party_id_column	"child_id"
			set party_id_tbl	"gem"
			set party_id_table	"vw_group_element_map"
		}

		"101" {
		}

		"110" {
		}

		"111" {
		}
	}

	# See if there are root-parties for the subsite
	set subsite_roots_exist_p [subsite::for_any_party_p -subsite_id $subsite_id]

	return $subsite_parties_sql
}

ad_proc -public subsite::party_admin_detail_url {
	{-subsite_id	{[ad_conn subsite_id]}}
	{-party_id}
} {
	<p>This proc returns the closest URL to a page of details about the party
	given by the <code>-party_id</code> parameter.</p>

	<p>For now, this proc should only be called from a page in a subdirectory of
	<code>institution/www/admin/</code>.</p>

	<p>An empty string is returned if no suitable URL can be constructed.</p>

	@param	subsite_id	The subsite to search for the URL in.
	@param	party_id	The party to search for.

	@return				A URL in the subsite to a page of details about the party.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2004-11-29 14:33
} {
	if {[db_0or1row party_info {
		select	p.party_id,
				u.user_id,
				psnl.personnel_id,
				g.group_id
		  from	parties			p,
				users			u,
				inst_personnel	psnl,
				inst_groups		g
		 where	p.party_id	= :party_id
		   and	p.party_id	= u.user_id (+)
		   and	p.party_id	= psnl.personnel_id (+)
		   and	p.party_id	= g.group_id (+)
		}] != 1} {
		return ""
	}

	if {[exists_and_not_null group_id]} {
		return "../groups/detail?[export_vars {group_id}]"
	} elseif {[exists_and_not_null personnel_id]} {
		return "../personnel/detail?[export_vars {personnel_id}]"
	} elseif {[exists_and_not_null user_id]} {
		return "../../../shared/community-member?[export_vars {user_id}]"
	} else {
		return ""
	}
}

ad_proc -public subsite::party_group_id {
	{-subsite_id	{[ad_conn subsite_id]}}
} {
	This proc returns the root group_id for the subsite_id passed in
} {
	set subsite_root_exists_p [subsite::for_any_party_p -subsite_id $subsite_id]
	return [db_string subsite_group_id {} -default ""]
}
