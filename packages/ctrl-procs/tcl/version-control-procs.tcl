# -*- tab-width: 4 -*-
ad_library {
	Procs for working with files in version control systems.

	@author			helsleya@cs.ucr.edu (ACH)
	@creation-date	2005-05-11
	@cvs-id			$Id: version-control-procs.tcl,v 1.1 2005/05/12 01:35:25 andy Exp $
}

namespace eval ctrl::vc {}

ad_proc -public ctrl::vc::versioned_p {
	{-vc}
	{-any:boolean}
	{args}
} {
	Returns true if all (any) files are managed with a version control system.

	@param	vc		The version control system (leave empty if either is ok)
	@param	any		Pass this if its sufficient if any of the files listed in
					<code>args</code> is versioned.
	@return			Returns 0 or non-zero

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-05-11 16:03 PDT
} {
	foreach path $args {
		set dir [file dirname $path]
		set fil [file tail $path]

		set svn_versioned_p	[file exists "$dir/.svn/$fil.svn-base"]
		set cvs_versioned_p	[exec bash -c "if cat $dir/CVS/Entries | grep '^D?/$fil' &>/dev/null; then echo -n 1; else echo -n 0; fi"]

		if {![exists_and_not_null vc]} {
			set versioned_p		[expr 0 + $svn_versioned_p + $cvs_versioned_p]
		} else {
			set versioned_p [subst $${vc}_versioned_p]
		}

		# Exit early if possible ($any_p is true and file is versioned, or
		# $any_p is false (all must be versioned) and file is unversioned)
		if {$versioned_p == $any_p} {
			return $versioned_p
		}
	}

	return [expr !$any_p]
}

ad_proc -public ctrl::vc::commit {
	{-comment:required}
	{-add:boolean}
	{args}
} {
	Commit changes to a file(s) into CVS or SVN.  If you pass '-add', it will be
	added to the repository if it isn't already a part of the repository.

	@param	comment	A description of the changes made.
	@param	add		Pass this to add the file(s) to CVS/SVN if they aren't
					already in the repository
	@param	args	The file(s) to be placed under version-control.  The files
					should be listed using an absolute path (from the filesystem
					root) for each file.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-05-11 15:17 PDT
} {
	foreach path $args {
		set dir [file dirname $path]
		set fil [file tail $path]

		# Skip if the file is not in a CVS managed directory
		if {![file exists $path] ||
			(![file isdirectory "$dir/CVS"] &&
			![file isdirectory "$dir/.svn"])} {
			continue
		}

		lappend vc_files($dir) $fil
	}

	foreach {dir files} [array get vc_files] {
		set dir [file dirname $path]

		# Figure out which version control system to use
		switch "[file isdirectory "$dir/CVS"][file isdirectory "$dir/.svn"]" {
			"00" continue
			"01" { set vc_cmd svn }
			"10" { set vc_cmd cvs }
		}

		foreach fil $files {
			if {$add_p && ![ctrl::vc::versioned_p "$dir/$fil"]} {
				lappend files_to_add $fil
			}
		}
		set files_to_commit $files

		if {[exists_and_not_null files_to_add]} {
			lappend shell_cmds "$vc_cmd add \"[join $files_to_add {" "}]\" 2>&1"
		}
		if {[exists_and_not_null files_to_commit]} {
			lappend shell_cmds "$vc_cmd commit -m \"$comment\" \"[join $files_to_commit {" "}]\" 2>&1"
		}

		lappend shell_cmds "true"
		exec bash -c "cd \"$dir\" && ([join $shell_cmds { ; }])"
	}
}

ad_proc -public ctrl::vc::remove {
	{-comment:required}
	{-commit:boolean}
	{args}
} {
	Remove one or more files from the version control system.

	@param	comment	The reason the files are being removed from version control.
	@param	commit	Pass this if you want the removal to be committed.
	@param	args	The files to be removed from version-control.  The files
					should be listed using an absolute path (from the filesystem
					root) for each file.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-05-11 17:03 PDT
} {
	foreach path $args {
		set dir [file dirname $path]
		set fil [file tail $path]

		# Skip if the file is not in a CVS managed directory
		if {![file exists $path] ||
			(![file isdirectory "$dir/CVS"] &&
			![file isdirectory "$dir/.svn"])} {
			continue
		}

		lappend vc_files($dir) $fil
	}

	foreach {dir files} [array get vc_files] {
		set dir [file dirname $path]

		# Figure out which version control system to use
		switch "[file isdirectory "$dir/CVS"][file isdirectory "$dir/.svn"]" {
			"00" continue
			"01" { set vc_cmd svn }
			"10" { set vc_cmd cvs }
		}

		foreach fil $files {
			if {[ctrl::vc::versioned_p "$dir/$fil"]} {
				lappend files_to_remove $fil
			}
		}

		# Remove files from disk (if CVS), VC remove, then VC commit
		if {[exists_and_not_null files_to_remove]} {
			if {$vc_cmd == "cvs"} {
				lappend shell_cmds "rm -rf \"[join $files_to_remove {" "}]\""
			}

			lappend shell_cmds "$vc_cmd remove \"[join $files_to_remove {" "}]\" 2>&1"

			if {$commit_p} {
				lappend shell_cmds "$vc_cmd commit -m \"$comment\" \"[join $files_to_remove {" "}]\" 2>&1"
			}
		}

		lappend shell_cmds "true"
		exec bash -c "cd \"$dir\" && ([join $shell_cmds { ; }])"
	}
}

# //TODO//
# move X Y [X Y] ...
# copy
# mkdir
# ignore
