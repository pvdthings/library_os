create table public.signed_documents (
  id bigint generated always as identity not null,
  document_id bigint not null,
  member_id bigint not null,
  signed_at timestamp with time zone null default now(),
  constraint signed_documents_pkey primary key (id),
  constraint signed_documents_document_id_fkey foreign KEY (document_id) references documents (id) on delete CASCADE,
  constraint signed_documents_member_id_fkey foreign KEY (member_id) references members (id) on delete CASCADE
) TABLESPACE pg_default;