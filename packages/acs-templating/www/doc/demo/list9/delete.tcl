# packages/notes/www/delete.tcl

ad_page_contract {

  @author rhs@mit.edu
  @creation-date 2000-10-23
  @cvs-id $Id: delete.tcl,v 1.1 2006-02-13 13:11:12 jiml Exp $
} {
  template_demo_note_id:integer,notnull,multiple
}

foreach template_demo_note_id $template_demo_note_id {
    ad_require_permission $template_demo_note_id delete

    package_exec_plsql \
	-var_list [list [list template_demo_note_id $template_demo_note_id]] \
	template_demo_note \
	del
}

# We've successfully processed the submission.
# Clear the pagination cache.

cache flush notes*

ad_returnredirect "./"
