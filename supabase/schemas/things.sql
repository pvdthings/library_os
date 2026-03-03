create table public.things (
  id bigint generated always as identity not null,
  name text not null,
  description text null,
  spanish_name text null,
  hidden boolean null default false,
  eye_protection boolean not null default false,
  constraint things_pkey primary key (id)
) TABLESPACE pg_default;