-- =====================================
-- SCRIPT SUPABASE FINAL CORRIGIDO
-- APP LG System - Configuração Completa
-- =====================================

-- Limpar dados existentes se necessário
DO $$ 
BEGIN
    -- Deletar dados em ordem para evitar conflitos de referência
    DELETE FROM financial_transactions;
    DELETE FROM financial_categories;
    DELETE FROM financial_accounts;
    DELETE FROM plans;
    DELETE FROM memberships;
    DELETE FROM contracts;
    DELETE FROM clients;
    DELETE FROM units;
    DELETE FROM branches;
    DELETE FROM user_roles;
    DELETE FROM organizations;
    DELETE FROM users;
    
    RAISE NOTICE 'Dados existentes removidos com sucesso';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro ao remover dados existentes: %', SQLERRM;
END $$;

-- ============= ETAPA 1: ORGANIZAÇÕES =============
CREATE TABLE IF NOT EXISTS organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    email TEXT,
    phone TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 2: USUÁRIOS =============
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 3: ROLES DE USUÁRIOS =============
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) NOT NULL,
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('admin', 'manager', 'staff', 'trainee')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 4: FILIAIS =============
CREATE TABLE IF NOT EXISTS branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    phone TEXT,
    email TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 5: UNIDADES =============
CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    branch_id UUID REFERENCES branches(id) NOT NULL,
    name TEXT NOT NULL,
    capacity INTEGER,
    floor INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 6: CLIENTES =============
CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    branch_id UUID REFERENCES branches(id) NOT NULL,
    name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    cpf TEXT,
    birth_date DATE,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    emergency_contact TEXT,
    emergency_phone TEXT,
    medical_notes TEXT,
    is_active BOOLEAN DEFAULT true,
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
    duration_months INTEGER NOT NULL,
    max_units INTEGER,
    features JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 8: CONTRATOS =============
CREATE TABLE IF NOT EXISTS contracts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    client_id UUID REFERENCES clients(id) NOT NULL,
    plan_id UUID REFERENCES plans(id) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    monthly_value DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 9: CATEGORIAS FINANCEIRAS =============
CREATE TABLE IF NOT EXISTS financial_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
    color TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 10: CONTAS FINANCEIRAS =============
CREATE TABLE IF NOT EXISTS financial_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('checking', 'savings', 'cash', 'investment')),
    bank_name TEXT,
    account_number TEXT,
    balance DECIMAL(15,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 11: TRANSAÇÕES FINANCEIRAS =============
CREATE TABLE IF NOT EXISTS financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    account_id UUID REFERENCES financial_accounts(id) NOT NULL,
    category_id UUID REFERENCES financial_categories(id) NOT NULL,
    contract_id UUID REFERENCES contracts(id),
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date DATE NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
    payment_method TEXT,
    reference_number TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 12: MEMBERSHIPS =============
CREATE TABLE IF NOT EXISTS memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id) NOT NULL,
    client_id UUID REFERENCES clients(id) NOT NULL,
    unit_id UUID REFERENCES units(id) NOT NULL,
    contract_id UUID REFERENCES contracts(id) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= ETAPA 13: INSERIR DADOS INICIAIS =============

-- Inserir organização
INSERT INTO organizations (name, slug, email, phone, address, city, state, zip_code) VALUES
('Academia LG', 'academia-lg', 'contato@academialg.com', '(11) 99999-9999', 'Rua das Academias, 123', 'São Paulo', 'SP', '01234-567')
ON CONFLICT (slug) DO UPDATE SET 
    name = EXCLUDED.name,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    city = EXCLUDED.city,
    state = EXCLUDED.state,
    zip_code = EXCLUDED.zip_code;

-- Inserir usuário administrador
INSERT INTO users (email, name, phone) VALUES
('admin@academialg.com', 'Administrador LG', '(11) 98888-8888')
ON CONFLICT (email) DO UPDATE SET 
    name = EXCLUDED.name,
    phone = EXCLUDED.phone;

-- Inserir role de admin
INSERT INTO user_roles (user_id, organization_id, role) VALUES
((SELECT id FROM users WHERE email = 'admin@academialg.com'), (SELECT id FROM organizations WHERE slug = 'academia-lg'), 'admin')
ON CONFLICT DO NOTHING;

-- Inserir filial
INSERT INTO branches (organization_id, name, code, address, city, state, zip_code, phone, email) VALUES
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Filial Centro', 'FIL001', 'Rua Central, 456', 'São Paulo', 'SP', '01234-567', '(11) 97777-7777', 'centro@academialg.com')
ON CONFLICT DO NOTHING;

