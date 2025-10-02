-- =============================================
-- SCRIPT UNIFICADO - CONFIGURAÇÃO SUPABASE APP LG
-- EXECUTE ESTE SCRIPT COMPLETO NO SQL EDITOR
-- =============================================

-- IMPORTANTE: Execute este script no SQL Editor do Supabase
-- Dashboard > SQL Editor > New Query > Cole todo este código > Run

-- ============= ETAPA 1: HABILITAR EXTENSÕES =============
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============= ETAPA 2: ORGANIZAÇÕES (MATRIZ) =============
CREATE TABLE IF NOT EXISTS organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    document_number TEXT UNIQUE, -- CNPJ
    email TEXT,
    phone TEXT,
    address JSONB DEFAULT '{}',
    business_hours JSONB DEFAULT '{}',
    logo_url TEXT,
    settings JSONB DEFAULT '{}',
    timezone TEXT DEFAULT 'America/Sao_Paulo',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 3: UNIDADES/ACADEMIAS =============
CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    code TEXT UNIQUE NOT NULL,
    document_number TEXT, -- CNPJ da filial
    email TEXT,
    phone TEXT,
    address JSONB DEFAULT '{}',
    coordinates POINT,
    capacity INTEGER DEFAULT 100,
    amenities JSONB DEFAULT '[]',
    business_hours JSONB DEFAULT '{}',
    manager_id UUID, -- será preenchido depois
    settings JSONB DEFAULT '{}',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 4: PERFIS DE USUÁRIOS =============
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY, -- referencia auth.users.id
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    phone TEXT,
    document_number TEXT,
    birth_date DATE,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    address JSONB DEFAULT '{}',
    emergency_contact JSONB DEFAULT '{}',
    medical_info JSONB DEFAULT '{}',
    preferences JSONB DEFAULT '{}',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    approved BOOLEAN DEFAULT false,
    approved_by UUID REFERENCES profiles(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 5: SISTEMA DE PERMISSÕES =============
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) NOT NULL,
    organization_id UUID REFERENCES organizations(id),
    unit_id UUID REFERENCES units(id),
    role TEXT NOT NULL CHECK (role IN ('super_admin', 'org_admin', 'unit_manager', 'employee', 'member')),
    permissions JSONB DEFAULT '[]',
    granted_by UUID REFERENCES profiles(id),
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 6: CLIENTES =============
CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    unit_id UUID REFERENCES units(id),
    client_code TEXT UNIQUE NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    referral_source TEXT,
    goals JSONB DEFAULT '[]',
    medical_clearance BOOLEAN DEFAULT false,
    emergency_contact JSONB DEFAULT '{}',
    photo_url TEXT,
    notes TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'pending')),
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
    benefits JSONB DEFAULT '[]',
    restrictions JSONB DEFAULT '{}',
    max_units INTEGER, -- null = todas as unidades
    is_promotional BOOLEAN DEFAULT false,
    valid_from DATE,
    valid_until DATE,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 8: ASSINATURAS =============
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID REFERENCES clients(id) NOT NULL,
    plan_id UUID REFERENCES plans(id) NOT NULL,
    unit_id UUID REFERENCES units(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_paid DECIMAL(10,2) NOT NULL,
    payment_method TEXT,
    auto_renew BOOLEAN DEFAULT false,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'cancelled', 'expired')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 9: SISTEMA FINANCEIRO =============
CREATE TABLE IF NOT EXISTS financial_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    unit_id UUID REFERENCES units(id),
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('checking', 'savings', 'credit_card', 'cash', 'investment')),
    balance DECIMAL(15,2) DEFAULT 0,
    currency TEXT DEFAULT 'BRL',
    bank_info JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS financial_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
    parent_id UUID REFERENCES financial_categories(id),
    color TEXT DEFAULT '#6B7280',
    icon TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    unit_id UUID REFERENCES units(id),
    account_id UUID REFERENCES financial_accounts(id) NOT NULL,
    category_id UUID REFERENCES financial_categories(id),
    client_id UUID REFERENCES clients(id),
    subscription_id UUID REFERENCES subscriptions(id),
    amount DECIMAL(15,2) NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
    description TEXT NOT NULL,
    transaction_date DATE NOT NULL,
    payment_method TEXT,
    reference_number TEXT,
    notes TEXT,
    tags JSONB DEFAULT '[]',
    attachments JSONB DEFAULT '[]',
    status TEXT DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'cancelled')),
    created_by UUID REFERENCES profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 10: CHECK-INS =============
