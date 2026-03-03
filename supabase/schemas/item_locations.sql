create table public.item_locations (
  id bigint generated always as identity not null,
  name text not null,
  constraint item_locations_pkey primary key (id)
) TABLESPACE pg_default;