-- packages/ref-us-states/sql/oracle/ref-us-states-create.sql
--
-- @author jon@jongriffin.com
-- @creation-date 2001-08-27		
-- @cvs-id $Id: ref-us-states-create.sql,v 1.2 2003-07-18 00:25:33 donb Exp $

create table us_states (
    abbrev          char(2)
                    constraint us_states_abbrev_pk primary key,
    state_name      varchar2(100)
	            constraint us_states_state_name_nn not null
                    constraint us_states_state_name_uq unique,
    fips_state_code char(2)
                    constraint us_states_fips_state_code_uq unique
);

comment on table us_states is '
This is the US states table.
';

comment on column us_states.abbrev is '
This is the 2 letter abbreviation for states.
';

comment on column us_states.fips_state_code is '
The FIPS code used by the USPS for certain delivery types.
';

-- add this table into the reference repository
declare
    v_id integer;
begin
    v_id := acs_reference.new(
        table_name      => 'US_STATES',
        source          => 'Internal',
        source_url      => '',
        last_update     => sysdate,
        internal_data_p => 't',
        effective_date  => sysdate
    );
commit;
end;
/
