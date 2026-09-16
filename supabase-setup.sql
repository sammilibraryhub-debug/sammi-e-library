-- SAMMI E-Library — Supabase schema
-- Run this once in your Supabase project's SQL Editor (left sidebar > SQL Editor > New query)

-- 1) Main data table: replaces localStorage for book records AND login logs
--    (mirrors the existing app's data shape, so no other code changes are needed)
create table if not exists library_data (
  "__backendId" text primary key,
  title text,
  author text,
  category text,
  status text,
  rating int,
  notes text,
  added_at text,
  lrn text,
  login_timestamp text,
  login_date text,
  login_time text
);

alter table library_data enable row level security;

drop policy if exists "public read library_data" on library_data;
drop policy if exists "public insert library_data" on library_data;
drop policy if exists "public update library_data" on library_data;
drop policy if exists "public delete library_data" on library_data;

create policy "public read library_data"
  on library_data for select using (true);
create policy "public insert library_data"
  on library_data for insert with check (true);
create policy "public update library_data"
  on library_data for update using (true);
create policy "public delete library_data"
  on library_data for delete using (true);

-- 2) Resource click log: every time a student opens a resource link
create table if not exists resource_clicks (
  id bigint generated always as identity primary key,
  lrn text,
  resource_name text,
  resource_url text,
  clicked_at timestamptz default now()
);

alter table resource_clicks enable row level security;

drop policy if exists "public insert resource_clicks" on resource_clicks;
drop policy if exists "public read resource_clicks" on resource_clicks;

create policy "public insert resource_clicks"
  on resource_clicks for insert with check (true);
create policy "public read resource_clicks"
  on resource_clicks for select using (true);

-- NOTE ON SECURITY:
-- These policies are wide open (anyone with your public anon key can read/write).
-- That's the tradeoff for "minimal setup, no custom auth server."
-- It's a reasonable starting point for an internal school pilot, but before
-- handling real, sensitive student data at scale, consider tightening this
-- with real per-student authentication (Supabase Auth) and row-level policies
-- scoped to auth.uid() instead of "true".
