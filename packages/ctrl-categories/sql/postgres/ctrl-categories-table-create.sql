-- categories contains a simple grouping mechanism for categorizing content
create table ctrl_categories (
        category_id                             integer
                constraint                      ctrl_categories_category_id_pk primary key,
        parent_category_id                      integer
                constraint                      ctrl_categories_parent_category_id_fk references ctrl_categories (category_id),
        name                                    varchar(300)    not null,
        plural                                  varchar(300)    not null,
        description                             varchar(4000),
        enabled_p                               char(1) default 't'
                constraint                      ctrl_categories_enabled_p_ck check (enabled_p in ('t','f')),
        profiling_weight                        integer default 1
                constraint                      ctrl_categories_profiling_weight_gt0_ck check (profiling_weight >= 0),
        -- Make sure that the category name is unique within the parent category id
        constraint ctrl_categories_name_un unique (parent_category_id, name)
);

create index ctrl_categories_enabled_p_idx on ctrl_categories(enabled_p);
create index ctrl_categories_name_idx on ctrl_categories(name);