CREATE TABLE IF NOT EXISTS check_ins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID REFERENCES clients(id) NOT NULL,
    unit_id UUID REFERENCES units(id) NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    check_out_time TIMESTAMP WITH TIME ZONE,
    method TEXT DEFAULT 'manual' CHECK (method IN ('manual', 'qr_code', 'rfid', 'biometric')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 11: FUNCIONÁRIOS =============
CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) NOT NULL,
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    unit_id UUID REFERENCES units(id),
    employee_code TEXT UNIQUE NOT NULL,
    department TEXT NOT NULL,
    position TEXT NOT NULL,
    hire_date DATE NOT NULL,
    salary_info JSONB DEFAULT '{}',
    certifications JSONB DEFAULT '[]',
    documents JSONB DEFAULT '[]',
    schedule JSONB DEFAULT '{}',
    supervisor_id UUID REFERENCES employees(id),
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'vacation', 'sick_leave')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 12: RLS (ROW LEVEL SECURITY) =============

-- Habilitar RLS em todas as tabelas
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- Políticas básicas (usuários podem ver seus próprios dados)
CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Políticas para organizações (admins podem ver tudo de sua organização)
CREATE POLICY "Organization access" ON organizations FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_roles 
        WHERE user_id = auth.uid() 
        AND organization_id = organizations.id
        AND role IN ('super_admin', 'org_admin')
    )
);

-- ============= ETAPA 13: FUNÇÃO PARA CRIAR PERFIL AUTOMATICAMENTE =============
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (new.id, new.email, new.raw_user_meta_data->>'full_name');
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para criar perfil quando usuário se registra
CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ============= ETAPA 14: DADOS INICIAIS (OPCIONAL) =============

-- Organização de exemplo
INSERT INTO organizations (name, slug, email, phone, address) 
VALUES (
    'Academia LG',
    'academia-lg',
    'contato@academialg.com',
    '(11) 99999-9999',
    '{"street": "Rua Principal, 123", "city": "São Paulo", "state": "SP", "zip": "01234-567"}'
) ON CONFLICT (slug) DO NOTHING;

-- Unidade de exemplo
INSERT INTO units (organization_id, name, code, email, phone, address, capacity)
VALUES (
    (SELECT id FROM organizations WHERE slug = 'academia-lg'),
    'Unidade Centro',
    'UNIT-001',
    'centro@academialg.com',
    '(11) 98888-8888',
    '{"street": "Rua do Centro, 456", "city": "São Paulo", "state": "SP", "zip": "01234-888"}',
    150
) ON CONFLICT (code) DO NOTHING;

-- Categorias financeiras básicas
INSERT INTO financial_categories (organization_id, name, type, color) VALUES
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Mensalidades', 'income', '#10B981'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Personal Trainer', 'income', '#3B82F6'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Aluguel', 'expense', '#EF4444'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Energia Elétrica', 'expense', '#F59E0B'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Salários', 'expense', '#8B5CF6')
ON CONFLICT DO NOTHING;

-- Planos básicos
INSERT INTO plans (organization_id, name, description, price, duration_days) VALUES
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Mensal', 'Plano mensal básico', 89.90, 30),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Trimestral', 'Plano trimestral com desconto', 239.70, 90),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Anual', 'Plano anual com maior desconto', 799.00, 365)
ON CONFLICT DO NOTHING;

-- ============= FINALIZAÇÃO =============
-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_units_organization_id ON units(organization_id);
CREATE INDEX IF NOT EXISTS idx_clients_organization_id ON clients(organization_id);
CREATE INDEX IF NOT EXISTS idx_clients_unit_id ON clients(unit_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_client_id ON subscriptions(client_id);
CREATE INDEX IF NOT EXISTS idx_check_ins_client_id ON check_ins(client_id);
CREATE INDEX IF NOT EXISTS idx_check_ins_unit_id ON check_ins(unit_id);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_account_id ON financial_transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);

-- Atualizar função de updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger de updated_at em tabelas relevantes
CREATE TRIGGER update_organizations_updated_at BEFORE UPDATE ON organizations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON units
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_plans_updated_at BEFORE UPDATE ON plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!
-- =============================================

-- RESULTADO ESPERADO:
-- ✅ 12+ tabelas criadas
-- ✅ RLS habilitado e configurado
-- ✅ Triggers e funções criadas
-- ✅ Índices para performance
-- ✅ Dados iniciais inseridos
-- ✅ Sistema pronto para uso!

SELECT 'CONFIGURAÇÃO SUPABASE CONCLUÍDA COM SUCESSO!' as status;