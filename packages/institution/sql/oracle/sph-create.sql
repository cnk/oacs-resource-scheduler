-- /packages/institution/sql/oracle/sph-create.sql
--
-- School of Public Health Specific Data
-- 
-- @author kellie@ctrl.ucla.edu
-- @creation-date 09/27/2006
-- @cvs-id $Id

create table sph_personnel (
	personnel_id	integer
			constraint sph_pers_personnel_id_pk primary key,
			constraint sph_pers_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	courses		varchar2(4000)
);

create table sph_personnel_categories (
	personnel_id	integer
			constraint sph_pers_cat_personnel_id_nn not null,
			constraint sph_pers_cat_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	pc_id		integer
			constraint sph_pers_cat_pc_id_nn not null
			constraint sph_pers_cat_pc_id_fk references categories(category_id),
	c_id		integer
			constraint sph_pers_cat_c_id_nn not null
			constraint sph_pers_cat_c_id_fk references categories(category_id),
	constraint sph_pers_catategories_pk primary key (personnel_id, pc_id, c_id)
);
