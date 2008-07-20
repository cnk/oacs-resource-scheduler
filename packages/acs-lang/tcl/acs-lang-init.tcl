ad_library {
    Do initialization at server startup for the acs-lang package.

    @creation-date 23 October 2000
    @author Peter Marklund (peter@collaboraid.biz)
    @cvs-id $Id: acs-lang-init.tcl,v 1.9 2003-10-17 08:30:12 peterm Exp $
}

# Cache I18N messages in memory for fast lookups
lang::message::cache
