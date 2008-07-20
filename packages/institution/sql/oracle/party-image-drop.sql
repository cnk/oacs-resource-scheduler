-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-image-drop.sql
--
-- Drop Script for Party Images
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-05-18
-- @cvs-id $Id: party-image-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--
drop package inst_party_image;
drop table inst_party_images;
exec acs_object_type.drop_type('inst_party_image');
