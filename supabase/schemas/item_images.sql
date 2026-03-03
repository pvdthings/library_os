create table public.item_images (
  id bigint generated always as identity not null,
  item_id bigint not null,
  url text not null,
  constraint item_images_pkey primary key (id),
  constraint item_images_item_id_fkey foreign KEY (item_id) references items (id) on delete CASCADE
) TABLESPACE pg_default;