drop package inst_subsite_for_party_rel;
drop table inst_subsite_for_party_rels;

begin
	acs_rel_type.drop_type('inst_subsite_for_party_rel');

	begin
		-- these may fail if used by other relationship types:
		acs_rel_type.drop_role('subsite');
		acs_rel_type.drop_role('party');
		exception when others then null;
	end;
end;
/
show errors;
