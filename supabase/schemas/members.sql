create table public.members (
  id bigint generated always as identity not null,
  name text not null,
  email text not null,
  join_date date not null,
  phone text null,
  keyholder boolean null default false,
  user_id uuid null,
  constraint members_pkey primary key (id),
  constraint members_email_key unique (email),
  constraint members_user_id_fkey foreign KEY (user_id) references auth.users (id) on update CASCADE on delete set null
) TABLESPACE pg_default;