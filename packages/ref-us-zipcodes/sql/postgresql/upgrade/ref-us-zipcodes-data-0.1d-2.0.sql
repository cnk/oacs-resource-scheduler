-- load data
-- update the table info
    update acs_reference_repositories
    set table_name    = 'US_ZIPCODES',
        package_name   = 'US_ZIPCODE',
        source         = 'US Census Bureau',
        source_url     = 'http://www.census.gov/geo/www/tiger/zip1999.html',
        last_update    = to_date('2000-01-01','YYYY-MM-DD'),
        effective_date = now()
    where table_name = 'US_ZIPCODES';


begin;
\i ../../common/upgrade/ref-us-zipcodes-data-0.1d-2.0.sql
end;
