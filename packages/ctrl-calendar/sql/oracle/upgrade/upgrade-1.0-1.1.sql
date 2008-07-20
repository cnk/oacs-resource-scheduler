alter table ctrl_calendars add (
  package_id        integer
    constraint ctrl_cal_package_id_fk references acs_objects(object_id)
);

@ ../cc-pkg-create.sql
