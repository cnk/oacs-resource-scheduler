ad_library {
    ACS Automated testcases for the Personnel

    @author nick@ucla.edu
    @creation-date 2004/03/10
    @cvs-id $Id: test-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
}

aa_register_init_class aa_personnel_init {
    Make a new personnel
} {
    aa_export_vars [list aa_personnel_id aa_first_names aa_middle_name aa_last_name aa_preferred_first_name aa_preferred_middle_name aa_preferred_last_name aa_employee_number aa_gender aa_status_id aa_notes aa_bio aa_photo aa_languages aa_real_start_date aa_real_end_date aa_real_date_of_birth aa_group_id aa_title_id aa_leader_p aa_group_start_date aa_group_end_date aa_rel_id aa_email aa_password aa_user_id aa_years_practice aa_primary_care aa_accepting_patients_p aa_marketable_p aa_typical_patient aa_publication_title aa_publication_name aa_publication_url aa_publication_authors aa_publication_volume aa_publication_issue aa_publication_page_ranges aa_publication year aa_publication_publish_date aa_publication_publisher aa_publication_id aa_publication_year aa_new_user_email aa_new_user_first_names aa_new_user_middle_name aa_new_user_last_name aa_new_user_password aa_new_user_id]

    # info for personnel_add
    set aa_first_names "Joe"
    set aa_middle_name "Louis"
    set aa_last_name "Bruin"
    set aa_preferred_first_name "Josephine"
    set aa_preferred_middle_name "Lila"
    set aa_preferred_last_name "Bronco"

    set aa_employee_number 9871205427
    set aa_gender "m"
    set aa_status_id [db_string sc {select category.lookup('//Personnel Status') from dual}]
    set aa_notes "This is my notes"
    set aa_bio "This is my bio"
    set aa_photo ""
    set aa_languages ""
    set aa_real_start_date "2000-01-01"
    set aa_real_end_date "2002-02-02"
    set aa_real_date_of_birth "1964-11-30"

    set aa_personnel_id [personnel::personnel_add -first_names $aa_first_names \
	                  -middle_name $aa_middle_name \
			  -last_name $aa_last_name \
			  -preferred_first_name $aa_preferred_first_name \
			  -preferred_middle_name $aa_preferred_middle_name \
			  -preferred_last_name $aa_preferred_last_name \
			  -employee_number $aa_employee_number \
			  -gender $aa_gender \
			  -status_id $aa_status_id \
			  -notes $aa_notes \
			  -bio $aa_bio \
			  -photo $aa_photo \
			  -languages $aa_languages \
			  -real_start_date $aa_real_start_date \
			  -real_end_date $aa_real_end_date \
			  -real_date_of_birth $aa_real_date_of_birth]

    #info for personnel_to_user
    set aa_email "bruin@ucla.edu"
    set aa_password "bruin123"

    set aa_user_id [personnel::personnel_to_user -personnel_id $aa_personnel_id \
			-priv_email $aa_email \
			-first_names $aa_first_names \
			-last_name $aa_last_name \
			-password $aa_password]


    # info for physician_add
    set aa_years_practice 1
    set aa_primary_care "t"
    set aa_accepting_patients_p "f"
    set aa_marketable_p "t"
    set aa_typical_patient "I have no typical patients"

    personnel::physician_add -personnel_id $aa_personnel_id \
	 -years_of_practice $aa_years_practice \
	 -primary_care_physician_p $aa_primary_care \
	 -accepting_patients_p $aa_accepting_patients_p \
	 -marketable_p $aa_marketable_p \
	 -typical_patient $aa_typical_patient

    #info for publication_add
    set aa_publication_title "title"
    set aa_publication_name "name"
    set aa_publication_url "url"
    set aa_publication_authors "authors"
    set aa_publication_volume "volume"
    set aa_publication_issue "issue"
    set aa_publication_page_ranges "page ranges"
    set aa_publication_year 2
    set aa_publication_publish_date "2002-04-04"
    set aa_publication_publisher "Me"

    set aa_publication_id [publication::publication_add -title $aa_publication_title \
			       -publication_name $aa_publication_name \
			       -url $aa_publication_url \
			       -authors $aa_publication_authors \
			       -volume $aa_publication_volume \
			       -issue $aa_publication_issue \
			       -page_ranges $aa_publication_page_ranges \
			       -year $aa_publication_year \
			       -publisher $aa_publication_publisher \
			       -publish_date $aa_publication_publish_date \
			       -personnel_id $aa_personnel_id]

    # info for publication_personnel_map
    set aa_pubmap_id 7027
    publication::publication_personnel_map -publication $aa_pubmap_id \
	-personnel_id $aa_personnel_id


    #info for user_add and user_to_personnel
    set aa_new_user_email "new.user@ucla.edu"
    set aa_new_user_first_names "New"
    set aa_new_user_middle_name "Middle New"
    set aa_new_user_last_name "User"
    set aa_new_user_password "user123"

    set aa_new_user_id [personnel::user_add -priv_email $aa_new_user_email \
			    -first_names $aa_new_user_first_names \

			    -last_name $aa_new_user_last_name \
			    -password $aa_new_user_password]

    #info for faculty_add
    personnel::faculty_add -faculty_id $aa_personnel_id

} {
    personnel::personnel_delete -personnel_id $aa_personnel_id
    personnel::personnel_delete -personnel_id $aa_new_user_id
    publication::publication_delete -publication_id $aa_publication_id
}

aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "personnel_edit-test-01" {
    test the personnel_edit
} {

    set edit_notes "Something different"

    personnel::personnel_edit -personnel_id $aa_personnel_id \
	-first_names $aa_first_names \
	-middle_name $aa_middle_name \
	-last_name $aa_last_name \
	-preferred_first_name $aa_preferred_first_name \
	-preferred_middle_name $aa_preferred_middle_name \
	-preferred_last_name $aa_preferred_last_name \
	-employee_number $aa_employee_number \
	-gender $aa_gender \
	-status_id $aa_status_id \
	-notes $edit_notes \
	-bio $aa_bio \
	-photo $aa_photo \
	-languages $aa_languages \
	-real_start_date $aa_real_start_date \
	-real_end_date $aa_real_end_date \
	-real_date_of_birth $aa_real_date_of_birth

    #get the newly created entry in the personnel table
    db_1row get_personnel_info "select per.first_names, per.middle_name, per.last_name, ip.personnel_id, ip.preferred_first_name, ip.preferred_middle_name, ip.preferred_last_name, ip.employee_number, ip.gender, ip.date_of_birth, ip.status_id, ip.start_date, ip.end_date, ip.notes from persons per, inst_personnel ip where ip.personnel_id=:aa_personnel_id and per.person_id = ip.personnel_id"

    aa_equals "first name equals"  $first_names $aa_first_names
    aa_equals "middle name equals" $middle_name $aa_middle_name
    aa_equals "last name equals"  $last_name $aa_last_name

    aa_equals "preferred first name equals"  $preferred_first_name $aa_preferred_first_name
    aa_equals "preferred middle name equals" $middle_name $aa_preferred_middle_name
    aa_equals "preferred last name equals"  $last_name $aa_preferred_last_name
    aa_equals "employee number equals"  $employee_number $aa_employee_number
    aa_equals "gender equals"  $gender $aa_gender
    aa_equals "date of birth equals"  $date_of_birth $aa_real_date_of_birth
    aa_equals "start date equals"  $start_date $aa_real_start_date
    aa_equals "end date equals"  $end_date $aa_real_end_date
    aa_equals "notes equals"  $notes $edit_notes

}

aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "personnel_group_add-test-02" {
    test the personnel_group_add
} {

    #get the newly created entry in the personnel table
    db_1row get_personnel_group_info "select igpm.acs_rel_id, igpm.title_id, igpm.leader_p, igpm.start_date, igpm.end_date from inst_group_personnel_map igpm, acs_rels ar where ar.object_id_two = :aa_personnel_id and ar.object_id_one = :aa_group_id and ar.rel_id = igpm.acs_rel_id"

    aa_equals "acs rel id equals" $acs_rel_id $aa_rel_id
    aa_equals "title id equals"  $title_id $aa_title_id
    aa_equals "leader_p equals"  $leader_p $aa_leader_p
    aa_equals "group start date equals"  $start_date $aa_group_start_date
    aa_equals "group end date equals"  $end_date $aa_group_end_date
}

aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "personnel_to_user-test-03" {
    test the personnel_to_user
} {

    #get the newly created entry in the personnel table
    db_1row get_personnel_group_info {
	select per.first_names, per.middle_name, per.last_name, u.user_id, parties.email, u.password_question, u.password_answer
	from users u, parties, persons per
	where user_id = party_id and user_id = person_id and user_id = :aa_personnel_id
    }

    aa_equals "first name equals"  $first_names $aa_first_names
    aa_equals "middle name equals"  $middle_name $aa_first_names
    aa_equals "last name equals"  $last_name $aa_last_name
    aa_equals "user id equals" $user_id $aa_user_id
    aa_equals "email equals"  $email $aa_email
}


aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "physician_add-test-04" {
    test the physician_add
} {

    #get the newly created entry in the personnel table
    db_1row get_physician_info {
	select primary_care_physician_p, years_of_practice, accepting_patients_p, marketable_p, typical_patient
	from inst_physicians
	where physician_id = :aa_personnel_id
    }

    aa_equals "years of practice equals"  $years_of_practice $aa_years_practice
    aa_equals "primary care equals"  $primary_care_physician_p $aa_primary_care
    aa_equals "accepting patients equals" $accepting_patients_p $aa_accepting_patients_p
    aa_equals "marketable_p equals"  $marketable_p $aa_marketable_p
    aa_equals "typical patient equals"  $typical_patient $aa_typical_patient
}

aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "physician_edit-test-05" {
    test the physician_edit
} {

    set new_years_practice 5
    set new_patient "Only nonsick ones"

    personnel::physician_edit -personnel_id $aa_personnel_id \
	-years_of_practice $new_years_practice \
	-primary_care_physician_p $aa_primary_care \
	-accepting_patients_p $aa_accepting_patients_p \
	-marketable_p $aa_marketable_p \
	-typical_patient $new_patient

    #get the newly created entry in the personnel table
    db_1row get_physician_info {
	select primary_care_physician_p, years_of_practice, accepting_patients_p, marketable_p, typical_patient
	from inst_physicians
	where physician_id = :aa_personnel_id
    }

    aa_equals "years of practice equals"  $years_of_practice $new_years_practice
    aa_equals "primary care equals"  $primary_care_physician_p $aa_primary_care
    aa_equals "accepting patients equals" $accepting_patients_p $aa_accepting_patients_p
    aa_equals "marketable_p equals"  $marketable_p $aa_marketable_p
    aa_equals "typical patient equals"  $typical_patient $new_patient
}


aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "publication_add-test-06" {
    test the publication_add
} {

    #get the newly created entry in the personnel table
    db_1row get_publication_info {
	select publication_id, title, publication_name, url, authors, volume, issue, page_ranges, year, publish_date, publisher
	from inst_publications
	where publication_id = :aa_publication_id
    }

    aa_equals "title equals"  $title $aa_publication_title
    aa_equals "publication name equals"  $publication_name $aa_publication_name
    aa_equals "url equals" $url $aa_publication_url
    aa_equals "authors equals"  $authors $aa_publication_authors
    aa_equals "volume equals"  $volume $aa_publication_volume
    aa_equals "issue equals"  $issue $aa_publication_issue
    aa_equals "page ranges equals"  $page_ranges $aa_publication_page_ranges
    aa_equals "year equals"  $year $aa_publication_year
    aa_equals "publish_date equals"  $publish_date $aa_publication_publish_date
    aa_equals "publisher equals"  $publisher $aa_publication_publisher
}


aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "publication_edit-test-07" {
    test the publication_edit
} {

    set new_title "new title"
    set new_publish_date "1997-11-28"
    publication::publication_edit -publication_id $aa_publication_id \
	-title $new_title \
	-publication_name $aa_publication_name \
	-url $aa_publication_url \
	-authors $aa_publication_authors \
	-volume $aa_publication_volume \
	-issue $aa_publication_issue \
	-page_ranges $aa_publication_page_ranges \
	-year $aa_publication_year \
	-publisher $aa_publication_publisher \
	-publish_date $new_publish_date


    #get the newly created entry in the personnel table
    db_1row get_publication_info {
	select publication_id, title, publication_name, url, authors, volume, issue, page_ranges, year, publish_date, publisher
	from inst_publications
	where publication_id = :aa_publication_id
    }

    aa_equals "title equals"  $title $new_title
    aa_equals "publication name equals"  $publication_name $aa_publication_name
    aa_equals "url equals" $url $aa_publication_url
    aa_equals "authors equals"  $authors $aa_publication_authors
    aa_equals "volume equals"  $volume $aa_publication_volume
    aa_equals "issue equals"  $issue $aa_publication_issue
    aa_equals "page ranges equals"  $page_ranges $aa_publication_page_ranges
    aa_equals "year equals"  $year $aa_publication_year
    aa_equals "publish_date equals"  $publish_date $new_publish_date
    aa_equals "publisher equals"  $publisher $aa_publication_publisher
}



aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "publication_personnel_map-test-08" {
    test the publication_personnel_map
} {

    #get the newly created entry in the personnel table
    db_1row get_publication_map_info {
	select publication_id, personnel_id
	from inst_personnel_publication_map
	where publication_id = :aa_publication_id
    }

    aa_equals "personnel id equals"  $personnel_id $aa_personnel_id
}


aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "user_to_personnel-test-09" {
    test the user_to_personnel
} {

    set temp_employee_number 4444
    set temp_gender "m"
    set temp_status_id  [db_string sc {select category.lookup('//Personnel Status') from dual}]
    set temp_notes "This is my notes"
    set temp_bio "This is my bio"
    set temp_photo ""
    set temp_languages ""
    set temp_real_start_date "2000-01-01"
    set temp_real_end_date "2002-02-02"
    set temp_real_date_of_birth "1964-11-30"

    personnel::user_to_personnel -personnel_id $aa_new_user_id \
	-first_names $aa_new_user_first_names \
	-middle_name $aa_new_user_middle_name \
	-last_name $aa_new_user_last_name \
	-employee_number $temp_employee_number \
	-gender $temp_gender \
	-status_id $temp_status_id \
	-notes $temp_notes \
	-bio $temp_bio \
	-photo $temp_photo \
	-languages $temp_languages \
	-real_date_of_birth $temp_real_date_of_birth \
	-real_start_date $temp_real_start_date \
	-real_end_date $temp_real_end_date

    #get the newly created entry in the personnel table
    db_1row get_personnel_info "select per.first_names, per.middle_name, per.last_name, ip.personnel_id, ip.employee_number, ip.gender, ip.date_of_birth, ip.status_id, ip.start_date, ip.end_date, ip.notes from persons per, inst_personnel ip where ip.personnel_id=:aa_new_user_id and per.person_id = ip.personnel_id"

    aa_equals "first name equals"  $first_names $aa_new_user_first_names
    aa_equals "middle name equals" $middle_name $aa_new_user_middle_name
    aa_equals "last name equals"  $last_name $aa_new_user_last_name
    aa_equals "employee number equals"  $employee_number $temp_employee_number
    aa_equals "gender equals"  $gender $temp_gender
    aa_equals "date of birth equals"  $date_of_birth $temp_real_date_of_birth
    aa_equals "start date equals"  $start_date $temp_real_start_date
    aa_equals "end date equals"  $end_date $temp_real_end_date
    aa_equals "notes equals"  $notes $temp_notes
}


aa_register_case -cats {
    db
    script
} -init_classes {
    aa_personnel_init
} "faculty_add-test-10" {
    test the faculty_add
} {

    #get the newly created entry in the personnel table
    db_1row get_faculty_info "select faculty_id from inst_faculty where faculty_id = :aa_personnel_id"

    aa_equals "faculty_id equals"  $faculty_id $aa_personnel_id
}
