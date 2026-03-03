create table public.categories (
  id bigint generated always as identity not null,
  name text not null,
  description text null,
  constraint categories_pkey primary key (id),
  constraint categories_name_key unique (name)
) TABLESPACE pg_default;