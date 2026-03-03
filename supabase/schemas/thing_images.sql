create table public.thing_images (
  id bigint generated always as identity not null,
  thing_id bigint not null,
  url text not null,
  constraint thing_images_pkey primary key (id),
  constraint thing_images_thing_id_fkey foreign KEY (thing_id) references things (id) on delete CASCADE
) TABLESPACE pg_default;