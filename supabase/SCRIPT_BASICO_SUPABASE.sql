-- APP LG - Script Básico para Supabase
-- Execute este script no SQL Editor do Supabase

-- Deletar tabelas se existirem (para recomeçar limpo)
drop table if exists memberships cascade;
drop table if exists financial_transactions cascade;
drop table if exists financial_accounts cascade;
drop table if exists financial_categories cascade;
drop table if exists contracts cascade;
drop table if exists plans cascade;
drop table if exists clients cascade;
drop table if exists units cascade;
drop table if exists branches cascade;
drop table if exists user_roles cascade;
drop table if exists users cascade;
drop table if exists organizations cascade;

-- Criar tabela organizations
create table organizations (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    slug text not null unique,
    email text,
    phone text,
    address text,
    city text,
    state text,
    zip_code text,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela users
create table users (
    id uuid primary key default gen_random_uuid(),
    email text unique not null,
    name text not null,
    phone text,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela user_roles
create table user_roles (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) not null,
    organization_id uuid references organizations(id) not null,
    role text not null check (role in ('admin', 'manager', 'staff', 'trainee')),
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela branches
create table branches (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    name text not null,
    code text not null,
    address text,
    city text,
    state text,
    zip_code text,
    phone text,
    email text,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela units
create table units (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    branch_id uuid references branches(id) not null,
    name text not null,
    capacity integer,
    floor integer,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela clients
create table clients (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    branch_id uuid references branches(id) not null,
    name text not null,
    email text,
    phone text,
    cpf text,
    birth_date date,
    address text,
    city text,
    state text,
    zip_code text,
    emergency_contact text,
    emergency_phone text,
    medical_notes text,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela plans
create table plans (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    name text not null,
    description text,
    price decimal(10,2) not null,
    duration_months integer not null,
    max_units integer,
    features jsonb,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela contracts
create table contracts (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    client_id uuid references clients(id) not null,
    plan_id uuid references plans(id) not null,
    start_date date not null,
    end_date date not null,
    monthly_value decimal(10,2) not null,
    discount decimal(5,2) default 0,
    status text not null default 'active' check (status in ('active', 'suspended', 'cancelled')),
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela financial_categories
create table financial_categories (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    name text not null,
    type text not null check (type in ('income', 'expense')),
    color text,
    description text,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela financial_accounts
create table financial_accounts (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    name text not null,
    type text not null check (type in ('checking', 'savings', 'cash', 'investment')),
    bank_name text,
    account_number text,
    balance decimal(15,2) default 0,
    is_active boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela financial_transactions
create table financial_transactions (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    account_id uuid references financial_accounts(id) not null,
    category_id uuid references financial_categories(id) not null,
    contract_id uuid references contracts(id),
    description text not null,
    amount decimal(15,2) not null,
    transaction_date date not null,
    type text not null check (type in ('income', 'expense')),
    payment_method text,
    reference_number text,
    notes text,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Criar tabela memberships
create table memberships (
    id uuid primary key default gen_random_uuid(),
    organization_id uuid references organizations(id) not null,
    client_id uuid references clients(id) not null,
    unit_id uuid references units(id) not null,
    contract_id uuid references contracts(id) not null,
    start_date date not null,
    end_date date,
    status text not null default 'active' check (status in ('active', 'suspended', 'cancelled')),
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

-- Inserir organização (usando apenas a primeira coluna por vez para evitar tradução)
insert into organizations (name, slug) values ('Academia LG', 'academia-lg');
update organizations set email = 'contato@academialg.com' where slug = 'academia-lg';
update organizations set phone = '(11) 99999-9999' where slug = 'academia-lg';
update organizations set address = 'Rua das Academias, 123' where slug = 'academia-lg';
update organizations set city = 'São Paulo' where slug = 'academia-lg';
update organizations set state = 'SP' where slug = 'academia-lg';
update organizations set zip_code = '01234-567' where slug = 'academia-lg';

-- Inserir usuário
insert into users (email, name, phone) values ('admin@academialg.com', 'Administrador LG', '(11) 98888-8888');

-- Inserir role
insert into user_roles (user_id, organization_id, role) 
select u.id, o.id, 'admin' 
from users u, organizations o 
where u.email = 'admin@academialg.com' and o.slug = 'academia-lg';

-- Inserir filial
insert into branches (organization_id, name, code) 
select id, 'Filial Centro', 'FIL001' 
from organizations where slug = 'academia-lg';

update branches set address = 'Rua Central, 456' where code = 'FIL001';
update branches set city = 'São Paulo' where code = 'FIL001';
update branches set state = 'SP' where code = 'FIL001';
update branches set zip_code = '01234-567' where code = 'FIL001';
update branches set phone = '(11) 97777-7777' where code = 'FIL001';
update branches set email = 'centro@academialg.com' where code = 'FIL001';

-- Inserir unidades
insert into units (organization_id, branch_id, name, capacity, floor)
select o.id, b.id, 'Sala de Musculação', 50, 1
from organizations o, branches b 
where o.slug = 'academia-lg' and b.code = 'FIL001';

insert into units (organization_id, branch_id, name, capacity, floor)
select o.id, b.id, 'Sala de Cardio', 30, 1
from organizations o, branches b 
where o.slug = 'academia-lg' and b.code = 'FIL001';

insert into units (organization_id, branch_id, name, capacity, floor)
select o.id, b.id, 'Estúdio de Dança', 20, 2
from organizations o, branches b 
where o.slug = 'academia-lg' and b.code = 'FIL001';

-- Inserir planos
insert into plans (organization_id, name, description, price, duration_months, max_units)
select id, 'Plano Básico', 'Acesso à musculação e cardio', 89.90, 1, 2
from organizations where slug = 'academia-lg';

insert into plans (organization_id, name, description, price, duration_months)
select id, 'Plano Premium', 'Acesso completo a todas as unidades', 149.90, 1
from organizations where slug = 'academia-lg';

insert into plans (organization_id, name, description, price, duration_months)
select id, 'Plano Anual', 'Plano anual com desconto', 99.90, 12
from organizations where slug = 'academia-lg';

-- Inserir categorias financeiras
insert into financial_categories (organization_id, name, type, color)
select id, 'Mensalidades', 'income', '#4CAF50'
from organizations where slug = 'academia-lg';

insert into financial_categories (organization_id, name, type, color)
select id, 'Vendas de Produtos', 'income', '#2196F3'
from organizations where slug = 'academia-lg';

insert into financial_categories (organization_id, name, type, color)
select id, 'Aluguel', 'expense', '#F44336'
from organizations where slug = 'academia-lg';

insert into financial_categories (organization_id, name, type, color)
select id, 'Energia Elétrica', 'expense', '#FF9800'
from organizations where slug = 'academia-lg';

insert into financial_categories (organization_id, name, type, color)
select id, 'Salários', 'expense', '#9C27B0'
from organizations where slug = 'academia-lg';

insert into financial_categories (organization_id, name, type, color)
select id, 'Manutenção', 'expense', '#607D8B'
from organizations where slug = 'academia-lg';

-- Inserir contas financeiras
insert into financial_accounts (organization_id, name, type, balance)
select id, 'Conta Principal Banco do Brasil', 'checking', 15000.00
from organizations where slug = 'academia-lg';

insert into financial_accounts (organization_id, name, type, balance)
select id, 'Dinheiro em Espécie', 'cash', 2500.00
from organizations where slug = 'academia-lg';

insert into financial_accounts (organization_id, name, type, balance)
select id, 'Poupança', 'savings', 50000.00
from organizations where slug = 'academia-lg';

-- Ativar RLS (Row Level Security)
alter table organizations enable row level security;
alter table users enable row level security;
alter table user_roles enable row level security;
alter table branches enable row level security;
alter table units enable row level security;
alter table clients enable row level security;
alter table plans enable row level security;
alter table contracts enable row level security;
alter table financial_categories enable row level security;
alter table financial_accounts enable row level security;
alter table financial_transactions enable row level security;
alter table memberships enable row level security;

-- Verificação final - mostrar contagem de registros
select 'organizations' as tabela, count(*) as registros from organizations
union all
select 'users' as tabela, count(*) as registros from users
union all
select 'branches' as tabela, count(*) as registros from branches
union all
select 'units' as tabela, count(*) as registros from units
union all
select 'plans' as tabela, count(*) as registros from plans
union all
select 'financial_categories' as tabela, count(*) as registros from financial_categories
union all
select 'financial_accounts' as tabela, count(*) as registros from financial_accounts;
