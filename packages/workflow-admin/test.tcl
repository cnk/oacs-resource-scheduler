#imp::ptracker::register_state_capture_code_impl
#imp::ptracker::register_log_transition_impl

imp::ptracker::check_for_follow_up

#set case_id 26
#set action_id 4298
#workflow::case::action::execute -case_id $case_id -action_id $action_id -no_perm_check

#set workflow_id 1568
#set states_to_highlight 92
#set subject_id 1732
#db_dml graph_filename_update_true ""
##set flag [workflow::graph::draw -workflow_id $workflow_id -highlight $states_to_highlight -subject_id $subject_id]

doc_return 200 text/html "<html>
test 
</html>"
