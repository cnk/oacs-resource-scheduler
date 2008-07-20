ad_page_contract {
  This is the top level master template.  It allows the basic parts of an XHTML 
  document to be set through convenient data structures without introducing 
  anything site specific.

  You should NEVER need to modify this file.  
  
  Most of the time your pages or master templates should not directly set this
  file in their <master> tag.  They should instead use site-master with 
  provides a set of standard OpenACS content.  Only pages which need to return
  raw HTML should use this template directly.

  When using this template directly you MUST supply the following variables:

  @property doc(title)        The document title, ie. <title /> tag.
  @property doc(title_lang)   The language of the document title, if different
                              from the document language.

  The document output can be customised by supplying the following variables:

  @property doc(type)         The declared xml DOCTYPE.
  @property doc(charset)      The document character set.
  @property body(id)          The id attribute of the body tag.
  @property body(class)       The class of the body tag.

  ad_conn -set language       Must be used to override the document language
                              if necessary.

  To add a CSS or Javascripts to the <head> section of the document you can 
  call the corresponding template::head::add_* functions within your page.

  @see template::head::add_css
  @see template::head::add_javascript

  More generally, meta, link and script tags can be added to the <head> section
  of the document by calling their template::head::add_* function within your
  page.

  @see template::head::add_meta
  @see template::head::add_link
  @see template::head::add_script

  Javascript event handlers, such as onload, an be added to the <body> tag by 
  calling template::add_body_handler within your page.

  @see template::add_body_handler

  Finally, for more advanced functionality see the documentation for 
  template::add_body_script, template::add_header and template::add_footer.

  @see template::add_body_script
  @see template::add_header
  @see template::add_footer
 
  @author Kevin Scaldeferri (kevin@arsdigita.com)
          Lee Denison (lee@xarg.co.uk)
  @creation-date 14 Sept 2000

  $Id: blank-master.tcl,v 1.42 2008-01-08 13:51:26 daveb Exp $
}

if {[template::util::is_nil doc(type)]} { 
    set doc(type) {<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
}

#
# Add standard meta tags
#
template::head::add_meta \
    -name generator \
    -lang en \
    -content "OpenACS version [ad_acs_version]"
    
# Add standard javascript
#
template::head::add_javascript -src "/resources/acs-subsite/core.js"

# The following (forms, list and xinha) should
# be done in acs-templating.

#
# Add standard css
#
template::head::add_css \
    -href "/resources/acs-templating/lists.css" \
    -media "all"

template::head::add_css \
    -href "/resources/acs-templating/forms.css" \
    -media "all"

#
# Temporary (?) fix to get xinha working
#
if {[info exists ::acs_blank_master(xinha)]} {
  set ::xinha_dir /resources/acs-templating/xinha-nightly/
  set ::xinha_lang [lang::conn::language]
  #
  # Xinha localization covers 33 languages, removing
  # the following restriction should be fine.
  #
  #if {$::xinha_lang ne "en" && $::xinha_lang ne "de"} {
  #  set ::xinha_lang en
  #}

  # We could add site wide Xinha configurations (.js code) into xinha_params
  set xinha_params ""

  # Per call configuration
  set xinha_plugins $::acs_blank_master(xinha.plugins)
  set xinha_options $::acs_blank_master(xinha.options)
  
  # HTML ids of the textareas used for Xinha
  set htmlarea_ids '[join $::acs_blank_master__htmlareas "','"]'
  
  template::head::add_script -type text/javascript -script "
         xinha_editors = null;
         xinha_init = null;
         xinha_config = null;
         xinha_plugins = null;
         xinha_init = xinha_init ? xinha_init : function() {
            xinha_plugins = xinha_plugins ? xinha_plugins : 
              \[$xinha_plugins\];

            // THIS BIT OF JAVASCRIPT LOADS THE PLUGINS, NO TOUCHING  
            if(!Xinha.loadPlugins(xinha_plugins, xinha_init)) return;

            xinha_editors = xinha_editors ? xinha_editors :\[ $htmlarea_ids \];
            xinha_config = xinha_config ? xinha_config() : new Xinha.Config();
            $xinha_params
            $xinha_options
            xinha_editors = 
                 Xinha.makeEditors(xinha_editors, xinha_config, xinha_plugins);
            Xinha.startEditors(xinha_editors);
         }
         //window.onload = xinha_init;
      "

  template::add_body_handler -event onload -script "xinha_init();"
  template::head::add_javascript -src ${::xinha_dir}XinhaCore.js
}


if {![info exists doc(title)]} {
    set doc(title) "[ad_conn instance_name]"
    ns_log warning "[ad_conn url] has no doc(title) set."
}
# AG: Markup in <title> tags doesn't render well.
set doc(title) [ns_striphtml $doc(title)]

if {[template::util::is_nil doc(charset)]} {
    set doc(charset) [ns_config ns/parameters OutputCharset [ad_conn charset]]
}

template::head::add_meta \
    -content "text/html; charset=$doc(charset)" \
    -http_equiv "content-type"

# The document language is always set from [ad_conn lang] which by default 
# returns the language setting for the current user.  This is probably
# not a bad guess, but the rest of OpenACS must override this setting when
# appropriate and set the lang attribxute of tags which differ from the language
# of the page.  Otherwise we are lying to the browser.
set doc(lang) [ad_conn language]

# Determine if we should be displaying the translation UI
#
if {[lang::util::translator_mode_p]} {
    template::add_footer -src "/packages/acs-lang/lib/messages-to-translate"
}

# Determine if developer support is installed and enabled
#
set developer_support_p [expr {
    [llength [info procs ::ds_show_p]] == 1 && [ds_show_p]
}]

if {$developer_support_p} {
    template::head::add_css \
        -href "/resources/acs-developer-support/acs-developer-support.css" \
        -media "all"
 
    template::add_header -src "/packages/acs-developer-support/lib/toolbar"
    template::add_footer -src "/packages/acs-developer-support/lib/footer"
}

if {[info exists focus] && $focus ne ""} {
    # Handle elements where the name contains a dot
    if { [regexp {^([^.]*)\.(.*)$} $focus match form_name element_name] } {
        template::add_body_handler \
            -event onload \
            -script "acs_Focus('${form_name}', '${element_name}');" \
            -identifier "focus"
        
    }
}

template::head::prepare_multirows
set event_handlers [template::get_body_event_handlers]
# Retrieve headers and footers
set header [template::get_header_html]
set footer [template::get_footer_html]
