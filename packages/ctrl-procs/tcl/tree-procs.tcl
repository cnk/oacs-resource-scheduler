# -*- tab-width: 4 -*-
# /packages/institution/tcl/tree-procs.tcl
ad_library {
    Procs for building ordered trees of data.

    @author			helsleya@cs.ucr.edu
    @creation-date	2004/09/27
    @cvs-id			$Id: tree-procs.tcl,v 1.5 2005/01/24 22:56:20 jwang1 Exp $

    @tree::sorter::create
	@tree::sorter::make_full_key_for
	@tree::sorter::sort
}

namespace eval tree::sorter {}

ad_proc -public tree::sorter::create {
	{-multirow:required}
	{-sort_by:required}
} {
	<p>Initiliaze a bunch of state variables for a <code>connect by</code> ordered
	tree.</p>

	<p><h3>Example:</h3>
	<pre><code>
    # Create a 'sorter' to sort the data
    tree::sorter::create -multirow <b>categories_tree</b> -sort_by <b>sort_key</b>

    # Get the data
    db_multirow -extend {<b>sort_key</b>} <b>categories_tree</b> categories_tree_sql {
        select  lpad(' ', 6*4*(level-1) + 1, '&amp;nbsp;') || name as name,
                category_id,
                name as <b>rawname</b>,
                <b>level</b>
          from  categories
        connect by prior category_id    = parent_category_id
        start with parent_category_id   = category.lookup('//Personnel Title')
    } {
        set sort_key [tree::sorter::make_full_key_for      \ 
                            -multirow     <b>categories_tree</b>  \ 
                            -partial_key  <b>$rawname</b>         \ 
                            -id           <b>$category_id</b>     \ 
                            -level        <b>$level</b>]
    }

    # Sort the data
    tree::sorter::sort -multirow <b>categories_tree</b>
	</code></pre></p>

	@author helsleya@cs.ucr.edu

	@param multirow The name of the multirow data-source to make sort-keys for.
	@param sort_by	The name of the column that will be populated with the
					sort-key.

	@see tree::sorter::make_full_key_for
	@see tree::sorter::sort
} {
	# Get access to state-variables
	upvar	${multirow}_tree_sorter_sort_stack	stack
	upvar	${multirow}_tree_sorter_sort_column	saved_sort_by

	# Initialize state-variables
	set		stack								[list]
	set		saved_sort_by						$sort_by
}

ad_proc -public tree::sorter::make_full_key_for {
	{-multirow:required}
	{-partial_key:required}
	{-id:required}
	{-level:required}
} {
	Make a key that can be stored with the given row in a
	<code>connect by</code>-ordered tree.  This updates some state variables
	and makes a key from their values.  Once all rows are processed, a call to
	<code>tree::sorter::sort</code> should be made to sort the multirow data.

	@author helsleya@cs.ucr.edu

	@param multirow		The name of the multirow data-source to make a sort-key
						for.
	@param partial_key	The primary field by which the tree will be
						(hierarchically) sorted.
	@param id			The ID to be used as a tie-breaker when sorting.  This
						should be a candidate-key.
	@param level		The depth of the node uniquely identified by
						<code>id</code>
	@return A key for sorting rows in a tree

	@see tree::sorter::create
	@see tree::sorter::sort
} {
	# Get access to state-variables
	upvar ${multirow}_tree_sorter_sort_stack	stack

	set top		[llength $stack]
	set newtop	[expr $level - 1]

	# Pop from the top of the stack and the sort-key if necessary
	if {$newtop < $top && $newtop >= 0} {
		set stack				[lreplace $stack $newtop end]
	}

	# Push current node onto stack and sort-key
	lappend	stack			"$partial_key $id"
	set		full_sort_key	"//[join $stack //]"

	return $full_sort_key
}

ad_proc -public tree::sorter::sort {
	{-multirow:required}
} {
	Sort the given multirow using the full-sort-keys built earlier by the calls
	to <code>tree::sorter</code> proc
	<code>tree::sorter::make_full_key_for</code> created with
	<code>tree::sorter::create</code>.

	@author helsleya@cs.ucr.edu

	@param multirow The name of the multirow data-source to be sorted.

	@see tree::sorter::create
	@see tree::sorter::make_full_key_for
} {
	# Get access to state-variables
	upvar	${multirow}_tree_sorter_sort_column	sort_by
	upvar	${multirow}_tree_sorter_sorted_rows	rows

	# Get access to the data
	set rows [uplevel "template::util::multirow_to_list $multirow"]

	if {[llength $rows] > 1} {
		# Find the correct index to sort by
		set header_row	[lindex $rows 0]
		set sort_index	[expr 1 + [lsearch -exact $header_row $sort_by]]

		# Sort the data
		set rows		[lsort -index $sort_index $rows]

		# Convert the data back into a multirow data-source
		uplevel "template::util::list_to_multirow $multirow \$${multirow}_tree_sorter_sorted_rows"
	}
}

