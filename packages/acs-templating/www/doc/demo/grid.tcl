ad_page_contract {
  @cvs-id $Id: grid.tcl,v 1.2 2002-09-10 22:22:16 jeffd Exp $
} -properties {
  users:multirow
}


set query "select 
             first_name, last_name
           from
             ad_template_sample_users"


db_multirow users users_query $query



















