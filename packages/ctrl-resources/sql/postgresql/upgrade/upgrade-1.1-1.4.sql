------------------------------------------------------------------
-- Add allow reservation feature 
-----------------------------------------------------------------
alter table crs_reservable_resources add special_request_p char(1);
update crs_reservable_resources set special_request_p = 'f';
alter table crs_reservable_resources add constraint crres_srequest_p_ck check (special_request_p in ('t','f'));

@@../crs-views-create.sql
@@../crs-views-room-create.sql
@@../crs-pkg-reservable-resource-create.sql
@@../crs-pkg-room-create.sql

commit;
