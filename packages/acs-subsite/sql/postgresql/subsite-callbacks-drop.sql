-- /packages/acs-subsite/sql/subsite-group-callbacks-drop.sql

-- Drops the subsite group callbacks data model

-- Copyright (C) 2001 ArsDigita Corporation
-- @author Michael Bryzek (mbryzek@arsdigita.com)
-- @creation-date 2001-02-21

-- $Id: subsite-callbacks-drop.sql,v 1.2 2001-04-17 04:10:06 danw Exp $

-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html

select drop_package('subsite_callback');
drop table subsite_callbacks;
