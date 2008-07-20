ad_page_contract {
    update sttp_poster_session_date parameter
    @param poster_date

    @author reye@mednet.ucla.edu
    @creation-date  11/30/2004
    @cvs-id: $Id
} {
    {poster_date:notnull}
}

parameter::set_value -parameter sttp_poster_session_date -value $poster_date

ad_returnredirect index-ae
