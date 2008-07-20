--
-- packages/language/sql/language-create.sql
--
-- @author Jeff Davis (davis@xarg.net)
-- @creation-date 2000-09-10
-- @cvs-id $Id: ad-locales-drop.sql,v 1.3 2004-02-24 12:03:09 jeffd Exp $
--

-- ****************************************************************************
-- * The lang_messages table holds the message catalog.
-- * It is populated by ad_lang_message_register.
-- * The registered_p flag denotes that a message exists in a file
-- * that gets loaded on server startup, and hence should not get updated.
-- ****************************************************************************

drop table ad_locale_user_prefs;
drop view enabled_locales;
drop table ad_locales;

