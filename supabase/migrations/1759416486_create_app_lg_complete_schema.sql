-- Migration: create_app_lg_complete_schema
-- Created at: 1759416486

-- =============================================
-- SISTEMA EMPRESARIAL APP LG - SCHEMA COMPLETO
-- =============================================

-- ============= TABELAS CORE (SISTEMA) =============

-- Empresas/Organizações (MATRIZ)
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

-- Filiais/Unidades
CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
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
    manager_id UUID, -- referencia profiles.id
    settings JSONB DEFAULT '{}',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Perfis de usuários (extende auth.users)
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
    approved_by UUID, -- referencia profiles.id
    approved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sistema de permissões (RBAC)
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    organization_id UUID, -- referencia organizations.id
    unit_id UUID, -- referencia units.id
    role TEXT NOT NULL CHECK (role IN ('super_admin', 'org_admin', 'unit_manager', 'employee', 'member')),
    permissions JSONB DEFAULT '[]',
    granted_by UUID, -- referencia profiles.id
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= TABELAS DE CADASTROS =============

-- Funcionários
CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    organization_id UUID NOT NULL, -- referencia organizations.id
    unit_id UUID, -- referencia units.id
    employee_code TEXT UNIQUE NOT NULL,
    department TEXT NOT NULL,
    position TEXT NOT NULL,
    hire_date DATE NOT NULL,
    salary_info JSONB DEFAULT '{}', -- dados criptografados
    certifications JSONB DEFAULT '[]',
    documents JSONB DEFAULT '[]',
    schedule JSONB DEFAULT '{}',
    supervisor_id UUID, -- referencia employees.id
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'vacation', 'sick_leave')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Fornecedores
CREATE TABLE IF NOT EXISTS suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    document_number TEXT UNIQUE NOT NULL,
    contact_info JSONB DEFAULT '{}',
    category TEXT,
    payment_terms JSONB DEFAULT '{}',
    contract_details JSONB DEFAULT '{}',
    evaluation JSONB DEFAULT '{}',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Empresas Parceiras (Corporativos)
CREATE TABLE IF NOT EXISTS partner_companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    document_number TEXT UNIQUE NOT NULL,
    contact_info JSONB DEFAULT '{}',
    contract_details JSONB DEFAULT '{}',
    benefits JSONB DEFAULT '[]',
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= MÓDULO ACADEMIAS =============

-- Academias da Rede (Reciprocidade)
CREATE TABLE IF NOT EXISTS partner_gyms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    address JSONB DEFAULT '{}',
    contact_info JSONB DEFAULT '{}',
    amenities JSONB DEFAULT '[]',
    reciprocity_terms JSONB DEFAULT '{}',
    evaluation JSONB DEFAULT '{}',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Matrículas
CREATE TABLE IF NOT EXISTS memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    organization_id UUID NOT NULL, -- referencia organizations.id
    unit_id UUID NOT NULL, -- referencia units.id
    membership_number TEXT UNIQUE NOT NULL,
    plan_id UUID NOT NULL, -- referencia plans.id
    start_date DATE NOT NULL,
    end_date DATE,
    status TEXT DEFAULT 'active' CHECK (status IN ('pending', 'active', 'suspended', 'cancelled', 'expired')),
    documents JSONB DEFAULT '[]',
    emergency_contact JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Check-ins
CREATE TABLE IF NOT EXISTS check_ins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    unit_id UUID NOT NULL, -- referencia units.id
    membership_id UUID, -- referencia memberships.id
    check_in_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    check_out_at TIMESTAMP WITH TIME ZONE,
    duration INTERVAL,
    activities JSONB DEFAULT '[]',
    notes TEXT,
    validated_by UUID, -- referencia employees.id
    ip_address INET,
    geolocation POINT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Avaliações Físicas
CREATE TABLE IF NOT EXISTS physical_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    assessor_id UUID NOT NULL, -- referencia employees.id
    unit_id UUID NOT NULL, -- referencia units.id
    assessment_date DATE NOT NULL,
    measurements JSONB DEFAULT '{}', -- peso, altura, bf%, etc.
    photos JSONB DEFAULT '[]',
    goals JSONB DEFAULT '[]',
    recommendations TEXT,
    next_assessment_date DATE,
    status TEXT DEFAULT 'completed' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Avaliações Nutricionais
