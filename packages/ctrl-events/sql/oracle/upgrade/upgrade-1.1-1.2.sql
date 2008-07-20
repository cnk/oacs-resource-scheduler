--/packages/ctrl_events/sql/oracle/upgrade/upgrade-1.1-1.2.sql
-- add new columns (signin_id, signin_date) for ctrl_events_attendees
alter table ctrl_events_attendees add signin_id varchar2(100);
alter table ctrl_events_attendees add signin_date date;

-- add columns status, public_p, approved_p
alter table ctrl_events add status varchar2(15) default 'scheduled';
alter table ctrl_events add constraint ctrl_events_status_ck check (status in ('cancelled','pending','scheduled'));

alter table ctrl_events add public_p char(1) default 't';
alter table ctrl_events add constraint ctrl_events_public_p_nn check (public_p is not null);
alter table ctrl_events add constraint ctrl_events_public_p_ck check (public_p in ('t','f'));

alter table ctrl_events add approved_p char(1) default 't';
alter table ctrl_events add constraint ctrl_events_approved_p_nn check (approved_p is not null);
alter table ctrl_events add constraint ctrl_events_approved_p_ck check (approved_p in ('t','f'));

commit;
                                        


