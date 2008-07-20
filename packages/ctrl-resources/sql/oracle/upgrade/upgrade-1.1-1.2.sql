------------------------------------------------------------------
-- Add color display 
-----------------------------------------------------------------
alter table crs_reservable_resources add color varchar2(6);

@@../crs-pkg-room-create.sql
@@../crs-pkg-reservable-resource-create.sql
@@../crs-views-create.sql
@@../crs-views-room-create.sql

commit;
