-- /packages/institution/sql/oracle/jccc-institution-create.sql
--
-- JCCC Specific Data
-- 
-- @author avni@ctrl.ucla.edu (AK)
-- @creation-date 2004/10/15
-- @cvs-id $Id: jccc-institution-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--  

create table jccc_personnel (
       personnel_id		integer
		constraint	jccc_pers_personnel_id_pk primary key,
		constraint	jccc_pers_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
       nci_funding_p		char(1) default 'f'
		constraint	jccc_pers_nci_funding_p check (nci_funding_p in ('t','f')),
       expired_p		char(1) default 'f'
		constraint	jccc_pers_expired_p check (expired_p in ('t','f')),
       expired_comment		varchar2(4000),
       split_member_p		char(1) default 'f'
		constraint	jccc_pers_split_member_p check (split_member_p in ('t','f')),
       core_p			char(1) default 'f'
		constraint	jccc_pers_core_p check (core_p in ('t','f')),
       regular_p		char(1) default 'f'
		constraint	jccc_pers_reg_p check (regular_p in ('t','f')),
       membership_status	varchar2(4000),
       notes			varchar2(4000)
);       

create table jccc_groups (
       group_id			integer
		constraint	jccc_groups_group_id_pk primary key,
		constraint	jccc_groups_group_id_fk foreign key (group_id) references inst_groups(group_id),
       nci_code			varchar2(10) not null
);
