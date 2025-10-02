-- Migration: setup_complete_system_structure
-- Created at: 1759416623

-- =============================================
-- CONFIGURAÇÃO COMPLETA DO SISTEMA APP LG
-- =============================================

-- ============= AJUSTAR ENUM EXISTENTE =============
-- Adicionar valores necessários ao enum user_role existente
DO $$
BEGIN
    -- Adicionar super_admin se não existir
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'super_admin' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'super_admin';
    END IF;
    
    -- Adicionar employee se não existir  
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'employee' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'employee';
    END IF;
    
    -- Adicionar member se não existir
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'member' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'member';
    END IF;
END $$;

-- ============= HABILITAR RLS EM TABELAS EXISTENTES =============
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cashback_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE cashback_credits ENABLE ROW LEVEL SECURITY;
ALTER TABLE cashback_redemptions ENABLE ROW LEVEL SECURITY;

-- ============= POLÍTICAS DE SEGURANÇA =============

-- Limpar políticas existentes
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Super admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Members can insert own check-ins" ON check_ins;
DROP POLICY IF EXISTS "Staff can view all check-ins" ON check_ins;

-- Políticas para profiles
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins can view all profiles" ON profiles FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'super_admin'))
);

-- Políticas para check-ins
CREATE POLICY "Users can view own check-ins" ON check_ins FOR SELECT USING (
  EXISTS (SELECT 1 FROM clients WHERE id = check_ins.client_id AND person_id = auth.uid())
);

CREATE POLICY "Staff can view all check-ins" ON check_ins FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'manager', 'employee'))
);

CREATE POLICY "Members can create check-ins" ON check_ins FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM clients WHERE id = check_ins.client_id AND person_id = auth.uid())
);

-- ============= CRIAR TABELAS FALTANTES =============

-- Organizações principais
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

-- Unidades/filiais
CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    name TEXT NOT NULL,
    code TEXT UNIQUE NOT NULL,
    document_number TEXT,
    email TEXT,
    phone TEXT,
    address JSONB DEFAULT '{}',
    coordinates POINT,
    capacity INTEGER DEFAULT 100,
    amenities JSONB DEFAULT '[]',
    business_hours JSONB DEFAULT '{}',
    manager_id UUID,
    settings JSONB DEFAULT '{}',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sistema de roles granular
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    organization_id UUID,
    unit_id UUID,
    role user_role NOT NULL,
    permissions JSONB DEFAULT '[]',
    granted_by UUID,
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Matrículas
CREATE TABLE IF NOT EXISTS memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    organization_id UUID NOT NULL,
    unit_id UUID NOT NULL,
    membership_number TEXT UNIQUE NOT NULL,
    plan_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status TEXT DEFAULT 'active' CHECK (status IN ('pending', 'active', 'suspended', 'cancelled', 'expired')),
    documents JSONB DEFAULT '[]',
    emergency_contact JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Avaliações físicas
CREATE TABLE IF NOT EXISTS physical_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    assessor_id UUID NOT NULL,
    unit_id UUID NOT NULL,
    assessment_date DATE NOT NULL,
    measurements JSONB DEFAULT '{}',
    photos JSONB DEFAULT '[]',
    goals JSONB DEFAULT '[]',
    recommendations TEXT,
    next_assessment_date DATE,
    status TEXT DEFAULT 'completed' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Avaliações nutricionais
CREATE TABLE IF NOT EXISTS nutritional_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    nutritionist_id UUID NOT NULL,
    unit_id UUID NOT NULL,
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

-- Produtos/serviços
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
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

-- Carteirinha digital
CREATE TABLE IF NOT EXISTS wallet_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    ip_address INET,
    user_agent TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'used', 'expired', 'revoked')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Auditoria
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    organization_id UUID,
    action TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Métricas
CREATE TABLE IF NOT EXISTS business_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    unit_id UUID,
    metric_name TEXT NOT NULL,
    metric_value DECIMAL(15,2) NOT NULL,
    metric_type TEXT NOT NULL CHECK (metric_type IN ('revenue', 'count', 'percentage', 'duration')),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    dimensions JSONB DEFAULT '{}',
    calculated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Estatísticas diárias
CREATE TABLE IF NOT EXISTS daily_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    unit_id UUID,
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

-- ============= RLS NAS NOVAS TABELAS =============
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE physical_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE nutritional_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallet_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_stats ENABLE ROW LEVEL SECURITY;

-- ============= ÍNDICES =============
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_user_roles_user_org ON user_roles(user_id, organization_id);
CREATE INDEX IF NOT EXISTS idx_memberships_user_status ON memberships(user_id, status);
CREATE INDEX IF NOT EXISTS idx_wallet_tokens_user ON wallet_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_stats_org_date ON daily_stats(organization_id, stat_date);

-- ============= FUNÇÃO UPDATED_AT =============
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para updated_at
DO $$
DECLARE
    tables_with_updated_at TEXT[] := ARRAY[
        'organizations', 'units', 'memberships', 'physical_assessments', 
        'nutritional_assessments', 'products'
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