CREATE TABLE IF NOT EXISTS nutritional_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    nutritionist_id UUID NOT NULL, -- referencia employees.id
    unit_id UUID NOT NULL, -- referencia units.id
    assessment_date DATE NOT NULL,
    dietary_restrictions JSONB DEFAULT '[]',
    food_preferences JSONB DEFAULT '[]',
    meal_plan JSONB DEFAULT '{}',
    caloric_needs INTEGER,
    supplements JSONB DEFAULT '[]',
    notes TEXT,
    next_assessment_date DATE,
    status TEXT DEFAULT 'completed' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= MÓDULO FINANCEIRO =============

-- Planos de Assinatura
CREATE TABLE IF NOT EXISTS plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL CHECK (type IN ('individual', 'corporate', 'family', 'student')),
    price_cents INTEGER NOT NULL,
    billing_cycle TEXT NOT NULL CHECK (billing_cycle IN ('monthly', 'quarterly', 'annual')),
    features JSONB DEFAULT '[]',
    limits JSONB DEFAULT '{}',
    trial_days INTEGER DEFAULT 0,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'archived')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Categorias Financeiras
CREATE TABLE IF NOT EXISTS financial_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
    code TEXT NOT NULL,
    parent_id UUID, -- referencia financial_categories.id
    color_code TEXT,
    sort_order INTEGER DEFAULT 0,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Contas Financeiras
CREATE TABLE IF NOT EXISTS financial_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('checking', 'savings', 'credit_card', 'cash')),
    bank_info JSONB DEFAULT '{}',
    current_balance_cents INTEGER DEFAULT 0,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'closed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transações Financeiras
CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    membership_id UUID, -- referencia memberships.id
    user_id UUID, -- referencia profiles.id
    category_id UUID, -- referencia financial_categories.id
    account_id UUID, -- referencia financial_accounts.id
    type TEXT NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
    amount_cents INTEGER NOT NULL,
    description TEXT NOT NULL,
    reference_id TEXT,
    payment_method TEXT,
    payment_gateway TEXT,
    gateway_transaction_id TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'cancelled', 'refunded')),
    processed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= MÓDULO VENDAS =============

-- Produtos/Serviços
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL CHECK (type IN ('product', 'service', 'plan')),
    sku TEXT UNIQUE,
    price_cents INTEGER NOT NULL,
    cost_cents INTEGER,
    stock_quantity INTEGER DEFAULT 0,
    min_stock_level INTEGER DEFAULT 0,
    images JSONB DEFAULT '[]',
    specifications JSONB DEFAULT '{}',
    category TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'discontinued')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Propostas/Orçamentos
