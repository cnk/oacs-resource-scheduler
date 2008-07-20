-- upgrade-2.0-2.1.sql

-- Research Interests
@../subsite-personnel-research-interests-create.sql

-- Middle Name
alter table persons add middle_name varchar2(100);

create or replace package person
as

 function new (
  person_id	in persons.person_id%TYPE default null,
  object_type	in acs_objects.object_type%TYPE
		   default 'person',
  creation_date	in acs_objects.creation_date%TYPE
		   default sysdate,
  creation_user	in acs_objects.creation_user%TYPE
		   default null,
  creation_ip	in acs_objects.creation_ip%TYPE default null,
  email		in parties.email%TYPE,
  url		in parties.url%TYPE default null,
  first_names	in persons.first_names%TYPE,
  last_name	in persons.last_name%TYPE,
  context_id	in acs_objects.context_id%TYPE default null,
  middle_name	in persons.middle_name%TYPE default null
 ) return persons.person_id%TYPE;

 procedure del (
  person_id	in persons.person_id%TYPE
 );

 function name (
  person_id	in persons.person_id%TYPE
 ) return varchar2;

 function first_names (
  person_id	in persons.person_id%TYPE
 ) return varchar2;

 function last_name (
  person_id	in persons.person_id%TYPE
 ) return varchar2;

end person;
/
show errors

create or replace package body person
as

 function new (
  person_id	in persons.person_id%TYPE default null,
  object_type	in acs_objects.object_type%TYPE
		   default 'person',
  creation_date	in acs_objects.creation_date%TYPE
		   default sysdate,
  creation_user	in acs_objects.creation_user%TYPE
		   default null,
  creation_ip	in acs_objects.creation_ip%TYPE default null,
  email		in parties.email%TYPE,
  url		in parties.url%TYPE default null,
  first_names	in persons.first_names%TYPE,
  last_name	in persons.last_name%TYPE,
  context_id	in acs_objects.context_id%TYPE default null,
  middle_name	in persons.middle_name%TYPE default null
 )
 return persons.person_id%TYPE
 is
  v_person_id persons.person_id%TYPE;
 begin
  v_person_id :=
   party.new(person_id, object_type,
             creation_date, creation_user, creation_ip,
             email, url, context_id);

  insert into persons
   (person_id, first_names, middle_name, last_name)
  values
   (v_person_id, first_names, middle_name, last_name);

  return v_person_id;
 end new;

 procedure del (
  person_id	in persons.person_id%TYPE
 )
 is
 begin
  delete from persons
  where person_id = person.del.person_id;

  party.del(person_id);
 end del;

 function name (
  person_id	in persons.person_id%TYPE
 )
 return varchar2
 is
  person_name varchar2(200);
 begin
  select first_names || decode(middle_name,null,' ', ' ' || middle_name || ' ') || last_name
  into person_name
  from persons
  where person_id = name.person_id;

  return person_name;
 end name;

 function first_names (
  person_id	in persons.person_id%TYPE
 )
 return varchar2
 is
  person_first_names varchar2(200);
 begin
  select first_names
  into person_first_names
  from persons
  where person_id = first_names.person_id;

  return person_first_names;
 end first_names;

function last_name (
  person_id	in persons.person_id%TYPE
 )
 return varchar2
 is
  person_last_name varchar2(200);
 begin
  select last_name
  into person_last_name
  from persons
  where person_id = last_name.person_id;

  return person_last_name;
 end last_name;

end person;
/
show errors

-- Preferred Names
alter table inst_personnel add preferred_first_name varchar2(100);
alter table inst_personnel add preferred_middle_name varchar2(100);
alter table inst_personnel add preferred_last_name varchar2(100);

declare
	attr_id		acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type	=> 'inst_personnel',
		attribute_name	=> 'PREFERRED_FIRST_NAME',
		pretty_name	=> 'Preferred First Name',
		pretty_plural	=> 'Preferred First Names',
		datatype	=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'inst_personnel',
		attribute_name	=> 'PREFERRED_MIDDLE_NAME',
		pretty_name	=> 'Preferred Middle Name',
		pretty_plural	=> 'Preferred Middle Names',
		datatype	=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type	=> 'inst_personnel',
		attribute_name	=> 'PREFERRED_LAST_NAME',
		pretty_name	=> 'Preferred Last Name',
		pretty_plural	=> 'Preferred Last Names',
		datatype	=> 'string'
	);
end;
/
show errors;

@../personnel-pkg-create.sql

-- JCCC Data
@../jccc-institution-create.sql

-- Fix and rename this trigger
drop trigger inst_prsnl_titles_agg_synch;
@../certification-pkg-create.sql

-- cause the above trigger to run if there's any certification data:
update	inst_certifications
   set	certification_type_id = certification_type_id
 where	rownum = 1;
