-- =============================================
-- SCRIPT DE CORREÇÃO - SUPABASE APP LG
-- Execute apenas se houve erro no script anterior
-- =============================================

-- IMPORTANTE: Este script corrige problemas do script anterior
-- Execute no SQL Editor do Supabase

-- ============= CORRIGIR TABELA financial_categories =============

-- Primeiro, verificar se a tabela existe e dropar se necessário
DROP TABLE IF EXISTS financial_categories CASCADE;

-- Recriar a tabela corretamente
CREATE TABLE financial_categories (
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

-- Verificar se a tabela organizations existe, se não, criar
CREATE TABLE IF NOT EXISTS organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    document_number TEXT UNIQUE,
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

-- Inserir organização de exemplo se não existir
INSERT INTO organizations (name, slug, email, phone, address) 
VALUES (
    'Academia LG',
    'academia-lg',
    'contato@academialg.com',
    '(11) 99999-9999',
    '{"street": "Rua Principal, 123", "city": "São Paulo", "state": "SP", "zip": "01234-567"}'
) ON CONFLICT (slug) DO NOTHING;

-- Agora inserir as categorias financeiras corretamente
INSERT INTO financial_categories (organization_id, name, type, color) VALUES
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Mensalidades', 'income', '#10B981'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Personal Trainer', 'income', '#3B82F6'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Aulas Especiais', 'income', '#8B5CF6'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Produtos', 'income', '#F59E0B'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Aluguel', 'expense', '#EF4444'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Energia Elétrica', 'expense', '#F59E0B'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Água', 'expense', '#06B6D4'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Internet', 'expense', '#8B5CF6'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Salários', 'expense', '#6B7280'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Equipamentos', 'expense', '#F97316'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Manutenção', 'expense', '#84CC16'),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Marketing', 'expense', '#EC4899')
ON CONFLICT DO NOTHING;

-- Verificar se inseriu corretamente
SELECT 'Categorias financeiras criadas com sucesso!' as status, COUNT(*) as total 
FROM financial_categories;

-- ============= COMPLETAR OUTRAS TABELAS SE NECESSÁRIO =============

-- Criar tabela financial_accounts se não existir
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

-- Criar tabela financial_transactions se não existir
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

-- Habilitar RLS
ALTER TABLE financial_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;

-- Criar políticas básicas
CREATE POLICY "Organization financial categories access" ON financial_categories FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_roles 
        WHERE user_id = auth.uid() 
        AND organization_id = financial_categories.organization_id
        AND role IN ('super_admin', 'org_admin', 'unit_manager')
    )
);

CREATE POLICY "Organization financial accounts access" ON financial_accounts FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_roles 
        WHERE user_id = auth.uid() 
        AND organization_id = financial_accounts.organization_id
        AND role IN ('super_admin', 'org_admin', 'unit_manager')
    )
);

CREATE POLICY "Organization financial transactions access" ON financial_transactions FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_roles 
        WHERE user_id = auth.uid() 
        AND organization_id = financial_transactions.organization_id
        AND role IN ('super_admin', 'org_admin', 'unit_manager')
    )
);

-- Inserir conta financeira padrão
INSERT INTO financial_accounts (organization_id, name, type, balance) VALUES
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Conta Corrente Principal', 'checking', 0),
    ((SELECT id FROM organizations WHERE slug = 'academia-lg'), 'Dinheiro em Caixa', 'cash', 0)
ON CONFLICT DO NOTHING;

-- =============================================
-- VERIFICAÇÃO FINAL
-- =============================================

-- Verificar se tudo foi criado corretamente
SELECT 
    'CORREÇÃO CONCLUÍDA!' as status,
    (SELECT COUNT(*) FROM organizations) as organizacoes,
    (SELECT COUNT(*) FROM financial_categories) as categorias,
    (SELECT COUNT(*) FROM financial_accounts) as contas;

-- Listar todas as tabelas criadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;

SELECT 'SCRIPT DE CORREÇÃO EXECUTADO COM SUCESSO!' as resultado;