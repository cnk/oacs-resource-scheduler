-- categories contains a simple grouping mechanism for categorizing content
create table ctrl_categories (
        category_id                             integer
                constraint                      ctrl_categories_category_id_pk primary key
                constraint                      ctrl_categories_category_id_fk references acs_objects(object_id),
        parent_category_id                      integer
                constraint                      ctrl_categories_parent_category_id_fk references ctrl_categories (category_id),
        name                                    varchar(300)    not null,
        plural                                  varchar(300)    not null,
        description                             varchar(4000),
        enabled_p                               char(1) default 't'
                constraint                      ctrl_categories_enabled_p_ck check (enabled_p in ('t','f')),
        profiling_weight                        integer default 1
                constraint                      ctrl_categories_profiling_weight_gt0_ck check (profiling_weight >= 0),
        -- need sortkey so we can pull hierarchies of categories w/o CONNECT BY
        tree_sortkey                            varbit,
        -- Make sure that the category name is unique within the parent category id
        constraint ctrl_categories_name_un unique (parent_category_id, name)
);

create index ctrl_categories_tree_sortkey_idx on ctrl_categories(tree_sortkey);
create index ctrl_categories_enabled_p_idx on ctrl_categories(enabled_p);
create index ctrl_categories_name_idx on ctrl_categories(name);

-- need insert and update triggers to fill in tree_sortkey
create or replace function ctrl_category_insert_tr () returns opaque as '
declare
        v_parent_sk     varbit  default null;
        v_max_value     integer;
begin
	if new.parent_category_id is null then
	    select max(tree_leaf_key_to_int(tree_sortkey)) into v_max_value
              from ctrl_categories
             where parent_category_id is null;
        else
	    select max(tree_leaf_key_to_int(tree_sortkey)) into v_max_value
              from ctrl_categories
             where parent_category_id = new.parent_category_id;

            select tree_sortkey into v_parent_sk 
              from ctrl_categories
             where category_id = new.parent_category_id;
        end if;

        new.tree_sortkey := tree_next_key(v_parent_sk, v_max_value);

        return new;

end;' language 'plpgsql';

create trigger ctrl_category_insert_tr before insert 
on ctrl_categories
for each row 
execute procedure ctrl_category_insert_tr ();

create or replace function ctrl_category_update_tr () returns opaque as '
declare
        v_parent_sk     varbit default null;
        v_max_value     integer;
        v_rec           record;
        clr_keys_p      boolean default ''t'';
begin
        -- if the current id and parent id are the same, leave everything alone
        if new.category_id = old.category_id and 
           ((new.parent_category_id = old.parent_category_id) or 
            (new.parent_category_id is null and old.parent_category_id is null)) then

           return new;

        end if;

        for v_rec in select category_id, parent_category_id
                     from ctrl_categories
                     where tree_sortkey between new.tree_sortkey and tree_right(new.tree_sortkey)
                     order by tree_sortkey
        LOOP
            if clr_keys_p then
               update ctrl_categories set tree_sortkey = null
               where tree_sortkey between new.tree_sortkey and tree_right(new.tree_sortkey);
               clr_keys_p := ''f'';
            end if;
            
            select max(tree_leaf_key_to_int(tree_sortkey)) into v_max_value
              from ctrl_categories
              where parent_category_id = v_rec.parent_category_id;

            select tree_sortkey into v_parent_sk 
              from ctrl_categories
             where category_id = v_rec.parent_category_id;

            update ctrl_categories
               set tree_sortkey = tree_next_key(v_parent_sk, v_max_value)
             where category_id = v_rec.category_id;

        end LOOP;

        return new;

end;' language 'plpgsql';

create trigger ctrl_category_update_tr after update 
on ctrl_categories
for each row 
execute procedure ctrl_category_update_tr ();
