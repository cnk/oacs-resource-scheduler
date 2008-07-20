-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-drop.sql
--
-- Drop Script for Supplementary Party Tables
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-07-20
-- @cvs-id $Id: party-supplement-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--
drop package inst_party_url;
drop package inst_party_phone;
drop package inst_party_email;
drop package inst_party_address;

drop table inst_party_urls;
drop table inst_party_phones;
drop table inst_party_emails;
drop table inst_party_addresses;
drop table inst_party_category_map;

begin
	acs_object_type.drop_type('url');
	acs_object_type.drop_type('phone_number');
	acs_object_type.drop_type('email_address');
	acs_object_type.drop_type('address');
end;
/
show errors;
