-- /packages/ctrl-resources/sql/oracle/crs-policy-tables-drop.sql
--
-- Drop Script for Policy Tables for CTRL Resources
--
-- @author avni@ctrl.ucla.edu (AK)
-- @creation-date 7/13/2008
-- @cvs-id $Id$
--

drop table crs_request_change_comments;

alter table crs_requests drop  (
    notify_if_updates,
    last_date_to_mod_after_res,
    last_date_to_mod_before_start,
    last_change_comment,
    policy_id,
    package_id
);

drop table crs_resv_resource_pol_assns;
drop table crs_resv_resource_policies;
drop sequence crs_resv_policy_seq;
