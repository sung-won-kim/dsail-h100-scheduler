-- DSAIL H100 Scheduler · Supabase 스키마
-- Supabase 대시보드 > SQL Editor 에 그대로 붙여넣고 Run 하세요. 여러 번 실행해도 안전합니다.

-- 컬렉션 하나에 테이블 하나가 아니라, 모든 기록을 한 테이블에 담습니다.
-- 앱이 쓰는 컬렉션: members / bookings / transfers / requests
create table if not exists public.dsail_rows (
  coll       text not null check (coll in ('members','bookings','transfers','requests','meta')),
  id         text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (coll, id)
);

-- 동시 예약 방지용 잠금. 8초가 지난 잠금은 앱이 알아서 지웁니다.
create table if not exists public.dsail_locks (
  name   text primary key,
  holder text not null,
  at     timestamptz not null default now()
);

alter table public.dsail_rows  enable row level security;
alter table public.dsail_locks enable row level security;

-- 접근 정책: "링크를 아는 사람은 자유롭게"
-- anon 키만으로 읽기와 쓰기를 모두 허용합니다. 로그인 없이 바로 쓸 수 있는 대신,
-- 주소를 아는 누구나 기록을 남기거나 지울 수 있습니다. 나중에 조이려면 아래 정책만 바꾸면 됩니다.
drop policy if exists "rows_read"   on public.dsail_rows;
drop policy if exists "rows_insert" on public.dsail_rows;
drop policy if exists "rows_update" on public.dsail_rows;
drop policy if exists "rows_delete" on public.dsail_rows;
create policy "rows_read"   on public.dsail_rows for select to anon, authenticated using (true);
create policy "rows_insert" on public.dsail_rows for insert to anon, authenticated with check (true);
create policy "rows_update" on public.dsail_rows for update to anon, authenticated using (true) with check (true);
create policy "rows_delete" on public.dsail_rows for delete to anon, authenticated using (true);

drop policy if exists "locks_read"   on public.dsail_locks;
drop policy if exists "locks_insert" on public.dsail_locks;
drop policy if exists "locks_delete" on public.dsail_locks;
create policy "locks_read"   on public.dsail_locks for select to anon, authenticated using (true);
create policy "locks_insert" on public.dsail_locks for insert to anon, authenticated with check (true);
create policy "locks_delete" on public.dsail_locks for delete to anon, authenticated using (true);

-- 실시간 반영(다른 사람의 예약이 새로고침 없이 보이게)
do $$
begin
  alter publication supabase_realtime add table public.dsail_rows;
exception
  when duplicate_object then null;
end $$;

-- 참고 조회: 지금 들어있는 행 수
-- select coll, count(*) from public.dsail_rows group by coll order by coll;
