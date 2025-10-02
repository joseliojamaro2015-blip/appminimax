-- Migration: insert_basic_data
-- Created at: 1759416826

-- =============================================
-- DADOS BÁSICOS PARA FUNCIONAMENTO DO SISTEMA
-- =============================================

-- ============= ORGANIZAÇÃO PRINCIPAL =============
INSERT INTO organizations (
    name,
    slug,
    document_number,
    email,
    phone,
    address,
    business_hours,
    settings,
    status
) VALUES (
    'APP LG - Academia Premium',
    'app-lg-academia',
    '12.345.678/0001-90',
    'contato@applg.com.br',
    '(11) 99999-9999',
    '{
        "street": "Rua das Academias, 123",
        "neighborhood": "Centro",
        "city": "São Paulo",
        "state": "SP",
        "postal_code": "01234-567",
        "country": "Brasil"
    }',
    '{
        "monday": {"open": "06:00", "close": "22:00"},
        "tuesday": {"open": "06:00", "close": "22:00"},
        "wednesday": {"open": "06:00", "close": "22:00"},
        "thursday": {"open": "06:00", "close": "22:00"},
        "friday": {"open": "06:00", "close": "22:00"},
        "saturday": {"open": "08:00", "close": "18:00"},
        "sunday": {"open": "08:00", "close": "16:00"}
    }',
    '{
        "theme_color": "#2563eb",
        "secondary_color": "#10b981",
        "currency": "BRL",
        "language": "pt-BR",
        "notifications": {
            "email": true,
            "sms": true,
            "whatsapp": true
        }
    }',
    'active'
) ON CONFLICT (slug) DO NOTHING;

-- ============= UNIDADES/FILIAIS =============
INSERT INTO units (
    organization_id,
    name,
    code,
    document_number,
    email,
    phone,
    address,
    capacity,
    amenities,
    business_hours,
    status
) VALUES 
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'APP LG - Unidade Centro',
    'APLG-001',
    '12.345.678/0001-90',
    'centro@applg.com.br',
    '(11) 3333-1001',
    '{
        "street": "Rua das Academias, 123",
        "neighborhood": "Centro",
        "city": "São Paulo",
        "state": "SP",
        "postal_code": "01234-567",
        "country": "Brasil"
    }',
    200,
    '["Musculação", "Cardio", "Funcional", "Natação", "Sauna", "Vestiários", "Estacionamento"]',
    '{
        "monday": {"open": "06:00", "close": "22:00"},
        "tuesday": {"open": "06:00", "close": "22:00"},
        "wednesday": {"open": "06:00", "close": "22:00"},
        "thursday": {"open": "06:00", "close": "22:00"},
        "friday": {"open": "06:00", "close": "22:00"},
        "saturday": {"open": "08:00", "close": "18:00"},
        "sunday": {"open": "08:00", "close": "16:00"}
    }',
    'active'
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'APP LG - Unidade Shopping',
    'APLG-002',
    '12.345.678/0002-71',
    'shopping@applg.com.br',
    '(11) 3333-1002',
    '{
        "street": "Av. Shopping Center, 456",
        "neighborhood": "Vila Olímpia",
        "city": "São Paulo",
        "state": "SP",
        "postal_code": "04567-890",
        "country": "Brasil"
    }',
    150,
    '["Musculação", "Cardio", "Funcional", "Pilates", "Spinning", "Vestiários"]',
    '{
        "monday": {"open": "06:00", "close": "22:00"},
        "tuesday": {"open": "06:00", "close": "22:00"},
        "wednesday": {"open": "06:00", "close": "22:00"},
        "thursday": {"open": "06:00", "close": "22:00"},
        "friday": {"open": "06:00", "close": "22:00"},
        "saturday": {"open": "08:00", "close": "20:00"},
        "sunday": {"open": "10:00", "close": "18:00"}
    }',
    'active'
) ON CONFLICT (code) DO NOTHING;

-- ============= CATEGORIAS FINANCEIRAS =============
INSERT INTO financial_categories (
    name,
    type,
    is_active
) VALUES 
(
    'Mensalidades',
    'income',
    true
),
(
    'Matrículas',
    'income',
    true
),
(
    'Personal Training',
    'income',
    true
),
(
    'Salários',
    'expense',
    true
),
(
    'Aluguel',
    'expense',
    true
),
(
    'Energia Elétrica',
    'expense',
    true
) ON CONFLICT DO NOTHING;

-- ============= REGRAS DE CASHBACK (estrutura existente) =============
INSERT INTO cashback_rules (
    name,
    type,
    percentage,
    fixed_amount,
    min_purchase_amount,
    max_cashback_amount,
    valid_from,
    valid_until,
    is_active
) VALUES 
(
    'Cashback Mensalidade',
    'membership',
    5.00,
    0.00,
    50.00,
    100.00,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    true
),
(
    'Cashback Indicação',
    'referral',
    0.00,
    50.00,
    0.00,
    50.00,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    true
),
(
    'Cashback Frequência',
    'frequency',
    2.00,
    0.00,
    0.00,
    50.00,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    true
) ON CONFLICT DO NOTHING;

-- ============= PRODUTOS/SERVIÇOS =============
INSERT INTO products (
    organization_id,
    name,
    description,
    type,
    sku,
    price_cents,
    cost_cents,
    category,
    status
) VALUES 
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'Personal Training - Sessão Avulsa',
    'Sessão individual de personal training com profissional especializado',
    'service',
    'PT-001',
    12000, -- R$ 120,00
    7000,  -- R$ 70,00
    'Personal Training',
    'active'
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'Avaliação Física Completa',
    'Avaliação física completa com bioimpedância e medidas antropométricas',
    'service',
    'AF-001',
    8000,  -- R$ 80,00
    3000,  -- R$ 30,00
    'Avaliações',
    'active'
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'Toalha APP LG',
    'Toalha oficial da academia com logo bordado',
    'product',
    'TOW-001',
    3500,  -- R$ 35,00
    1500,  -- R$ 15,00
    'Acessórios',
    'active'
) ON CONFLICT (sku) DO NOTHING;

-- ============= PLANOS MELHORADOS =============
UPDATE plans SET 
    features = '{
        "access_hours": "06:00-22:00",
        "units": ["all"],
        "amenities": ["Musculação", "Cardio"],
        "guest_passes": 0,
        "personal_training": false,
        "nutritional_assessment": false
    }'
WHERE features IS NULL OR features = '{}';

-- Criar alguns check-ins de exemplo para demonstração
INSERT INTO daily_stats (
    organization_id,
    unit_id,
    stat_date,
    total_checkins,
    unique_visitors,
    new_members,
    revenue_cents,
    occupancy_rate,
    member_satisfaction
) VALUES 
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    (SELECT id FROM units WHERE code = 'APLG-001' LIMIT 1),
    CURRENT_DATE - INTERVAL '1 day',
    65,
    58,
    3,
    1250000, -- R$ 12.500,00
    45.5,
    4.7
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    (SELECT id FROM units WHERE code = 'APLG-002' LIMIT 1),
    CURRENT_DATE - INTERVAL '1 day',
    42,
    38,
    2,
    980000, -- R$ 9.800,00
    38.2,
    4.5
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    (SELECT id FROM units WHERE code = 'APLG-001' LIMIT 1),
    CURRENT_DATE,
    35,
    32,
    1,
    450000, -- R$ 4.500,00
    25.8,
    4.8
) ON CONFLICT (organization_id, unit_id, stat_date) DO NOTHING;;