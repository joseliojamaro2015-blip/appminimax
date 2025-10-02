-- =============================================
-- SCRIPT SIMPLIFICADO - CONFIGURAÇÃO SUPABASE APP LG
-- Execute este script COMPLETO no SQL Editor
-- =============================================

-- LIMPAR TUDO E COMEÇAR DO ZERO (use apenas se necessário)
-- DROP TABLE IF EXISTS financial_transactions CASCADE;
-- DROP TABLE IF EXISTS financial_categories CASCADE;
-- DROP TABLE IF EXISTS financial_accounts CASCADE;
-- DROP TABLE IF EXISTS check_ins CASCADE;
-- DROP TABLE IF EXISTS subscriptions CASCADE;
-- DROP TABLE IF EXISTS plans CASCADE;
-- DROP TABLE IF EXISTS clients CASCADE;
-- DROP TABLE IF EXISTS employees CASCADE;
-- DROP TABLE IF EXISTS user_roles CASCADE;
-- DROP TABLE IF EXISTS profiles CASCADE;
-- DROP TABLE IF EXISTS units CASCADE;
-- DROP TABLE IF EXISTS organizations CASCADE;

-- ============= ETAPA 1: EXTENSÕES =============
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============= ETAPA 2: ORGANIZAÇÕES =============
CREATE TABLE IF NOT EXISTS organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    email TEXT,
    phone TEXT,
    address JSONB DEFAULT '{}',
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 3: UNIDADES =============
CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    code TEXT UNIQUE NOT NULL,
    email TEXT,
    phone TEXT,
    address JSONB DEFAULT '{}',
    capacity INTEGER DEFAULT 100,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 4: PERFIS =============
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    phone TEXT,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 5: PERMISSÕES =============
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) NOT NULL,
    organization_id UUID REFERENCES organizations(id),
    unit_id UUID REFERENCES units(id),
    role TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 6: CLIENTES =============
CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    unit_id UUID REFERENCES units(id),
    client_code TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 7: PLANOS =============
CREATE TABLE IF NOT EXISTS plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    duration_days INTEGER NOT NULL,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 8: ASSINATURAS =============
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID REFERENCES clients(id) NOT NULL,
    plan_id UUID REFERENCES plans(id) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_paid DECIMAL(10,2) NOT NULL,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 9: FUNCIONÁRIOS =============
CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    unit_id UUID REFERENCES units(id),
    employee_code TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    position TEXT NOT NULL,
    hire_date DATE NOT NULL,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 10: CONTAS FINANCEIRAS =============
CREATE TABLE IF NOT EXISTS financial_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 11: CATEGORIAS FINANCEIRAS =============
CREATE TABLE IF NOT EXISTS financial_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
    color TEXT DEFAULT '#6B7280',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 12: TRANSAÇÕES FINANCEIRAS =============
CREATE TABLE IF NOT EXISTS financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    account_id UUID REFERENCES financial_accounts(id) NOT NULL,
    category_id UUID REFERENCES financial_categories(id),
    client_id UUID REFERENCES clients(id),
    amount DECIMAL(15,2) NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
    description TEXT NOT NULL,
    transaction_date DATE NOT NULL,
    status TEXT DEFAULT 'completed',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 13: CHECK-INS =============
CREATE TABLE IF NOT EXISTS check_ins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID REFERENCES clients(id) NOT NULL,
    unit_id UUID REFERENCES units(id) NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    check_out_time TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 14: RLS (SEGURANÇA) =============
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;

-- ============= ETAPA 15: POLÍTICAS BÁSICAS =============
CREATE POLICY "Allow authenticated users to view profiles" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Allow authenticated users to update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- ============= ETAPA 16: FUNÇÃO PARA CRIAR PERFIL =============
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (new.id, new.email, new.raw_user_meta_data->>'full_name');
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para criar perfil automaticamente
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ============= ETAPA 17: DADOS INICIAIS =============

-- Criar organização
INSERT INTO organizations (name, slug, email, phone) 
VALUES ('Academia LG', 'academia-lg', 'contato@academialg.com', '(11) 99999-9999')
ON CONFLICT (slug) DO NOTHING;

-- Criar unidade
INSERT INTO units (organization_id, name, code, email, phone)
VALUES (
    (SELECT id FROM organizations WHERE slug = 'academia-lg'),
    'Unidade Centro',
    'UNIT-001',
    'centro@academialg.com',
    '(11) 98888-8888'
) ON CONFLICT (code) DO NOTHING;

-- Criar categorias financeiras
INSERT INTO financial_categories (organization_id, name, type, color) VALUES
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Mensalidades', 'income', '#10B981'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Personal Trainer', 'income', '#3B82F6'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Aluguel', 'expense', '#EF4444'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Energia Elétrica', 'expense', '#F59E0B'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Salários', 'expense', '#8B5CF6')
ON CONFLICT DO NOTHING;

-- Criar planos
INSERT INTO plans (organization_id, name, description, price, duration_days) VALUES
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Mensal', 'Plano mensal básico', 89.90, 30),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Trimestral', 'Plano trimestral', 239.70, 90),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Anual', 'Plano anual', 799.00, 365)
ON CONFLICT DO NOTHING;

-- Criar conta financeira
INSERT INTO financial_accounts (organization_id, name, type) VALUES
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Conta Principal', 'checking'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Dinheiro', 'cash')
ON CONFLICT DO NOTHING;

-- ============= ETAPA 18: ÍNDICES =============
CREATE INDEX IF NOT EXISTS idx_units_org ON units(organization_id);
CREATE INDEX IF NOT EXISTS idx_clients_org ON clients(organization_id);
CREATE INDEX IF NOT EXISTS idx_clients_unit ON clients(unit_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_client ON subscriptions(client_id);
CREATE INDEX IF NOT EXISTS idx_check_ins_client ON check_ins(client_id);
CREATE INDEX IF NOT EXISTS idx_transactions_account ON financial_transactions(account_id);

-- ============= VERIFICAÇÃO FINAL =============
SELECT 
    'CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!' as status,
    (SELECT COUNT(*) FROM organizations) as organizacoes,
    (SELECT COUNT(*) FROM units) as unidades,
    (SELECT COUNT(*) FROM plans) as planos,
    (SELECT COUNT(*) FROM financial_categories) as categorias,
    (SELECT COUNT(*) FROM financial_accounts) as contas;

-- Listar tabelas criadas
SELECT 'Tabela: ' || table_name as tabelas_criadas
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;