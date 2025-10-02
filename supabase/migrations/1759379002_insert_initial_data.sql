-- Migration: insert_initial_data
-- Created at: 1759379002

-- Inserir permissões RBAC básicas
INSERT INTO permissions (module, action, role, is_allowed) VALUES
-- Admin permissions (acesso total)
('admin', 'view', 'admin', true),
('admin', 'create', 'admin', true),
('admin', 'update', 'admin', true),
('admin', 'delete', 'admin', true),

('cadastros', 'view', 'admin', true),
('cadastros', 'create', 'admin', true),
('cadastros', 'update', 'admin', true),
('cadastros', 'delete', 'admin', true),

('academias', 'view', 'admin', true),
('academias', 'create', 'admin', true),
('academias', 'update', 'admin', true),
('academias', 'delete', 'admin', true),

('membros', 'view', 'admin', true),
('membros', 'create', 'admin', true),
('membros', 'update', 'admin', true),
('membros', 'delete', 'admin', true),

('vendas', 'view', 'admin', true),
('vendas', 'create', 'admin', true),
('vendas', 'update', 'admin', true),
('vendas', 'delete', 'admin', true),

('financeiro', 'view', 'admin', true),
('financeiro', 'create', 'admin', true),
('financeiro', 'update', 'admin', true),
('financeiro', 'delete', 'admin', true),

('cashback', 'view', 'admin', true),
('cashback', 'create', 'admin', true),
('cashback', 'update', 'admin', true),
('cashback', 'delete', 'admin', true),

-- Manager permissions (limitado)
('cadastros', 'view', 'manager', true),
('cadastros', 'create', 'manager', true),
('cadastros', 'update', 'manager', true),

('academias', 'view', 'manager', true),
('academias', 'update', 'manager', true),

('membros', 'view', 'manager', true),
('membros', 'create', 'manager', true),
('membros', 'update', 'manager', true),

('vendas', 'view', 'manager', true),
('vendas', 'create', 'manager', true),
('vendas', 'update', 'manager', true),

('cashback', 'view', 'manager', true),

-- Gym Operator permissions
('academias', 'view', 'gym_operator', true),
('academias', 'update', 'gym_operator', true),

('membros', 'view', 'gym_operator', true),
('membros', 'update', 'gym_operator', true),

('vendas', 'view', 'gym_operator', true),
('vendas', 'create', 'gym_operator', true),

-- Benefits Attendant permissions
('cashback', 'view', 'benefits_attendant', true),
('cashback', 'create', 'benefits_attendant', true),
('cashback', 'update', 'benefits_attendant', true);

-- Inserir categorias financeiras básicas
INSERT INTO financial_categories (name, type) VALUES
('Mensalidades', 'income'),
('Matrículas', 'income'),
('Personal Trainer', 'income'),
('Produtos', 'income'),
('Outros Serviços', 'income'),
('Salários', 'expense'),
('Aluguel', 'expense'),
('Energia Elétrica', 'expense'),
('Água', 'expense'),
('Internet', 'expense'),
('Material de Limpeza', 'expense'),
('Equipamentos', 'expense'),
('Marketing', 'expense'),
('Impostos', 'expense'),
('Outros Gastos', 'expense');

-- Inserir planos básicos
INSERT INTO plans (name, type, duration_months, price, features) VALUES
('Mensal Básico', 'individual', 1, 89.90, '{"modalidades": ["Musculação", "Cardio"], "beneficios": ["Avaliação física"]}'),
('Trimestral', 'individual', 3, 249.90, '{"modalidades": ["Musculação", "Cardio", "Funcional"], "beneficios": ["Avaliação física", "Plano nutricional"]}'),
('Semestral', 'individual', 6, 449.90, '{"modalidades": ["Musculação", "Cardio", "Funcional", "Natação"], "beneficios": ["Avaliação física", "Plano nutricional", "Acompanhamento"]}'),
('Anual Premium', 'individual', 12, 799.90, '{"modalidades": ["Todas"], "beneficios": ["Avaliação física", "Plano nutricional", "Personal trainer", "Suplementos"]}'),
('Corporativo Básico', 'corporate', 12, 59.90, '{"modalidades": ["Musculação", "Cardio"], "min_funcionarios": 10}'),
('Corporativo Premium', 'corporate', 12, 79.90, '{"modalidades": ["Todas"], "min_funcionarios": 20, "beneficios": ["Palestras", "Avaliações"]}');

-- Inserir regras de cashback básicas
INSERT INTO cashback_rules (name, type, percentage, min_purchase_amount, valid_from, valid_until) VALUES
('Cashback Mensalidade', 'monthly_fee', 5.00, 50.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year'),
('Cashback Plano Anual', 'annual_plan', 10.00, 500.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year'),
('Cashback Produtos', 'products', 3.00, 30.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '6 months'),
('Cashback Indicação', 'referral', 0.00, 0.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year');

-- Atualizar regra de indicação com valor fixo
UPDATE cashback_rules SET fixed_amount = 25.00, percentage = 0.00 WHERE name = 'Cashback Indicação';;