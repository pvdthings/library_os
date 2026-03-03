create table public.documents (
  id bigint generated always as identity not null,
  name text not null,
  url text null,
  required boolean null default false,
  constraint documents_pkey primary key (id)
) TABLESPACE pg_default;