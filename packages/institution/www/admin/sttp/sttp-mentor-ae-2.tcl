ad_page_contract {
    Mentor add and edit

    @author reye@mednet.ucla.edu
    @creation-date 2004-10-22
    @cvs-id $Id

} {
    {description: ""}
    {n_grads_currently_employed: ""}
    {last_md_candidate: ""}
    {last_md_year: ""}
    {experience_required_p: ""}
    {skill: ""}
    {skill_required_p: ""}
    {n_requested: ""}
    {n_received: ""}
    {attend_poster_session_p: ""}
    {position: ""}
}



if {[string equal $experience_required_p "t"]} {
    set experience_required_p "Yes"
} else {
    set experience_required_p "No"
}

if {[string equal $skill_required_p "t"]} {
    set skill_required_p "Yes"
} else {
    set skill_required_p "No"
}

if {[string equal $attend_poster_session_p "t"]} {
    set attend_poster_session_p "Yes"
} else {
    set attend_poster_session_p "No"
}

if {[string equal $position "t"]} {
    set position "Yes"
} else {
    set position "No"
}

ad_form -name "mentor_info4" -method (post) -form {
    {description:text(inform) {label "One-sentence description of your project:"} {html {rows 5 cols 50}} {value $description}}
    {n_grads_currently_employed:text(inform) {label "Number of graduate students currently in your lab:"} {value $n_grads_currently_employed}}
    {last_md_candidate:text(inform) {label "Name of the most recent medical student who has worked with you:"} {value $last_md_candidate}}
    {last_md_year:text(inform) {label "Year worked (if applicable):"} {value $last_md_year}}
    {experience_required_p:text(inform) {label "Is previous research experience required?"} {value $experience_required_p}}
    {skill:text(inform) {label "Particular Skills preferred in applicants:"} {value $skill}}
    {skill_required_p:text(inform) {label "Are these Skills mandatory?"} {value $skill_required_p}}
    {n_requested:text(inform) {label "Number of positions available:"} {value $n_requested}}
    {n_received:text(inform) {label "Number of positions filled:"} {value $n_received}}
    {attend_poster_session_p:text(inform) {label "Are you or your designate able to attend the STTP Student Poster Session on Thursday, August 26, 2004 1-4 p.m.?"} {value $attend_poster_session_p}}
    {position:text(inform) {label "Is this position still open?"} {value $position}}
} -action {sttp-mentor-ae-5}
