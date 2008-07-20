-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/institution-create.sql
--
-- An Institution Package to model departments, employees, and other data  within an Institution
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @author nick@ucla.edu (NY)
-- @creation-date 2003-07-17
-- @cvs-id $Id: institution-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

--------------------------------------------------------------------------------
-- EXTERNAL DATA ---------------------------------------------------------------
@required-categories-create.sql

--------------------------------------------------------------------------------
-- TABLES ----------------------------------------------------------------------
@party-supplement-create.sql
@certification-create.sql
@publication-create.sql
@personnel-create.sql
@physician-create.sql
@faculty-create.sql
@group-create.sql

@publication-map-create.sql
@resume-create.sql
@party-image-create.sql

@subsite-for-party-rel-create.sql

@subsite-personnel-object-lists-create.sql
@subsite-personnel-research-interests-create.sql

-- JCCC Data
@jccc-institution-create.sql

@sttp-create.sql

--------------------------------------------------------------------------------
-- OACS METADATA ---------------------------------------------------------------
@party-supplement-address-oacsmd-create.sql
@party-supplement-email-oacsmd-create.sql
@party-supplement-phone-oacsmd-create.sql
@party-supplement-url-oacsmd-create.sql
@certification-oacsmd-create.sql
@publication-oacsmd-create.sql
@personnel-oacsmd-create.sql
--@physician-oacsmd-create.sql
@faculty-oacsmd-create.sql
@group-oacsmd-create.sql
--? @publication-map-oacsmd-create.sql
@resume-oacsmd-create.sql
@party-image-oacsmd-create.sql
@subsite-for-party-rel-oacsmd-create.sql

--------------------------------------------------------------------------------
-- PACKAGE BODIES --------------------------------------------------------------
@party-supplement-address-pkg-create.sql
@party-supplement-email-pkg-create.sql
@party-supplement-phone-pkg-create.sql
@party-supplement-url-pkg-create.sql
@certification-pkg-create.sql
@publication-pkg-create.sql

@resume-pkg-create.sql
@party-image-pkg-create.sql
@subsite-for-party-rel-pkg-create.sql

@subsite-personnel-object-lists-pkg-create.sql

@personnel-pkg-create.sql
--@physician-pkg-create.sql
@faculty-pkg-create.sql
@group-pkg-create.sql


--select sequence_name name from user_sequences where sequence_name like 'INST%' order by name;
--select table_name name from user_tables where table_name like 'INST%' order by name;
--select constraint_name name from user_constraints where constraint_name like 'INST%' order by name;

--select object_type from acs_object_types where object_type like 'inst%';
--select attribute_id from acs_attributes where object_type like 'inst%';
--select distinct name, type from user_source where name like 'INST%';


