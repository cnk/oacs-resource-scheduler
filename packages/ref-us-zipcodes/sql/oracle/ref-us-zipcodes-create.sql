--
-- @author jon@jongriffin.com
-- @creation-date 2001-08-27
-- @cvs-id $Id: ref-us-zipcodes-create.sql,v 1.3 2003-09-25 23:52:50 jong Exp $
--

create table us_zipcodes (
    zipcode           char(5)        
                      constraint us_zipcodes_zipcode_nn not null,
    name              varchar2(100)       
                      constraint us_zipcodes_name_nn not null,
    fips_state_code   char(2)
                      constraint us_zipcodes_fips_fk 
                      references us_states(fips_state_code),
    fips_county_code  char(6)
	              constraint us_county_codes_nn not null,
    latitude          number,
    longitude         number,
    --
    -- Some zipcodes straddle state boundaries, so the zipcode itself
    -- isn't unique. We form a primary key for this table from the
    -- combination of zipcode and FIPS state code.
    --
    constraint us_zipcodes_unique_pk primary key (zipcode, fips_state_code)
);

comment on table us_zipcodes is '
This is the table of US zipcodes. It does not include zip+4.
';

comment on column us_zipcodes.zipcode is '
5-digit Zipcode.
';

comment on column us_zipcodes.name is '
Zipcode name.
';

comment on column us_zipcodes.fips_state_code is '
State FIPS code.
';

comment on column us_zipcodes.fips_county_code is '
County FIPS code.
';

comment on column us_zipcodes.longitude is '
Longitude in decimal degress.
';

comment on column us_zipcodes.latitude is '
Latitude in decimal degress.
';

-- add this table into the reference repository

declare
    v_id integer;
begin
    v_id := acs_reference.new(
        table_name     => 'US_ZIPCODES',
        package_name   => 'US_ZIPCODE',
        source         => 'US Census Bureau',
        source_url     => 'http://www.census.gov/geo/www/tiger/zip1999.html',
        last_update    => to_date('1999-11-30','YYYY-MM-DD'),
        effective_date => sysdate
    );
commit;
end;
/

-- load data

@ '../common/ref-us-zipcodes-data.sql'
-- now load the update
@ '../../common/upgrade/ref-us-zipcodes-data-0.1d-2.0.sql'