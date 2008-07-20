# -*- tab-width: 4 -*-
ad_page_contract {
	Interface for selecting a subset and re-ordering it for display on a given
	subsite.

	@author			helsleya@cs.ucr.edu
	@cvs-id			$Id: order-subset-for-subsite.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{subsite_id:integer,notnull}
	{personnel_id:integer,notnull}
	{return_url	[get_referrer]}
	{step:naturalnum,optional}
}

if {[db_0or1row object_names {}] == 0} {
	ad_return_complaint 1 "The person or subsite you requested does not exist."
	ad_script_abort
}

# CHECK PERMISSIONS ############################################################
permission::require_permission -object_id $personnel_id -privilege admin

set title				"Publications for $personnel_name on the $subsite_name Website"
set context				[list [list ../ "Admin"] $title]
set user_id				[ad_conn user_id]

set party_detail_url	[subsite::party_admin_detail_url -party_id $personnel_id]

# A select button set the ordering according to sort a given publication attribute
set sortable_by [db_list_of_lists publication_attributes {}]
set sortable_by [linsert $sortable_by  0 [list "(Custom)" ""]]

# Get a list of publications which are not shown on this site
set excluded [db_list_of_lists unordered_personnel_publications {}]

# Get a list of all publications show on the given subsite
set included [db_list_of_lists ordered_personnel_publications {}]
if {[llength $included] == 0} {
	set all_p 0
	db_transaction {
		db_exec_plsql create_default_ordered_subset {}
	}
	set included [db_list_of_lists ordered_personnel_publications {}]
	set excluded [db_list_of_lists unordered_personnel_publications {}]
}

set edit_list_buttons [subst {
	<h2 style="color: maroon">2: Choose Publications To Hide</h2>
	Select the publication and click a button to move it between lists.<br>
	'Hide' moves publications selected in the top list to the end of the bottom list.<br>
	'Show' moves publications selected in the bottom list to the end of the top list.<br>
	<input type="button" value="Show" onClick="include()" title="Click here to prevent the publication(s) selected below from displaying on the $subsite_name site."/>
	<input type="button" value="Hide" onClick="exclude()" title="Click here to show the publication(s) selected above on the $subsite_name site."/>
}]

set reorder_included_buttons [subst {
	<table>
		<tr><td colspan="100%">
				<h2 style="color: maroon">1: Re-order Visible Publications</h2>
			</td>
		</tr>
		<tr><td><table	style="display: inline"
						title="Clicking on these buttons will change the order in which the visible publications are shown.">
					<tr><td align="right">
							<input	type="button"
									id="up"
									value="^"
									onClick="shiftSelectedOptions(document.publication_ordered_subset_for_subsite.included, -1)" />
						</td>
					</tr>
					<tr><td align="right">
							<input	type="button"
									id="sort"
									value="Sort"
									title="Sort by Date -- Click a second time to reverse the ordering."
									onClick="sortOptions(document.publication_ordered_subset_for_subsite.included.options)" />
						</td>
					</tr>
					<tr><td align="right">
							<input	type="button"
									id="dn"
									value="v"
									onClick="shiftSelectedOptions(document.publication_ordered_subset_for_subsite.included,  1)" />
						</td>
					</tr>
				</table>
			</td><td>
}]

set form_name publication_ordered_subset_for_subsite
ad_form -name $form_name -export {return_url step} -form {
	{subsite_id:integer(hidden)													}
	{personnel_id:integer(hidden)												}
	{included:integer(multiselect),multiple,optional
		{label			"<h3>Visible<br> Publications</h3>"}
		{tooltip		"This is a list of $personnel_name's publications which will be shown on the $subsite_name site."}
		{help_text		{Clicking on the buttons to the right will change the order in which the visible publications are shown.}}
		{options		$included}
		{html			{size 15}}
		{before_html	$reorder_included_buttons}
		{after_html		{</td></tr></table>}}
	}
	{show_or_hide_buttons:text(inform),optional
		{label			" "}
		{value			""}
		{after_html		{<br><center>$edit_list_buttons</center>}}}
	{excluded:integer(multiselect),multiple,optional
		{label			"<h3>Hidden<br> Publications</h3>"}
		{tooltip		"This is a list of all $personnel_name's publications that will not be shown in the $subsite_name site."}
		{options		$excluded}
		{html			{size 7}}
	}
	{all_p:boolean(hidden),optional
		{label			"Show All Publications?"}
		{tooltip		"Check this box to show all publications, sorted descending by date pubished, on $personnel_name's public page."}
		{options		{ {{} 1} }}
		{html			{onClick "setAllPTo(this.checked)"}}
	}
	{limit:integer(hidden),optional								{label "Limit"}										{html {size 4}}		}
	{sort_by:text(hidden),optional
		{label			"Sort By"}
		{tooltip		"Use this to automatically sort $personnel_name's selected publications when they are displayed on the $subsite_name site."}
		{options		$sortable_by}
	}
	{sort_dir:boolean(hidden),optional
		{label			" "}
		{options		{ {Descending 1} }}
		{tooltip		"Check this box to make the sort go in descending order."}
	}
	{submit:text(submit)	{label "Save"}
		{before_html	{<h2 style="color: maroon">3: Save Your Changes</h2>}}
	}
} -html {
	onSubmit	"prepareForSubmit()"
} -on_request {
	# if there is no subset	set the sort_by field to publish_date, set all_p = true
	if {[llength $included] == 0} {
		db_exec_plsql create_default_ordered_subset {}
		set included [db_list_of_lists ordered_personnel_publications {}]
		set excluded [db_list_of_lists unordered_personnel_publications {}]
	}
} -on_submit {
	if {[exists_and_not_null all_p] && $all_p != 0} {
		# delete the old customized ordering pertaining to this subsite
		db_transaction {
			db_dml delete_custom_ordering {}
		}
	} else {
		db_transaction {
			# delete the old customized ordering pertaining to this subsite
			db_dml delete_custom_ordering {}

			# create the new ordering
			if {[exists_and_not_null sort_by]} {
				# make sure the column exists before allowing it to be included in the SQL statement
				if {![db_column_exists inst_publications $sort_by]} {
					ad_return_complaint 1 "The column you are attempting to refer to ($sort_by) does not exist."
					ad_script_abort
				}

				set order_by_sql $sort_by

				if {[exists_and_not_null sort_dir]} {
					append order_by_sql " desc"
				}

				# insert rows for the requested orderings
				db_exec_plsql insert_automatic_ordering {}
			} else {
				# insert rows for the requested orderings
				set relative_order 1
				foreach publication_id $included {
					db_dml	insert_custom_ordering {}
					incr	relative_order
				}

				# delete rows they were not allowed to insert (orderings for publications to which they are not mapped)
				db_dml delete_ordering_of_unassociated_publications {}
			}

		}
	}
} -after_submit {
	if {![exists_and_not_null return_url]} {
		set return_url "../personnel/detail?[export_vars {personnel_id}]"
	}
	template::forward $return_url
}

set JAVASCRIPT_BEGIN {
	<script language="JavaScript1.2" type="text/JavaScript"><!--
}
set JAVASCRIPT_END {
	//--></script>
}
