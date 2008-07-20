ad_page_contract {
  @author Guenter Ernst guenter.ernst@wu-wien.ac.at, 
  @author Gustaf Neumann neumann@wu-wien.ac.at
  @creation-date 13.07.2004
  @cvs-id $Id: insert-image.tcl,v 1.2 2006-06-04 00:45:54 donb Exp $
} {
  {fs_package_id:integer,optional}
  {folder_id:integer,optional}
}
 
set selector_type "image"
set file_selector_link [export_vars -base file-selector \
			    {fs_package_id folder_id selector_type}]
set fs_found 1
