# /packages/institutions/www/admin/sttp/detail.tcl

ad_page_contract {
    Detail Mentor

    @author reye@mednet.ucla.edu
    @creation-date 2004-10-22
    @cvs-id $Id

} {
    {request_id:naturalnum,optional}
    {personnel_id:naturalnum,optional}
}

set subsite_id [ad_conn subsite_id]
set object_type "inst_short_term_trnng_prog"
set user_id     [ad_conn user_id]
set peer_ip     [ad_conn peeraddr]
set package_id  [ad_conn package_id]

set research_experience [list [list Yes "t"] [list No "No"]]
set skills_mandatory [list [list Yes "t"] [list No "f"]]
set available_options [list [list Yes "t"] [list No "f"]]
set judge_options [list [list Yes "t"] [list No "f"]]
set position_options [list [list Yes "t"] [list No "f"]]

db_multirow sttp_email sttp_email {}
db_multirow sttp_phone sttp_phone {}
db_multirow sttp_address sttp_address {}
db_multirow sttp_selection sttp_selection {}

## Action links for admin ####
set sttp_delete "sttp-delete"
set sttp_edit "sttp-mentor-ae"
