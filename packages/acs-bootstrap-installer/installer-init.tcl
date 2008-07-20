#      Initializes datastrctures for the installer.

#      @creation-date 02 October 2000
#      @author Bryan Quinn
#      @cvs-id $Id: installer-init.tcl,v 1.2 2002-09-10 22:22:05 jeffd Exp $


# Create a mutex for the installer
nsv_set acs_installer mutex [ns_mutex create]