ad_proc -public tree::sorter::sort_list_of_lists {
	{-list:required}
	{-sort_by:required			3}
	{-object_id:required		1}
	{-parent_object_id:required	2}
} {
	<p>Sort the given tree data stored in a list-of-lists.  This code is very
	useful in the ordering of options for select-widgets, and as such the
	default parameter values are arranged so that the display name is in column
	0 and the object-id in column 1.  The list-of-lists needs these 3 columns:
		<ul><li>Object ID</li>
			<li>Parent Object ID</li>
			<li>Object <q>Name</q></li>
		</ul>
	</p>

	<p>The lexical/numerical ordering implied by <code>Object Name</code>
	determines how the tree itself is ordered.  Often times it is usefully to
	select a 4th column with a value which will merely be displayed and not used
	to sort.  Remember the display column should be the first column selected
	when building a list of options for select-widgets.</p>

	<p><h3>Example:</h3>
	<pre><code>
    # Get a list that can be used as the options of a 'select' widget in ad_form
    set directories [db_list_of_lists get_directories {
        select  lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || directory_name as directory_display_name,
                directory_id,               -- unique identifier of node
                parent_directory_id,        -- unique identifier of parent-node
                directory_name              -- determines the ordering
          from  directories
        start   with parent_directory_id    is null
        connect by prior directory_id       = parent_directory_id
    }]

    # Sort the options
    set directories [tree::sorter::sort_lists_of_lists -list $directories -sort_by 3 -object_id 1 -parent_object_id 2]
	</code></pre></p>

	<p>Since the query uses the expected ordering, it is possible to write the
	above example without passing explicit indices for the <code>sort_by</code>,
	<code>object_id</code>, and <code>parent_object_id</code> columns.</p>

	@author helsleya@cs.ucr.edu

	@param list				The list-of-lists that should be sorted as a tree.
	@param sort_by			The index of the element in each row which should
							be used to sort by.
	@param object_id		The index of the element in each row which uniquely
							identifies it.
	@param parent_object_id	The index of the element in each row which contains
							the unique identifier of its parent.
} {
	#//TODO// another approach:
	#	%nodes{ID} --> @node_list
	#	Process Nodes: append to list
	#	Sort Nodes: N sorts
	#	Put results into list-of-lists using in-order traversal

	#	Advantages:
	#		no masssive sort-keys
	#		don't need to pre-process to find max length of names
	#		don't need to worry about errors in building sort keys allowing nodes to jump around in the list

	# Setup the format for sort-keys
	set max_length_of_sort_by 0
	foreach row $list {
		set length_of_sort_by [string length [lindex $row $sort_by]]
		if {$length_of_sort_by > $max_length_of_sort_by} {
			set max_length_of_sort_by $length_of_sort_by
		}
	}
	set sort_key_format "%-${max_length_of_sort_by}s%08s"

	# Setup the list to save results in and two stacks
	set tree				[list]
	set sort_key_stack		[list]
	set	object_id_stack		[list]

	# Make a full-sort-key for each row
	foreach row $list {
		set oid				[lindex $row $object_id]
		set parent_id		[lindex $row $parent_object_id]
		set sort_key		[format $sort_key_format [lindex $row $sort_by] $parent_id]

		# Find parent in stack
		set pos_in_stack	[expr [lsearch $object_id_stack $parent_id] + 1]

		# Clear anything after parent from the stack
		if {$pos_in_stack < [llength $object_id_stack]} {
			set object_id_stack	[lreplace $object_id_stack	\
										  $pos_in_stack		\
										  end				]
			set sort_key_stack	[lreplace $sort_key_stack	\
										  $pos_in_stack		\
										  end				]
		}

		# Push the current object on the stack
		lappend	object_id_stack		$oid
		lappend	sort_key_stack		$sort_key

		# Save the full_sort_key with the row in the tree
		set		full_sort_key		[join $sort_key_stack //]
		lappend	row					$full_sort_key
		lappend	tree				$row
	}

	# Sort the rows, interperet consecutive digits as numbers
	set tree [lsort -dictionary -index end $tree]

	return $tree
}
