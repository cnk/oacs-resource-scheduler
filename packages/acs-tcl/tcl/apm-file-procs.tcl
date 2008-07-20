ad_library {

    Functions that APM uses to interact with the file system and I/O.

    @author Bryan Quinn (bquinn@arsdigita.com)
    @creation-date Fri Oct  6 21:46:05 2000
    @cvs-id $Id: apm-file-procs.tcl,v 1.34 2007-01-10 21:22:12 gustafn Exp $
} 


ad_proc -private apm_mkdir {path} {

    Creates the directory specified by path and returns it.

} { 
    if { [catch {
	file mkdir $path
    }] } {
	# There must be a file blocking the directory creation.
	if { [catch {
	    file delete -force $path
	    file mkdir $path
	} errmsg]} {
	    error "Error creationg directory $path: $errmsg"
	}
    }
    return $path
}

ad_proc -public apm_workspace_dir {} {
    
    Return the path to the apm-workspace, creating the directory if necessary.
    
} {
    set path [file join [acs_root_dir] apm-workspace]
    if { [file isdirectory $path] } {
	return $path
    } else {
	return [apm_mkdir $path]
    }
} 

ad_proc -public apm_workspace_install_dir {} {
    
    Return the path to the installation directory of the apm-workspace, creating
    the directory if necessary.
} {
    set base_path [apm_workspace_dir]
    set install_path "$base_path/install"
    if { [file isdirectory $install_path] } {
	return $install_path
    } else {
	return [apm_mkdir $install_path]
    }
}

ad_proc -public apm_file_type_names {} {
    Returns an array list with filetypes as keys and
    filetype pretty names as values.

    @author Peter Marklund
} {
    return {
        documentation "Documentation"
        tcl_procs "Tcl procedure library"
        tcl_init "Tcl initialization"
        tcl_util "Tcl utility script"
        content_page "Content page"
        package_spec "Package specification"
        sql_data "SQL Data"
        ctl_file "SQL data loader control"
        data_model "Data model"
        data_model_create "Data model installation"
        data_model_drop "Data model deinstallation"
        data_model_upgrade "Data model upgrade"
        java_code "Java code"
        java_archive "Java archive"
        query_file "Query file"
        template "Template file"
        shell "Shell utility"
        sqlj_code "SQLJ library"
        message_catalog "Message Catalog"
    }
}

ad_proc -public apm_file_type_keys {} {

    Returns a list of valid file type keys.

    @see apm_file_type_names
    @see apm_pretty_name_for_file_type
    
    @author Peter Marklund
} {
    array set file_type_names [apm_file_type_names]
    return [array names file_type_names]
}


ad_proc -public apm_db_type_keys {} {

    Returns a list of valid database type keys.

} {
    return [util_memoize [list db_list db_type_keys "select db_type_key from apm_package_db_types"]]
}


ad_proc -public apm_package_info_file_path { 
    {
	-path ""
    }
    package_key 
} {

    Returns the path to a .info file in a package directory, or throws an
    error if none exists. Currently, only $package_key.info is recognized
    as a specification file.

} {
    if { $path eq "" } {
	set path "[acs_package_root_dir $package_key]/$package_key.info"
    } else {
	set path "$path/$package_key/$package_key.info"
    }
    if { [file exists $path] } {
	return $path
    }
    error "The $path/$package_key does not contain a package specification file ($package_key.info)."
}


ad_proc -private apm_extract_tarball { version_id dir } {

    Extracts a distribution tarball into a particular directory,
    overwriting any existing files.
    DCW - 2001-05-03, modified to extract tarball from content repository.

} {

    set apm_file [ns_tmpnam]

    db_blob_get_file distribution_tar_ball_select {
                 select content 
                   from cr_revisions 
                  where revision_id = (select content_item.get_latest_revision(item_id)
                                         from apm_package_versions 
                                         where version_id = :version_id)
                 } $apm_file

    file mkdir $dir
    # cd, gunzip, and untar all in the same subprocess (to avoid having to
    # chdir first).
    exec sh -c "cd $dir ; [apm_gunzip_cmd] -q -c $apm_file | [apm_tar_cmd] xf -" 2>/dev/null
    file delete $apm_file
}


