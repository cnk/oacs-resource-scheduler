-- Data model to support XML exchange with thecontent repository of
-- the ArsDigita Community System

-- Copyright (C) 1999-2000 ArsDigita Corporation
-- Author: Karl Goldstein (karlg@arsdigita.com)

-- $Id: content-xml.sql,v 1.2 2006-09-26 14:55:28 byronl Exp $

-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html

-- A sequence for uniquely identifying uploaded XML documents until
-- they are inserted into the repository

create sequence cr_xml_doc_seq;

create global temporary table cr_xml_docs (
    doc_id        integer 
		  constraint cr_xml_docs_doc_id_pk primary key,
    doc           CLOB
) on commit delete rows;

comment on table cr_xml_docs is '
  A temporary table for holding uploaded XML documents for the
  duration of a transaction, until they can be inserted into
  the content repository.
';

