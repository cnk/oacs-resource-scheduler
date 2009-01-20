# /packages/ctrl-events/tcl/event-procs.tcl					-*- tab-width: 4 -*-
ad_library {

	Procedures to insert, delete, and manage CTRL Events
	
	@author			kellie@ctrl.ucla.edu (KL)
	@creation-date	05/04/05
	@cvs-id $Id: ce-procs.tcl,v 1.1 2006/08/02 22:50:02 avni Exp $
}

namespace eval ctrl_event {}

ad_proc -public ctrl_event::exists_p {
	{-event_id:required}
} {
	Returns 1 if event_id passed in exists in db
	Returns 0 if event_id passed in doesn't exist in db
} {
	return [db_string exists_p {}]
}


ad_proc -public ctrl_event::get {
	{-array:required}
	{-event_id:required}
	{-date_format "'YYYY-MM-DD'"}
} {
	Select something from the database
	
	@param array
	@param event_id
} {
	upvar $array local_array
	set selection [db_0or1row get {} -column_array local_array]
	
	if {!$selection} {
		return 0
	} else {
		return 1
	}
}

ad_proc -public ctrl_event::event_image_display {
	{-event_id:required}
} {
	Return the image, if any
} {
	set package_url [site_node_closest_ancestor_package_url -package_key ctrl-events -default "/events/"]
	
	#set selection [db_0or1row event_image_display {}]
	ctrl_event::get -event_id $event_id -array event_info
	set image_item_id $event_info(image_item_id)
	if {![empty_string_p $image_item_id]} {
		set event_image ""
		set revision_exists_p [content::item::get -item_id $image_item_id -array_name "image_info"]
		if {$revision_exists_p} {
			set width $image_info(width)
			set height $image_info(height)
			if {![empty_string_p $height] && ![empty_string_p $width]} {
 				append event_image "<img width=\"$width\" height=\"$height\" src=\"/image/$image_item_id\" border=\"0\">"
			} else {
 				append event_image "<img src=\"/image/$image_item_id\" border=\"0\">"
			}				
			return $event_image
		}
	}

	return ""
}

ad_proc -public ctrl_event::new {
	{-event_id:required}
	{-event_object_id:required}
	{-repeat_template_id ""}
	{-repeat_template_p "f"}
	{-title:required}
	{-speakers ""}
	{-start_date:required}
	{-end_date:required}
	{-all_day_p "f"}
	{-location:required}
	{-notes:required}
	{-capacity:required}
	{-event_image ""}
	{-event_image_caption ""}
	{-category_id:required}
	{-context_id ""}
	{-package_id ""}
} {
	Creates a new event object

	@param event_id
	@param event_object_id
	@param repeat_template_id
	@param repeat_template_p
	@param title
	@param speakers optional
	@param start_date
	@param end_date
	@param all_day_p
	@param location
	@param notes
	@param capacity
	@param event_image
	@param event_image_caption
	@param category_id
} {
	set error_p 0
	db_transaction {
		if {[empty_string_p $context_id]} {
			set context_id [ad_conn package_id]
		} 

		if {[empty_string_p $package_id]} {
			set package_id [ad_conn package_id]
		}

 		set event_id [db_exec_plsql add {}]
		# db_dml notes {} -clobs [list $notes]

		if {![empty_string_p $event_image]} {
			set item_id [ctrl_event_image::new -event_id $event_id -event_image $event_image -event_image_caption $event_image_caption]
			db_dml update_item_id {}
		}

	} on_error {
		set error_p 1
	}

	if {$error_p} {
		error $errmsg
	}
	return $event_id
}

ad_proc -public ctrl_event::update {
	{-event_id:required}
	{-event_object_id:required}
	{-repeat_template_p "f"}
	{-title:required}
	{-speakers ""}
	{-start_date:required}
	{-end_date:required}
	{-all_day_p "f"}
	{-location:required}
	{-notes:required}
	{-capacity:required}
	{-event_image ""}
	{-event_image_caption ""}
	{-category_id:required}
} {
	Update a row in the ctrl_events table

	@param event_id
	@param event_object_id
	@param repeat_template_p
	@param title
	@param speakers
	@param start_date
	@param end_date
	@param all_day_p
	@param location
	@param notes
	@param capacity
	@param event_image
	@param event_image_caption
	@param category_id
} {
	set error_p 0
	if {[empty_string_p $repeat_template_p]}	{set repeat_template_p "f"}
	if {[empty_string_p $all_day_p]}			{set all_day_p "f"}

	db_transaction {
		ctrl_procs::acs_object::update_object -object_id $event_id
		db_dml update {}
		#db_dml notes {} -clobs [list $notes]

		if {![empty_string_p $event_image]} {
			#ctrl_event_image::image -event_id $event_id -event_image $event_image
			ctrl_event::get -event_id $event_id -array event_info
			set image_item_id $event_info(image_item_id)
			if {[empty_string_p $image_item_id]} {
				set item_id [ctrl_event_image::new -event_id $event_id -event_image $event_image -event_image_caption $event_image_caption]				
				db_dml update_item_id {}
			} else {
				ctrl_event_image::update -image_item_id $image_item_id -event_image $event_image -event_image_caption $event_image_caption
			}
		}
		
	} on_error {
		set error_p 1
	}

	if {$error_p} {
		error $errmsg
	}
}

