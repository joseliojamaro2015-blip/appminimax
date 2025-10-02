-- Migration: insert_initial_data_adjusted
-- Created at: 1759416782

-- =============================================
-- DADOS INICIAIS AJUSTADOS PARA ESTRUTURAS EXISTENTES
-- =============================================

-- ============= ORGANIZAÇÃO PRINCIPAL =============
INSERT INTO organizations (
    id,
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
    gen_random_uuid(),
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
    id,
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
    gen_random_uuid(),
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
    gen_random_uuid(),
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

-- ============= ATUALIZAR PLANOS EXISTENTES =============
UPDATE plans SET 
    features = '{
        "access_hours": "06:00-22:00",
        "units": ["all"],
        "amenities": ["Musculação", "Cardio"],
        "guest_passes": 0,
        "personal_training": false,
        "nutritional_assessment": false
    }'
WHERE name = 'Plano Basic' OR name LIKE '%Basic%';

-- Inserir novos planos se não existirem
INSERT INTO plans (
    name,
    type,
    duration_months,
    price,
    features,
    is_active
) VALUES 
(
    'Plano Premium',
    'monthly',
    1,
    129.90,
    '{
        "access_hours": "24/7",
        "units": ["all"],
        "amenities": ["Musculação", "Cardio", "Funcional", "Sauna"],
        "guest_passes": 2,
        "personal_training": false,
        "nutritional_assessment": true
    }',
    true
),
(
    'Plano VIP',
    'monthly',
    1,
    199.90,
    '{
        "access_hours": "24/7",
        "units": ["all"],
        "amenities": ["all"],
        "guest_passes": 4,
        "personal_training": true,
        "nutritional_assessment": true,
        "massage": true
    }',
    true
),
(
    'Plano Anual Basic',
    'annual',
    12,
    899.00,
    '{
        "access_hours": "06:00-22:00",
        "units": ["all"],
        "amenities": ["Musculação", "Cardio"],
        "guest_passes": 0,
        "personal_training": false,
        "nutritional_assessment": true,
        "discount": "2 meses grátis"
    }',
    true
) ON CONFLICT DO NOTHING;

-- ============= CATEGORIAS FINANCEIRAS (estrutura existente) =============
INSERT INTO financial_categories (
    name,
    type,
    parent_id,
    is_active
) VALUES 
(
    'Mensalidades',
    'income',
    NULL,
    true
),
(
    'Matrículas',
    'income',
    NULL,
    true
),
(
    'Personal Training',
    'income',
    NULL,
    true
),
(
    'Avaliações',
    'income',
    NULL,
    true
),
(
    'Salários',
    'expense',
    NULL,
    true
),
(
    'Energia Elétrica',
    'expense',
    NULL,
    true
),
(
    'Aluguel',
    'expense',
    NULL,
    true
),
(
    'Equipamentos',
    'expense',
    NULL,
    true
) ON CONFLICT DO NOTHING;

-- ============= REGRAS DE CASHBACK =============
INSERT INTO cashback_rules (
    organization_id,
    name,
    description,
    category,
    percentage,
    min_amount_cents,
    conditions,
    valid_from,
    valid_until,
    status
) VALUES 
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'Cashback Mensalidade',
    'Cashback de 5% sobre pagamentos de mensalidade em dia',
    'membership',
    5.00,
    5000, -- R$ 50,00
    '{
        "payment_on_time": true,
        "min_months": 3,
        "applies_to": ["monthly", "quarterly"]
    }',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    'active'
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'Cashback Indicação',
    'Cashback de R$ 50 por indicação de novo membro',
    'referral',
    0.00,
    0,
    '{
        "fixed_amount_cents": 5000,
        "min_membership_months": 1,
        "referred_must_stay_months": 3
    }',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    'active'
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'Cashback Frequência',
    'Cashback de 2% para quem frequenta mais de 12x no mês',
    'frequency',
    2.00,
    0,
    '{
        "min_checkins_month": 12,
        "applies_to_next_month": true
    }',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    'active'
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
    'Avaliação Nutricional',
    'Consulta com nutricionista esportivo e plano alimentar personalizado',
    'service',
    'AN-001',
    15000, -- R$ 150,00
    8000,  -- R$ 80,00
    'Nutrição',
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
),
(
    (SELECT id FROM organizations WHERE slug = 'app-lg-academia' LIMIT 1),
    'Squeeze APP LG',
    'Squeeze esportivo de 750ml com logo da academia',
    'product',
    'SQZ-001',
    2500,  -- R$ 25,00
    1000,  -- R$ 10,00
    'Acessórios',
    'active'
) ON CONFLICT DO NOTHING;

-- ============= CONTAS FINANCEIRAS (estrutura existente) =============
INSERT INTO financial_accounts (
    branch_id,
    name,
    type,
    bank_name,
    account_number,
    balance,
    is_active
) VALUES 
(
    (SELECT id FROM units WHERE code = 'APLG-001' LIMIT 1),
    'Conta Corrente Principal',
    'checking',
    'Banco do Brasil',
    '12345-6',
    500000.00, -- R$ 500.000,00
    true
),
(
    (SELECT id FROM units WHERE code = 'APLG-001' LIMIT 1),
    'Conta Poupança',
    'savings',
    'Banco do Brasil',
    '98765-4',
    150000.00, -- R$ 150.000,00
    true
) ON CONFLICT DO NOTHING;;