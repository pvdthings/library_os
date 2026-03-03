create table public.thing_categories (
  thing_id bigint not null,
  category_id bigint not null,
  constraint thing_categories_pkey primary key (thing_id, category_id),
  constraint thing_categories_category_id_fkey foreign KEY (category_id) references categories (id) on delete CASCADE,
  constraint thing_categories_thing_id_fkey foreign KEY (thing_id) references things (id) on delete CASCADE
) TABLESPACE pg_default;