create table public.loans (
  id bigint generated always as identity not null,
  checkout_date timestamp with time zone not null default now(),
  due_date date not null,
  notes text null,
  member_id bigint null,
  reminders_sent bigint not null default '0'::bigint,
  constraint loans_pkey primary key (id),
  constraint loans_member_id_fkey foreign KEY (member_id) references members (id) on update CASCADE
) TABLESPACE pg_default;