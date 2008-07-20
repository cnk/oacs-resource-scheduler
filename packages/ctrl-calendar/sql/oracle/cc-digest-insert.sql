insert into ccal_digest_map (cal_digest_id, cal_id, ext_digest_url_root, ext_digest_id, mapping_date, mapped_by)
select acs_object_id_seq.nextval, cc.cal_id, 'digest.healthsciences.ucla.edu', 3022, sysdate, 19020 from ctrl_calendars cc 
where  not exists (select 1 from ccal_digest_map cdm where cdm.cal_id = cc.cal_id) and cc.owner_id is null;

commit;
