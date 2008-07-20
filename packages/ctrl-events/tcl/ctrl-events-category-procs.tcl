# /packages/ctrl-events/tcl/ctrl-events-category-procs.tcl
ad_library {

        Procedures to associate and disassociate categories to events

        @author  shhong@mednet.ucla.edu (SH)
        @creation-date  02/24/06
        @cvs-id $Id: 
}

namespace eval ctrl_event::event_category {}

ad_proc -public ctrl_event::event_category::associate {
                {-event_id:required}
                {-category_id:required}
} {
	Procedure to associate a category to an event
} {
   set error_p 0
   db_transaction {
      if {![db_0or1row check {}]} {
         db_dml category {}
      }
   } on_error {
                set error_p 1
   }
   if {$error_p} {
      ad_return_error "Error associating a category to an event" "<p>An unexpected error occurred while associating a category to an event:</p><p>$errmsg</p>"
      ad_script_abort
   }
}

ad_proc -public ctrl_event::event_category::disassociate {
                {-event_id:required}
                {-category_id:required}
} {
        Procedure to disassociate a category to an event
} {  
   set error_p 0
   db_transaction {     
      if {[db_0or1row check {}]} {
         db_dml category {}
      }
   } on_error {
                set error_p 1
   }
   if {$error_p} {
      ad_return_error "Error disassociating a category to an event" "<p>An unexpected error occurred while disassociating a category to an event:</p><p>$errmsg</p>"
      ad_script_abort
   }
}

ad_proc -public ctrl_event::event_category::current {
                {-event_id:required}
} {
   set result ""
   db_foreach category_ids {} {
      lappend result $category_id
   }
   return $result
}

ad_proc -public ctrl_event::event_category::category_csv {
                {-event_id:required}
} {
   set result ""
   db_foreach names {} {
      if {![empty_string_p $result]} {append result ","}
      lappend result $name
   }
   return $result
}

ad_proc -public ctrl_event::event_category::update {
      		{-event_id:required}
      		{-category_widget ""}
} {
	Procedure to update the event category
} {
   set error_p 0
   db_transaction {
      set cur_category_list [ctrl_event::event_category::current -event_id $event_id]
      if {[llength $category_widget] > 0 } {
          foreach cur_category_id $cur_category_list {
             if {[lsearch -glob $category_widget $cur_category_id] == -1} {
                ctrl_event::event_category::disassociate -event_id $event_id -category_id $cur_category_id
             }
          } 
          foreach new_category_id $category_widget {
             if {[lsearch -glob $cur_category_list $new_category_id] == -1} {
                ctrl_event::event_category::associate -event_id $event_id -category_id $new_category_id
             } 
          }
      } else {
          foreach cur_category_id $cur_category_list {
              ctrl_event::event_category::disassociate -event_id $event_id -category_id $cur_category_id
          }    
      }
   } on_error {
       set error_p 1
   }
   if {$error_p} {
      ad_return_error "Error updating the event category" "<p>An unexpected error occurred while updating the event category:</p><p>$errmsg</p>"
      ad_script_abort
   }
}
