-- Bitácora EAP · esquema para Supabase
-- Pegar completo en: Supabase > SQL Editor > New query > Run

create table if not exists public.psicologos (
  id             text primary key default gen_random_uuid()::text,
  nombre         text not null,
  profesion      text not null default '',
  telefono       text not null default '',
  activo         boolean not null default true,
  banco         text not null default '',
  tipo_cuenta    text not null default '',
  numero_cuenta  text not null default '',
  rut            text not null default '',
  email          text not null default '',
  creado_en      timestamptz not null default now()
);

create table if not exists public.empresas (
  id         text primary key default gen_random_uuid()::text,
  nombre     text not null,
  activo     boolean not null default true,
  creado_en  timestamptz not null default now()
);

create table if not exists public.pacientes (
  id              text primary key default gen_random_uuid()::text,
  nombre          text not null,
  empresa_id      text,
  empresa_nombre  text not null default '',
  activo          boolean not null default true,
  creado_en       timestamptz not null default now()
);

create table if not exists public.atenciones (
  id               text primary key default gen_random_uuid()::text,
  psicologo_id     text,
  psicologo_nombre text not null default '',
  fecha            date not null,
  hora             text not null default '',
  empresa_id       text,
  empresa_nombre   text not null default '',
  paciente_id      text,
  paciente_nombre  text not null default '',
  creado_en        timestamptz not null default now()
);

create table if not exists public.tarifas (
  id            text primary key default gen_random_uuid()::text,
  psicologo_id  text not null,
  tarifa        numeric not null default 0,
  tipo          text not null default 'clp' check (tipo in ('clp', 'uf')),
  vigente_desde date not null,
  creado_en     timestamptz not null default now()
);

create table if not exists public.config (
  id             text primary key,
  retencion_pct  numeric not null default 0,
  moneda         text not null default '$',
  valor_uf       numeric not null default 0,
  emisor         text not null default ''
);

-- Para bases creadas con una versión anterior de este archivo:
alter table public.psicologos add column if not exists profesion text not null default '';

insert into public.config (id) values ('general') on conflict (id) do nothing;

create index if not exists atenciones_fecha_idx      on public.atenciones (fecha);
create index if not exists atenciones_psicologo_idx  on public.atenciones (psicologo_id);
create index if not exists pacientes_empresa_idx     on public.pacientes (empresa_id);
create index if not exists tarifas_psicologo_idx     on public.tarifas (psicologo_id);

-- Seguridad: solo usuarios con sesión iniciada pueden leer y escribir.
-- Sin sesión (anon) no se ve nada.
do $$
declare t text;
begin
  foreach t in array array['psicologos','empresas','pacientes','atenciones','tarifas','config']
  loop
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "equipo accede" on public.%I', t);
    execute format('create policy "equipo accede" on public.%I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

-- Actualización en vivo entre computadores
do $$
declare t text;
begin
  foreach t in array array['psicologos','empresas','pacientes','atenciones','tarifas','config']
  loop
    begin
      execute format('alter publication supabase_realtime add table public.%I', t);
    exception when duplicate_object then null;
    end;
  end loop;
end $$;
