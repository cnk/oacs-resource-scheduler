-- /packages/ctrl-calendars/sql/oracle/upgrade/upgrade-1.2-1.3.sql
-- create a table that keeps track list of emails that downloaded an event

create table ctrl_calendar_event_downloads (
        event_id        integer
                        constraint cce_download_event_id_nn not null
                        constraint cce_download_event_id_fk references ctrl_events(event_id),
        email           varchar2(250)
                        constraint cce_download_email_nn not null,
        download_date   date default sysdate,
        constraint cce_download_pk primary key (event_id, email)
);

commit;
