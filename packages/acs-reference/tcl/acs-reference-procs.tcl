ad_library {
    Utility procs for working with data in acs-reference

    @author Jon Griffin <jon@jongriffin.com>
    @creation-date 2001-08-28
    @cvs-id $Id: acs-reference-procs.tcl,v 1.1 2001-08-29 04:37:15 jong Exp $
}

ad_proc -private acs_reference_get_db_structure {
	{-table_name:required}
} {
    Query the DB to get the data structure.  Utility function.
} {

}
