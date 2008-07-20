
create function inline_0() returns integer as '
declare
    rec        acs_reference_repositories%ROWTYPE;
begin
    for rec in select * from acs_reference_repositories where upper(table_name) like ''US_COUNTIES'' loop
	 execute ''drop table '' || rec.table_name;
         perform acs_reference__delete(rec.repository_id);
    end loop;
    return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

