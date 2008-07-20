# Displays one policy in a html table format
# params policy_info array

set pretty_time_interval_after_resv_date [crs::resv_resrc::policy::util::format_interval_display $policy_info(time_interval_after_rsv_dte)]
set pretty_time_interval_before_start_date [crs::resv_resrc::policy::util::format_interval_display $policy_info(time_interval_before_start_dte)]
set pretty_resv_period_before_start_date [crs::resv_resrc::policy::util::format_interval_display $policy_info(resv_period_before_start_date)]