CREATE TABLE IF NOT EXISTS proposals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    customer_id UUID NOT NULL, -- referencia profiles.id
    salesperson_id UUID, -- referencia employees.id
    proposal_number TEXT UNIQUE NOT NULL,
    items JSONB DEFAULT '[]',
    total_amount_cents INTEGER NOT NULL,
    discount_amount_cents INTEGER DEFAULT 0,
    tax_amount_cents INTEGER DEFAULT 0,
    valid_until DATE,
    notes TEXT,
    terms_conditions TEXT,
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'accepted', 'rejected', 'expired')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vendas
CREATE TABLE IF NOT EXISTS sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    customer_id UUID NOT NULL, -- referencia profiles.id
    salesperson_id UUID, -- referencia employees.id
    proposal_id UUID, -- referencia proposals.id
    sale_number TEXT UNIQUE NOT NULL,
    items JSONB DEFAULT '[]',
    total_amount_cents INTEGER NOT NULL,
    discount_amount_cents INTEGER DEFAULT 0,
    tax_amount_cents INTEGER DEFAULT 0,
    payment_method TEXT,
    payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'partial', 'failed', 'refunded')),
    notes TEXT,
    sale_date DATE DEFAULT CURRENT_DATE,
    status TEXT DEFAULT 'completed' CHECK (status IN ('draft', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= MÓDULO CASHBACK =============

-- Regras de Cashback
CREATE TABLE IF NOT EXISTS cashback_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    name TEXT NOT NULL,
    description TEXT,
    category TEXT,
    percentage DECIMAL(5,2) NOT NULL,
    min_amount_cents INTEGER DEFAULT 0,
    max_amount_cents INTEGER,
    conditions JSONB DEFAULT '{}',
    valid_from DATE NOT NULL,
    valid_until DATE,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Créditos de Cashback
CREATE TABLE IF NOT EXISTS cashback_credits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    organization_id UUID NOT NULL, -- referencia organizations.id
    rule_id UUID NOT NULL, -- referencia cashback_rules.id
    transaction_id UUID, -- referencia transactions.id
    earned_amount_cents INTEGER NOT NULL,
    description TEXT,
    earned_date DATE DEFAULT CURRENT_DATE,
    expires_at DATE,
    status TEXT DEFAULT 'earned' CHECK (status IN ('earned', 'redeemed', 'expired', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Resgates de Cashback
CREATE TABLE IF NOT EXISTS cashback_redemptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    organization_id UUID NOT NULL, -- referencia organizations.id
    amount_cents INTEGER NOT NULL,
    redemption_type TEXT NOT NULL CHECK (redemption_type IN ('cash', 'discount', 'credit')),
    description TEXT,
    processed_by UUID, -- referencia employees.id
    processed_at TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'completed', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============= TABELAS DE SISTEMA =============

-- Logs de Auditoria
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID, -- referencia profiles.id
    organization_id UUID, -- referencia organizations.id
    action TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tokens da Carteirinha Digital
CREATE TABLE IF NOT EXISTS wallet_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- referencia profiles.id
    token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    ip_address INET,
    user_agent TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'used', 'expired', 'revoked')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Métricas de Negócio
CREATE TABLE IF NOT EXISTS business_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    unit_id UUID, -- referencia units.id
    metric_name TEXT NOT NULL,
    metric_value DECIMAL(15,2) NOT NULL,
    metric_type TEXT NOT NULL CHECK (metric_type IN ('revenue', 'count', 'percentage', 'duration')),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    dimensions JSONB DEFAULT '{}',
    calculated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Estatísticas Diárias
CREATE TABLE IF NOT EXISTS daily_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL, -- referencia organizations.id
    unit_id UUID, -- referencia units.id
    stat_date DATE NOT NULL,
    total_checkins INTEGER DEFAULT 0,
    unique_visitors INTEGER DEFAULT 0,
    new_members INTEGER DEFAULT 0,
    revenue_cents INTEGER DEFAULT 0,
    occupancy_rate DECIMAL(5,2) DEFAULT 0,
    member_satisfaction DECIMAL(3,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(organization_id, unit_id, stat_date)
);

-- ============= ÍNDICES PARA PERFORMANCE =============

-- Índices em colunas frequentemente consultadas
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);
CREATE INDEX IF NOT EXISTS idx_user_roles_user_org ON user_roles(user_id, organization_id);
CREATE INDEX IF NOT EXISTS idx_memberships_user_status ON memberships(user_id, status);
CREATE INDEX IF NOT EXISTS idx_check_ins_user_date ON check_ins(user_id, check_in_at);
CREATE INDEX IF NOT EXISTS idx_transactions_org_date ON transactions(organization_id, created_at);
CREATE INDEX IF NOT EXISTS idx_cashback_credits_user_status ON cashback_credits(user_id, status);
CREATE INDEX IF NOT EXISTS idx_daily_stats_org_date ON daily_stats(organization_id, stat_date);

-- ============= TRIGGERS PARA UPDATED_AT =============

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger nas tabelas que possuem updated_at
DO $$
DECLARE
    tables_with_updated_at TEXT[] := ARRAY[
        'organizations', 'units', 'profiles', 'employees', 'suppliers', 
        'partner_companies', 'memberships', 'physical_assessments', 
        'nutritional_assessments', 'plans', 'financial_accounts', 
        'products', 'proposals', 'sales', 'cashback_rules'
    ];
    table_name TEXT;
BEGIN
    FOREACH table_name IN ARRAY tables_with_updated_at
    LOOP
        EXECUTE format('
            DROP TRIGGER IF EXISTS update_%I_updated_at ON %I;
            CREATE TRIGGER update_%I_updated_at 
                BEFORE UPDATE ON %I 
                FOR EACH ROW 
                EXECUTE FUNCTION update_updated_at_column();
        ', table_name, table_name, table_name, table_name);
    END LOOP;
END $$;;