ad_proc -public ctrl_event::delete {
	{-event_id:required}
} {
	Remove an acs_object by calling the associated pl/sql function

	@param event_id
} {
	set error_p 0
	db_transaction {
		db_exec_plsql remove {}
	} on_error {
		set error_p 1
		db_abort_transaction
	}

	if {$error_p} {
		error $errmsg
	}
}


ad_proc -public ctrl_event::delete_recurrences {
	{-repeat_template_id:required}
	{-delete_date:required}
} {
	Remove all repeating recurrences

	@repeat_template_id
	@delete_date
} {
	set error_p 0

	db_transaction {
		db_exec_plsql remove_recurrences {}
	} on_error {
		set error_p 1
	}

	if {$error_p} {
		error $errmsg
	}
}

ad_proc -public ctrl_event::update_recurrences {
	{-event_id:required}
	{-event_object_id:required}
	{-repeat_template_p "f"}
	{-title:required}
	{-speakers ""}
	{-start_date:required}
	{-end_date:required}
	{-all_day_p "f"}
	{-location:required}
	{-notes:required}
	{-capacity:required}
	{-event_image ""}
	{-event_image_caption ""}
	{-category_id:required}
	{-repeat_template_id:required}
} {
	Update all repeating recurrences by deleting and adding new ones based on repeating template pattern

	@param event_id
	@param event_object_id
	@param repeat_template_p
	@param title
	@param speakers 
	@param start_date
	@param end_date
	@param all_day_p
	@param location
	@param notes
	@param capacity
	@param event_image
	@param event_image_caption
	@param category_id
	@param repeat_template_id
} {
	set error_p 0

	set delete_date [db_string get_update_date {}]

	db_transaction {
		ctrl_event::delete_recurrences -repeat_template_id $repeat_template_id -delete_date $delete_date

		#get repeating pattern
		ctrl_event::repetition::get -repeat_template_id $repeat_template_id -array "repeat_template_info"

		#set repeating options
		set repeat_month_opt [ctrl_event::repetition::get_month_opt -specific_day_frequency $repeat_template_info(specific_day_frequency) \
								  -specific_days $repeat_template_info(specific_days) \
								  -specific_dates_of_month $repeat_template_info(specific_dates_of_month) \
								  -specific_months $repeat_template_info(specific_months)]
		set repeat_month_opt1 0
		set repeat_month_opt2 0

		if {$repeat_month_opt == "1"} {
			set repeat_month_opt1 1
		} elseif {$repeat_month_opt == "2"} {
			set repeat_month_opt2 1
		}

		set repeat_end_date_opt 1
		regsub -all {\-} $repeat_template_info(end_date) " " repeat_template_info(end_date)
		#add all future repeating_events
		ctrl_event::repetition::repeat -event_id $repeat_template_id \
			-frequency_type $repeat_template_info(frequency_type) \
			-repeat_end_date_opt $repeat_end_date_opt \
			-frequency_day $repeat_template_info(frequency) \
			-frequency_week $repeat_template_info(frequency) \
			-specific_days_week $repeat_template_info(specific_days) \
			-frequency_month $repeat_template_info(frequency) \
			-frequency_year $repeat_template_info(frequency) \
			-specific_day_frequency $repeat_template_info(specific_day_frequency) \
			-specific_days_week $repeat_template_info(specific_days) \
			-specific_months $repeat_template_info(specific_months) \
			-specific_days_month $repeat_template_info(specific_days) \
			-specific_dates_of_month_month $repeat_template_info(specific_dates_of_month) \
			-specific_dates_of_month_year $repeat_template_info(specific_dates_of_month) \
			-repeat_month_opt1 $repeat_month_opt1 -repeat_month_opt2 $repeat_month_opt2 \
			-repeat_end_date "to_date('$repeat_template_info(end_date)', 'YYYY MM DD')" \
			-event_object_id $event_object_id -title $title -speakers $speakers \
			-start_date $start_date -end_date $end_date -all_day_p $all_day_p \
			-location $location -notes $notes -capacity $capacity \
			-event_image $event_image -event_image_caption $event_image_caption -category_id $category_id \
			-context_id [ad_conn package_id] -package_id [ad_conn package_id] -add_event_p "t"
	} on_error {
		set error_p 1
	}

	if {$error_p} {
		error $errmsg
	}
}


##############################################################
ad_proc -public ctrl_event::get_approved_events_by_day {
    {-object_id_list:required}
    {-current_date ""}
} {
    get the timespan of objects in the object_id_lists in a month view
    only the approved events are counted
} {
    if {[empty_string_p $current_date]} {
        set current_date [dt_sysdate]
    }

    set result_list [db_list_of_lists get_events {}]
    return $result_list
}

ad_proc -public ctrl_event::update_event_status {
	{-event_id:required}
	{-status:required}
} {
	Update Event Status

	@param event_id
	@param status
} {
	set error_p 0
	db_transaction {
		db_dml update_status {}
	} on_error {
		set error_p 1
	}

	if {$error_p} {
		error $errmsg
	}
}
