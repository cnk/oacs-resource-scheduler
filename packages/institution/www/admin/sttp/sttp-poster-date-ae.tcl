# /packages/institutions/www/admin/sttp/sttp-poster-date.tcl

ad_page_contract {
    STTP poster date for admin

    @author  reye@mednet.ucla.edu
    @creation-date  11/30/2004
    @cvs-id  $Id
}

# getting parameter poster date from server
set poster_session_date [ad_parameter "sttp_poster_session_date"]

ad_form -name "poster_date" -method (post) -form {
    {poster_date:text  {label "Date of STTP Poster Session:"} {value $poster_session_date} {html {size 40}}
    {after_html {
	i.e. <b>"Thursday, August 25, 2005 1-4 p.m."</b>
    }}
}
} -action {sttp-poster-date-ae-2}
