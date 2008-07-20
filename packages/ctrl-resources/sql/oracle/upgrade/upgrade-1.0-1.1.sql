alter table crs_requests add repeat_template_id integer;
alter table crs_requests add repeat_template_p char(1) default 'f';

alter table crs_requests add constraint crreq_rt_p_nn check (repeat_template_p is not null);
alter table crs_requests add constraint crreq_rt_p_ck check(repeat_template_p in ('t','f'));
alter table crs_requests add constraint crreq_repeat_template_ck check((repeat_template_p='t' and repeat_template_id is null) or repeat_template_p='f');
alter table crs_requests add constraint crreq_repeat_request_fk foreign key(repeat_template_id) references crs_requests(request_id);

commit;



