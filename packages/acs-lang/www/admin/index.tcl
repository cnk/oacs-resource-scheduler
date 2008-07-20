# /packages/acs-lang/www/admin/index.tcl

ad_page_contract {

    Administration of the localized messages

    @author Bruno Mattarollo <bruno.mattarollo@ams.greenpeace.org>
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 19 October 2001
    @cvs-id $Id: index.tcl,v 1.9 2007-01-10 21:22:04 gustafn Exp $
}

# We rename to avoid conflict in queries
set system_locale [lang::system::locale -site_wide]
set system_locale_label [lang::util::get_label $system_locale]

set page_title "Administration of Localization"
set context [list]

set site_wide_admin_p [acs_user::site_wide_admin_p]

set timezone_p [lang::system::timezone_support_p]

set timezone [lang::system::timezone]

set translator_mode_p [lang::util::translator_mode_p]

set import_url [export_vars -base import-messages]
set export_url [export_vars -base export-messages]

set parameter_url [export_vars -base "/shared/parameters" { {package_id {[ad_conn package_id]} } { return_url {[ad_return_url]} } }]


#####
#
# Locales
#
#####

set num_messages [db_string num_messages { select count(*) from lang_message_keys }]

db_multirow -extend { 
    escaped_locale
    msg_edit_url
    locale_edit_url
    locale_delete_url
    locale_make_default_url
    locale_enabled_p_url
    num_translated_pretty
    num_untranslated
    num_untranslated_pretty
} locales select_locales {
    select l.locale,
           l.label as locale_label,
           l.language,
           l.default_p as default_p,
           l.enabled_p as enabled_p,
           (select count(*) from ad_locales l2 where l2.language = l.language) as num_locales_for_language,
           (select count(*) from lang_messages lm2 where lm2.locale = l.locale) as num_translated
    from   ad_locales l
    order  by locale_label
} {
    set escaped_locale [ns_urlencode $locale]
    set msg_edit_url "package-list?[export_vars { locale }]"
    set locale_edit_url "locale-edit?[export_vars { locale }]"
    set locale_delete_url "locale-delete?[export_vars { locale }]"
    set locale_make_default_url "locale-make-default?[export_vars { locale }]"
    set toggle_enabled_p [ad_decode $enabled_p "t" "f" "t"]
    set locale_enabled_p_url "locale-set-enabled-p?[export_vars { locale {enabled_p $toggle_enabled_p} }]"
    
    set num_translated_pretty [lc_numeric $num_translated]
    set num_untranslated [expr {$num_messages - $num_translated}]
    set num_untranslated_pretty [lc_numeric $num_untranslated]
}
