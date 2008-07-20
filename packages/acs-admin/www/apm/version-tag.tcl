ad_page_contract { 
    Tag each file in a package as part of a particular package version.

    @param version_id The package to be processed.
    @author ron@arsdigita.com
    @creation-date 9 May 2000
    @cvs-id $Id: version-tag.tcl,v 1.4 2007-01-10 21:21:59 gustafn Exp $
} {
    {version_id:integer}
}

db_1row apm_package_by_version_id {
    select package_name, version_name, package_id 
    from apm_package_version_info where version_id = :version_id
}

if { $installed_p eq "f" } {
    ad_return_complaint 1 "<li>The selected version is not installed"
    return
}

set files [db_list apm_all_paths {
	select path from apm_package_files where version_id = :version_id order by path
}]

if { [llength $files] == 0 } {
    ad_return_complaint 1 "<li>No files in this packages"
   return
}

# Create a legal CVS tag to mark the files by substituting -'s for all
# of the .'s in the version_name. The other rules for a legal version
# name are compatible with CVS.

set version_tag [apm_package_version_release_tag $package_key $version_name]

# Path to the CVS executable

set cvs [ad_parameter CvsPath vc]

doc_body_append "[apm_header [list "version-view?version_id=$version_id" "$package_name $version_name"] [list "version-files?version_id=$version_id" "Files"] "Tag"]

<p> We're going to write the CVS tag <code>$version_tag</code> into
the repository for each file in this package.  This will let you
retrieve the exact set of revisions that make up
$package_name $version_name in the future.  You can repeat
this operation as often as you want, to tag new files for example.

<p>Here goes:

<blockquote>
<pre>
"

# Check for the existence of CVS/Root as a basic check that each file is
# under version control.  No error handling yet.

set bad_file_count  0
set files_to_add    [list]
set files_to_commit [list]

foreach path $files {
    global vc_file_props

    vc_parse_cvs_status [apm_fetch_cached_vc_status "packages/$package_key/$path"]

    switch $vc_file_props(status) {
	"Up-to-date" {
	    set full_path [acs_package_root_dir $package_key]/$path
	    exec $cvs tag -F $version_tag $full_path
	    set status "T $path"
	}

	"Locally Modified" {
	    incr bad_file_count
	    lappend files_to_commit $path
	    set status "M $path (Locally Modified)"
	}

	default {
	    incr bad_file_count
	    lappend files_to_add $path
	    set status "I $path (No CVS Information)"
	}
    }

    doc_body_append "$status\n"
    doc_body_flush
}

doc_body_append "
</pre>
</blockquote>
"

# Update the versions table to indicate whether or not this version
# was successfully tagged.

if {$bad_file_count} { 

    doc_body_append "<p> Some of your files could not be tagged."

    if { [llength $files_to_commit] } { 
	doc_body_append "
	<p> The following have local modifications that have not yet been committed.  
	To commit them use:
	<blockquote><pre>cd [acs_package_root_dir $package_key]\n"
	apm_write_shell_wrap [concat [list cvs commit] $files_to_commit]
	doc_body_append "</pre></blockquote>"
    }

    if { [llength $files_to_add] } {
	doc_body_append "
	<p>The following have not been added to the CVS repository. To add them use:
	<blockquote><pre>ad [acs_package_root_dir $package_key]\n"
	apm_write_shell_wrap [concat [list cvs add] $files_to_add]
	doc_body_append "</pre></blockquote>"
    }

    doc_body_append "<p> After correcting the above problems you can reload
    this page or run the tagging operation again.  This package won't
    be archivable until the tagging is completed with no errors."

    db_dml apm_all_files_untag {
	update apm_package_versions 
	set    tagged_p   = 'f' 
	where  version_id = :version_id
    }
} else {
    doc_body_append "<p>All files were tagged successfully."
    db_dml apm_all_files_tag {
	update apm_package_versions 
	set    tagged_p   = 't' 
	where  version_id = :version_id
    }
}

doc_body_append "
<p>
<a href=version-files?version_id=$version_id>Return to the Package Manager.</a>
[ad_footer]
"

