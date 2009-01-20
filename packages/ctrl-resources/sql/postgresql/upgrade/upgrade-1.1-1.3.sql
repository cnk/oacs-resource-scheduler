------------------------------------------------------------------
-- Add allow reservation feature 
-----------------------------------------------------------------
alter table crs_reservable_resources add reservable_p char(1);
update crs_reservable_resources set reservable_p = 't';
alter table crs_reservable_resources add constraint crres_resv_p_ck check (reservable_p in ('t','f'));
alter table crs_reservable_resources add reservable_p_note varchar2(300);

@@../crs-views-create.sql
@@../crs-views-room-create.sql
@@../crs-pkg-reservable-resource-create.sql
@@../crs-pkg-room-create.sql

commit;