ad_proc -private apm_generate_tarball { version_id } {
    
    Generates a tarball for a version, placing it in the content repository.
    DCW - 2001-05-03, change to use the content repository for tarball storage.
    
} {
    set package_key [apm_package_key_from_version_id $version_id]
    set files [apm_get_package_files -all_db_types -package_key $package_key]
    set tmpfile [ns_tmpnam]
    
    db_1row package_key_select {
                                select package_key 
                                  from apm_package_version_info 
                                 where version_id = :version_id
                               }

    # Generate a command like:
    #
    #   tar cf - -C /web/arsdigita/packages acs-kernel/00-proc-procs.tcl \
    #                 -C /web/arsdigita/packages 10-database-procs.tcl ...  \
    #     | gzip -c > $tmpfile
    #
    # Note that -C changes the working directory before compressing the next
    # file; we need this to ensure that the tarballs are relative to the
    # package root directory ([acs_root_dir]/packages).

    set cmd [list exec [apm_tar_cmd] cf -  2>/dev/null]
    foreach file $files {
	lappend cmd -C "[acs_root_dir]/packages"
	lappend cmd "$package_key/$file"
    }
    
    lappend cmd "|" [apm_gzip_cmd] -c ">" $tmpfile
    eval $cmd

    # At this point, the APM tarball is sitting in $tmpfile. Save it in 
    # the database.

    set creation_ip [ad_conn peeraddr]
    set user_id     [ad_conn user_id]
    set name        "tarball-for-package-version-${version_id}"
    set title       "${package_key}-tarball"

    set create_item "
                  begin
                   :1 := content_item.new(name        => :name,
                                          creation_ip => :creation_ip
                         );
                  end;"

    set create_revision "
                  begin
                   :1 := content_revision.new(title => :title,
                                              description => 'gzipped tarfile',
                                              text => 'not_important',
                                              mime_type => 'text/plain',
                                              item_id => :item_id,
                                              creation_user => :user_id,
                                              creation_ip => :creation_ip
                         );

                   update cr_items
                   set live_revision = :1
                   where item_id = :item_id;
                 end;"

    db_1row item_exists_p {select case when item_id is null 
                                    then 0 
                                    else item_id 
                                  end as item_id
                             from apm_package_versions 
                            where version_id = :version_id}

    if {!$item_id} {
        # content item hasen't been created yet - create one.        
        set item_id [db_exec_plsql create_item $create_item]
        db_dml set_item_id "update apm_package_versions 
                               set item_id = :item_id 
                             where version_id = :version_id"
        set revision_id [db_exec_plsql create_revision $create_revision]
        
    } else {
        #tarball exists, so all we have to do is to make a new revision for it
        #Let's check if a current revision exists:
        if {![db_0or1row get_revision_id "select live_revision as revision_id
              from cr_items
             where item_id = :item_id"] || $revision_id eq ""} {
            # It's an insert rather than an update            
            set revision_id [db_exec_plsql create_revision $create_revision]
        }
    }

    db_dml update_tarball {update cr_revisions
                              set content = empty_blob()
                            where revision_id = :revision_id
                        returning content into :1} -blob_files [list $tmpfile]

    db_dml update_content_length {
                update apm_package_versions
                   set content_length = (select dbms_lob.getlength(content)
                                           from cr_revisons
                                          where revision_id = :revision_id)
                 where version_id = :version_id
                }

    file delete $tmpfile
}


ad_proc -private apm_files_load {
    {-force_reload:boolean 0}
    {-callback apm_dummy_callback} 
    files
} {

    Load the set of files into the currently running Tcl interpreter.
    @param -force_reload Indicates if the file should be loaded even if it \
	    is already loaded in the interpreter.
} {
    # This will be the first time loading for each of these files (since if a
    # file has already been loaded, we just skip it in the loop below).
    global apm_first_time_loading_p
    set apm_first_time_loading_p 1

    global apm_current_package_key

    foreach file_info $files {
	util_unlist $file_info package_key path

	if { $force_reload_p || ![nsv_exists apm_library_mtime packages/$package_key/$path] } {
	    if { [file exists "[acs_root_dir]/packages/$package_key/$path"] } {
		apm_callback_and_log $callback "Loading packages/$package_key/$path..."
		set apm_current_package_key $package_key

		apm_source "[acs_root_dir]/packages/$package_key/$path"

		# Release outstanding database handles (in case this file
		# used the db_* database API and a subsequent one uses
		# ns_db).
		db_release_unused_handles

		apm_callback_and_log $callback "Loaded packages/$package_key/$path."
		unset apm_current_package_key
	    } else {
		apm_callback_and_log $callback "Unable to load packages/$package_key/$path - file is marked as contained in a package but is not present in the filesystem"		
	    }
	}
    }
    unset apm_first_time_loading_p
}

ad_proc -public apm_file_watch {path} {

    Marks the file of the indicated path to be watched.  If the file changes,
    it will be reloaded prior to the next page load.

    @param path The path of the file relative to server root
} {
    if {$path eq "packages/acs-bootstrap-installer/tcl/30-apm-load-procs.tcl"} {
        ns_log Warning "apm_file_watch: Skipping file $path as it cannot be watched. You have to restart the server instead"
    }

    nsv_set apm_reload_watch $path 1
}

ad_proc -public apm_file_watch_cancel {
    {path ""}
} {
    Stop watching a certain file, or all watched files if path
    is not specified. If the file is not watched
    this procedure does nothing.

    @param path The path relative to server root of the file to stop watching. Optional.

    @author Peter Marklund
} {
    if { $path ne "" } {
        catch { nsv_unset apm_reload_watch $path }
    } else {
        catch {nsv_unset apm_reload_watch}
    }
}

ad_proc -public apm_file_watchable_p { path } {
    Given the path of a file determine if it is
    appropriate to be watched for reload. The file should
    be db compatible with the system and be of right 
    type (for example contain tcl procs or xql queries).

    @param The path of the file relative to server root

    @return 1 If file is watchable and 0 otherwise. The proc will throw an error if the
              file doesn't exist or if the given path cannot be parsed as a path relative
              to server root.

    @see apm_guess_file_type
    @see apm_guess_db_type

    @author Peter Marklund
} {        
    # The apm_guess procs need package_key and a path relative to package root
    # so parse those out of the given path
    if { [regexp {^packages/([^/]+)/(.*)$} $path match package_key package_rel_path] } {
        if { ![file exists "[acs_root_dir]/$path"] } {
            error "apm_file_watchable_p: path $path does not correspond to an existing file"
        }
    } else {
        error "apm_file_watchable_p: path $path cannot be parsed as a path relative to server root"
    }

    # Check the db type
    set file_db_type [apm_guess_db_type $package_key $package_rel_path]
    set right_db_type_p [expr {$file_db_type eq ""} || \
                            [string equal $file_db_type [db_type]]]

    # Check the file type
    set file_type [apm_guess_file_type $package_key $package_rel_path]
    # I would like to add test_procs to the list but currently test_procs files are used to register test cases
    # and we don't want to resource these files in every interpreter. Test procs should be defined in test_init files.
    set watchable_file_types [list tcl_procs query_file test_procs]
    set right_file_type_p [expr {[lsearch -exact $watchable_file_types $file_type] != -1}]

    # Both db type and file type must be right
    set watchable_p [expr {$right_db_type_p && $right_file_type_p}]

    return $watchable_p
}

ad_proc -private apm_watch_all_files { package_key } {
    Watch all Tcl procs and xql query files in the given
    package

    @see apm_file_watch
    @see apm_get_watchable_files

    @author Peter Marklund
} {        
    foreach rel_path [apm_get_watchable_files $package_key] {
        apm_file_watch $rel_path
    }
}

ad_proc -private apm_cancel_all_watches { package_key } {
    Cancel all watches in the given package.

    @param package_key The package_key of the package to stop watching.

    @see apm_file_watch_cancel
    @see apm_get_watchable_files

    @author Peter Marklund
} {
    foreach rel_path [apm_get_watchable_files $package_key] {
        apm_file_watch_cancel $rel_path
    }
}

ad_proc -private apm_get_watchable_files { package_key } {
    Get a list of paths relative to server root of watchable
    files in the given package

    @param package_key Key of the package to get paths for

    @author Peter Marklund
} {
    set watchable_files [list]

    set files [ad_find_all_files [acs_root_dir]/packages/$package_key]
    foreach file [lsort $files] {
        set rel_path [ad_make_relative_path $file]
        if { [apm_file_watchable_p $rel_path] } {
            lappend watchable_files $rel_path
        }
    }

    return $watchable_files
} 

ad_proc -public pkg_home {package_key} {

    @return A server-root relative path to the directory for a package.  Usually /packages/package-key

} {
    return "/packages/$package_key"
}

ad_proc -private apm_system_paths {} {

    @return a list of acceptable system paths to search for executables in.

} {
    set paths [ad_parameter_all_values_as_list -package_id [ad_acs_kernel_id] SystemCommandPaths acs-kernel]
    if {$paths eq ""} {
	return [list "/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" "/usr/sbin"]
    } else {
	return $paths
    }
}

ad_proc -private apm_gunzip_cmd {} {

    @return A valid pointer to gunzip, 0 otherwise.
 
} {
    return gunzip
}

ad_proc -private apm_tar_cmd {} {

    @return A valid pointer to tar, 0 otherwise.
 
} {
    return tar
}


ad_proc -private apm_gzip_cmd {} {
    
    @return A valid pointer to gzip, 0 otherwise.

} {
    return gzip
}

ad_proc -private apm_load_apm_file {
    {-callback apm_dummy_callback}
    {-url {}}
    {file_path {}}
} {
    
    Uncompresses and loads an APM file into the filesystem.

    @param url If specified, will download the APM file first.

    @return If successful, a path to the .info file of the package uncompressed 
            into the apm-workspace directory

} {    
    # First download the apm file if a URL is provided
    if { $url ne "" } {
        apm_callback_and_log $callback "<li>Downloading $url..."
        if { [catch {
            # Open a destination file.
            set file_path [ns_tmpnam].apm
            set fileChan [open $file_path w 0640]
            # Open the channel to the server.
            set httpChan [lindex [ns_httpopen GET $url] 0]
            ns_log Debug "APM: Copying data from $url"
            fconfigure $httpChan -encoding binary
            fconfigure $fileChan -encoding binary
            # Copy the data
            fcopy $httpChan $fileChan
            # Clean up.
            ns_log Debug "APM: Done copying data."
            close $httpChan
            close $fileChan
        } errmsg] } {
            apm_callback_and_log $callback "Unable to download. Please check your URL.</ul>.
            The following error was returned: <blockquote><pre>[ad_quotehtml $errmsg]
            </pre></blockquote>[ad_footer]"
            return
        }	

        if {![file exists $file_path]} {
            apm_callback_and_log $callback  "
            The file cannot be found.  Your URL or your file name is incorrect.  Please verify that the file name
            is correct and try again."
            ns_log Error "Error loading APM file form url $url: The file cannot be found."
            return
        }
    }

    if { [catch {
	set files [split [string trim \
		[exec [apm_gunzip_cmd] -q -c $file_path | [apm_tar_cmd] tf - 2>/dev/null]] "\n"]
	apm_callback_and_log $callback  "<li>Done. Archive is [format "%.1f" [expr { [file size $file_path] / 1024.0 }]]KB, with [llength $files] files.<li>"
    } errmsg] } {
	apm_callback_and_log $callback "The follow error occured during the uncompression process:
	<blockquote><pre>[ad_quotehtml $errmsg]</pre></blockquote><br>
	"
        global errorInfo
        ns_log Error "Error loading APM file form url $url: $errmsg\n$errorInfo"
	return
    }
	
    if { [llength $files] == 0 } {
	apm_callback_and_log $callback  "The archive does not contain any files.\n"
        ns_log Error "Error loading APM file form url $url: The archive does not contain any files."
	return
    }

    set package_key [lindex [split [lindex $files 0] "/"] 0]

    # Find that .info file.
    foreach file $files {
	set components [split $file "/"]

	if {[lindex $components 0] ne $package_key  } {
	    apm_callback_and_log $callback  "All files in the archive must be contained in the same directory 
	    (corresponding to the package's key). This is not the case, so the archive is not 
	    a valid APM file.\n"
            ns_log Error "Error loading APM file form url $url: Invalid APM file. All files in the archive must be contained in the same directory corresponding to the package's key."
	    return
	}
    
	if { [llength $components] == 2 && [file extension $file] eq ".info" } {
	    if { [info exists info_file] } {
		apm_callback_and_log $callback  "The archive contains more than one <tt>package/*/*.info</tt> file, so it is not a valid APM file.</ul>\n"
                ns_log Error "Error loading APM file form url $url: Invalid APM file. More than one package .info file."
		return
	    } else {
	    set info_file $file
	    }
	}
    }
    if { ![info exists info_file] || [regexp {[^a-zA-Z0-9\-\./_]} $info_file] } {
        apm_callback_and_log $callback  "The archive does not contain a <tt>*/*.info</tt> file, so it is not 
        a valid APM file.</ul>\n"
        ns_log Error "Error loading APM file form url $url: Invalid APM file. No package .info file."
        return
    }

    apm_callback_and_log $callback  "Extracting the .info file (<tt>$info_file</tt>)..."
    set tmpdir [ns_tmpnam]
    file mkdir $tmpdir
    exec sh -c "cd $tmpdir ; [apm_gunzip_cmd] -q -c $file_path | [apm_tar_cmd] xf - $info_file" 2>/dev/null
    
    if { [catch {
	array set package [apm_read_package_info_file [file join $tmpdir $info_file]]
    } errmsg]} {
	file delete -force $tmpdir
	apm_callback_and_log $callback  "The archive contains an unparseable package specification file: 
	<code>$info_file</code>.  The following error was produced while trying to 
	parse it: <blockquote><pre>[ad_quotehtml $errmsg]</pre></blockquote>.
	<p>
	The package cannot be installed.
	</ul>\n"
        global errorInfo
        ns_log Error "Error loading APM file form url $url: Bad package .info file. $errmsg\n$errorInfo"
	return
    }
    file delete -force $tmpdir
    set package_key $package(package.key)
    set pretty_name $package(package-name)
    set version_name $package(name)
    ns_log Debug "APM: Preparing to load $pretty_name $version_name"
    # Determine if this package version is already installed.
    if {[apm_package_version_installed_p $package_key $version_name]} {	
	apm_callback_and_log $callback  "<li>$pretty_name $version_name is already installed in your system."
        ns_log Error "Error loading APM file form url $url: Package $pretty_name $version_name is already installed"
    } else {
	
	set install_path "[apm_workspace_install_dir]"
	
	if { ![file isdirectory $install_path] } {
	    file mkdir $install_path
	}
    
	apm_callback_and_log $callback  "<li>Extracting files into the filesytem."
	apm_callback_and_log $callback  "<li>$pretty_name $version_name ready for installation."

        # LARS: This looks odd -- package_key is not a directory
	# Remove the directory if it exists.
	#if {[file exists $package_key]} {
	#    file delete -force $package_key
	#}
        
	exec sh -c "cd $install_path ; [apm_gunzip_cmd] -q -c $file_path | [apm_tar_cmd] xf -" 2>/dev/null

        return "${install_path}/${package_key}/${package_key}.info"
    }
}
