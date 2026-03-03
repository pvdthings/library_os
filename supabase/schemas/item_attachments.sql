create table public.item_attachments (
  id bigint generated always as identity not null,
  item_id bigint not null,
  url text not null,
  name text null,
  constraint item_attachments_pkey primary key (id),
  constraint item_attachments_item_id_fkey foreign KEY (item_id) references items (id) on delete CASCADE
) TABLESPACE pg_default;