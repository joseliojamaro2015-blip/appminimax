-- Migration: setup_rls_policies
-- Created at: 1759378927

-- Habilitar RLS em todas as tabelas
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE people ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE gyms ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cashback_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE cashback_credits ENABLE ROW LEVEL SECURITY;
ALTER TABLE cashback_redemptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluations ENABLE ROW LEVEL SECURITY;

-- Políticas básicas para profiles
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Políticas para administradores (super_admin)
CREATE POLICY "Super admins can view all profiles" ON profiles FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- Políticas básicas para outras tabelas (acesso baseado em role)
CREATE POLICY "Allow access based on role" ON branches FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager'))
);

CREATE POLICY "Allow permissions access" ON permissions FOR SELECT USING (true);

-- Política para membros visualizarem apenas seus próprios dados
CREATE POLICY "Members view own data" ON clients FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND profiles.id = clients.person_id)
);

-- Políticas para check-ins
CREATE POLICY "Members can insert own check-ins" ON check_ins FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM clients WHERE person_id = auth.uid() AND id = check_ins.client_id)
);

CREATE POLICY "Staff can view all check-ins" ON check_ins FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager', 'employee'))
);;