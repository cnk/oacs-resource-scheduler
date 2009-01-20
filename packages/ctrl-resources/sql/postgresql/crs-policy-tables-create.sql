/* -----------------------------------------------------------------------------
* @Author KH
* @cvs-id $Id$
*
* We need to maintain certain policy information to a room 
* such as when is the last date to update a reservation.
* These policies only affective non-admin individuals
* The following changes are needed for room policies
*      - reserve up to a particular date (the furtherest future date that 
*        reservations are allowed)
*      - time period to cancel/modify a reservation after a reservation is made
*      - time period to cancel/modify a reservation prior to the start date
*      - how many days/hours a room must be reserved ahead  
* ------------------------------------------------------------------------------ */

create sequence crs_resv_policy_seq;


/* -----------------------------------------------------------------------------
* This table stores the available policies per resource
* There is a prioriy level is used to support precedent
* in cases where multiple policies may apply for a room.
* ------------------------------------------------------------------------------*/
create table crs_resv_resource_policies (
    policy_id                        	integer
        				constraint crs_rsv_rsr_pol_policy_id_pk primary key,
    resource_id                      	integer 
        				constraint crs_rsv_rsr_pol_resource_id_nn not null
        				constraint crs_rsv_rsr_pol_resource_id_fk references crs_reservable_resources(resource_id) on delete cascade, 
    policy_name                      	varchar(50) default 'Default'
       	 				constraint crs_rsv_rsr_pol_policy_nam_nn not null,
    latest_resv_date              	timestamptz,
    -- time interval to cancel/modify a reservation after it is made (default is 24 hours) 
    time_interval_after_rsv_dte        	integer default 86400,
    -- time period to cancel/modify a reservation before the start date
    time_interval_before_start_dte 	integer default 0,
    -- reservation start date must be a head by 
    resv_period_before_start_date     	integer ,
    priority_level                  	integer default 0,
    creation_date                   	date default sysdate,
    creation_user                      	integer 
        constraint crs_resv_rsr_pol_cr_by_fk references users(user_id),
    last_modified                   	timestamptz default current_timestamp,
    modifying_user                      integer 
        constraint crs_resv_rsr_pol_update_by_fk references users(user_id),
    all_day_period_start		timestamptz,
    all_day_period_end			timestamptz,
    constraint crs_rsv_rsr_pol_res_policy_un unique (resource_id, policy_name)
);

COMMENT on table crs_resv_resource_policies is 'Table stores the available 
policies for a resource.';


/** ---------------------------------------------------------------------------------
* This table stores the mapping of groups to policies.  If
* a user is a member of the group then the policy is effective for them
*
* These policies are not in effect for those with 'admin' privilege.
* If user is not member of any group in this mapping then the 'General' Policy is
* enforced for the reservation.  
* ------------------------------------------------------------------------------------*/
create table crs_resv_resource_pol_assns (
    policy_id                      integer 
        constraint crs_rsv_rsr_pass_policy_id_fk references crs_resv_resource_policies(policy_id),
    group_id                       integer
        constraint crs_rsv_rsr_pass_group_id_fk references groups(group_id),
    creation_date                  timestamptz default current_timestamp,
    creation_user                  integer 
        constraint crs_rsv_rsv_pass_cr_user_nn not null,
    constraint crs_rsv_rsr_pass_pol_grp_id_pk primary key (group_id, policy_id)
);

alter table crs_requests add (
    -- notify the registrant if changes ocurred 
    notify_if_updates                           boolean default 'f',
    -- last date to modify after reservation 
    last_date_to_mod_after_res                 	timestamptz ,
    last_date_to_mod_before_start               timestamptz ,
    -- comment as to why the status change
    last_change_comment                         varchar(1000),
    --- The policy that was used for this reservation
    policy_id                                   integer 
        constraint crs_requests_policy_id_fk references crs_resv_resource_policies(policy_id),
    package_id					integer
);


create table crs_request_change_comments (
    change_id                                      integer 
         constraint crs_req_chg_comm_ch_id_pk      primary key,
    event                                          varchar(100)
         constraint crs_req_chg_comm_event_nn      not null,
    request_id                                     integer
         constraint crs_req_chg_comm_req_id_fk     references crs_requests(request_id)
         constraint crs_req_chg_comm_req_id_nn     not null,
    comment_text                                   varchar(2000),
    prev_status                                    varchar(100),
    new_status                                     varchar(100),
    creation_user                                  integer 
         constraint crs_req_chg_comm_cr_user_fk    references users(user_id),
    creation_date                                  timestamptz default current_timestamp
         constraint crs_req_chg_comm_cr_date_nn not null
 ); 



