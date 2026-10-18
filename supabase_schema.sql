-- Run in Supabase SQL Editor before enabling cloud accounts.
create table if not exists public.teacher_roles (
  user_id uuid primary key references auth.users(id) on delete cascade
);
create table if not exists public.submissions (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  topic_title text not null default '',
  saved_at timestamptz not null default now(),
  draft jsonb not null default '{}'::jsonb,
  revision text not null default '',
  assessment jsonb,
  teacher_score numeric check (teacher_score between 0 and 100),
  teacher_notes text not null default ''
);
create index if not exists submissions_owner_idx on public.submissions(user_id);
alter table public.teacher_roles enable row level security;
alter table public.submissions enable row level security;
-- Teachers can discover only their OWN role assignment.
create policy "read own teacher role" on public.teacher_roles for select to authenticated using (user_id = (select auth.uid()));
-- Administrative teacher assignment must be performed manually through trusted SQL editor.
create or replace function public.is_4f_teacher() returns boolean
language sql stable security definer set search_path = ''
as $$ select exists(select 1 from public.teacher_roles where user_id = (select auth.uid())); $$;
revoke all on function public.is_4f_teacher() from public;
grant execute on function public.is_4f_teacher() to authenticated;
create policy "student reads own or teacher reads all" on public.submissions for select to authenticated
 using (user_id = (select auth.uid()) or public.is_4f_teacher());
create policy "student inserts own" on public.submissions for insert to authenticated
 with check (user_id = (select auth.uid()));
create policy "student updates own or teacher updates" on public.submissions for update to authenticated
 using (user_id = (select auth.uid()) or public.is_4f_teacher())
 with check (user_id = (select auth.uid()) or public.is_4f_teacher());
-- Register teacher by copying their user UUID from Supabase Authentication > Users:
-- insert into public.teacher_roles(user_id) values ('UUID-HERE');

-- Stop students changing a teacher's score or feedback, even for their own submission.
create or replace function public.protect_teacher_assessment() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if not public.is_4f_teacher() then
    if new.teacher_score is distinct from old.teacher_score
       or new.teacher_notes is distinct from old.teacher_notes then
      raise exception 'Only a designated teacher can modify assessment fields';
    end if;
  end if;
  return new;
end; $$;
drop trigger if exists teacher_assessment_guard on public.submissions;
create trigger teacher_assessment_guard before update on public.submissions
for each row execute function public.protect_teacher_assessment();
