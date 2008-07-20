-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/sttp-drop.sql
--
-- Drop script for the short-term training program data
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004/10/25
-- @cvs-id			$Id: sttp-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--
begin
	for p in (select	request_id
				from	inst_short_term_trnng_progs) loop
		inst_short_term_trnng_prog.delete(p.request_id);
	end loop;
end;
/
drop package inst_short_term_trnng_prog;
drop table inst_short_term_trnng_progs;
exec acs_object_type.drop_type('inst_short_term_trnng_prog');