-- Inserir unidades
INSERT INTO units (organization_id, branch_id, name, capacity, floor) VALUES
((SELECT id FROM organizations WHERE slug = 'academia-lg'), (SELECT id FROM branches WHERE code = 'FIL001'), 'Sala de Musculação', 50, 1),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), (SELECT id FROM branches WHERE code = 'FIL001'), 'Sala de Cardio', 30, 1),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), (SELECT id FROM branches WHERE code = 'FIL001'), 'Estúdio de Dança', 20, 2)
ON CONFLICT DO NOTHING;

-- Inserir planos
INSERT INTO plans (organization_id, name, description, price, duration_months, max_units) VALUES
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Plano Básico', 'Acesso à musculação e cardio', 89.90, 1, 2),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Plano Premium', 'Acesso completo a todas as unidades', 149.90, 1, NULL),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Plano Anual', 'Plano anual com desconto', 99.90, 12, NULL)
ON CONFLICT DO NOTHING;

-- Inserir categorias financeiras
INSERT INTO financial_categories (organization_id, name, type, color) VALUES
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Mensalidades', 'income', '#4CAF50'),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Vendas de Produtos', 'income', '#2196F3'),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Aluguel', 'expense', '#F44336'),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Energia Elétrica', 'expense', '#FF9800'),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Salários', 'expense', '#9C27B0'),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Manutenção', 'expense', '#607D8B')
ON CONFLICT DO NOTHING;

-- Inserir contas financeiras
INSERT INTO financial_accounts (organization_id, name, type, balance) VALUES
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Conta Principal Banco do Brasil', 'checking', 15000.00),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Dinheiro em Espécie', 'cash', 2500.00),
((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Poupança', 'savings', 50000.00)
ON CONFLICT DO NOTHING;

-- ============= ETAPA 14: CONFIGURAR RLS (ROW LEVEL SECURITY) =============
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE memberships ENABLE ROW LEVEL SECURITY;

-- ============= ETAPA 15: POLÍTICAS RLS =============
-- Política para organizações (usuários só veem suas organizações)
CREATE POLICY "User organization access" ON organizations FOR ALL USING (
    id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

-- Política geral para tabelas com organization_id
CREATE POLICY "Organization data access" ON branches FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON units FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON clients FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON plans FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON contracts FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON financial_categories FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON financial_accounts FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON financial_transactions FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

CREATE POLICY "Organization data access" ON memberships FOR ALL USING (
    organization_id IN (
        SELECT organization_id FROM user_roles 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

-- ============= ETAPA 16: ÍNDICES PARA PERFORMANCE =============
CREATE INDEX IF NOT EXISTS idx_units_org ON units(organization_id);
CREATE INDEX IF NOT EXISTS idx_clients_org ON clients(organization_id);
CREATE INDEX IF NOT EXISTS idx_branches_org ON branches(organization_id);
CREATE INDEX IF NOT EXISTS idx_plans_org ON plans(organization_id);
CREATE INDEX IF NOT EXISTS idx_contracts_org ON contracts(organization_id);
CREATE INDEX IF NOT EXISTS idx_financial_categories_org ON financial_categories(organization_id);
CREATE INDEX IF NOT EXISTS idx_financial_accounts_org ON financial_accounts(organization_id);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_org ON financial_transactions(organization_id);
CREATE INDEX IF NOT EXISTS idx_memberships_org ON memberships(organization_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_user ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_org ON user_roles(organization_id);

-- ============= VERIFICAÇÃO FINAL =============
DO $$ 
BEGIN
    RAISE NOTICE '============= VERIFICAÇÃO DO BANCO =============';
    RAISE NOTICE 'Organizações: %', (SELECT COUNT(*) FROM organizations);
    RAISE NOTICE 'Usuários: %', (SELECT COUNT(*) FROM users);
    RAISE NOTICE 'Filiais: %', (SELECT COUNT(*) FROM branches);
    RAISE NOTICE 'Unidades: %', (SELECT COUNT(*) FROM units);
    RAISE NOTICE 'Planos: %', (SELECT COUNT(*) FROM plans);
    RAISE NOTICE 'Categorias Financeiras: %', (SELECT COUNT(*) FROM financial_categories);
    RAISE NOTICE 'Contas Financeiras: %', (SELECT COUNT(*) FROM financial_accounts);
    RAISE NOTICE '============= CONFIGURAÇÃO CONCLUÍDA =============';
END $$;
