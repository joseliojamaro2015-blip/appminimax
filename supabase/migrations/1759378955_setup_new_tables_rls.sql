-- Migration: setup_new_tables_rls
-- Created at: 1759378955

-- Habilitar RLS nas novas tabelas
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

-- Políticas para administradores (acesso total)
CREATE POLICY "Admin access to all data" ON branches FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to permissions" ON permissions FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
);

CREATE POLICY "Admin access to people" ON people FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to clients" ON clients FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager'))
);

CREATE POLICY "Admin access to suppliers" ON suppliers FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to employees" ON employees FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to gyms" ON gyms FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager'))
);

CREATE POLICY "Admin access to check_ins" ON check_ins FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager', 'employee'))
);

CREATE POLICY "Admin access to plans" ON plans FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to sales" ON sales FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager', 'employee'))
);

CREATE POLICY "Admin access to proposals" ON proposals FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager', 'employee'))
);

CREATE POLICY "Admin access to financial_accounts" ON financial_accounts FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to financial_categories" ON financial_categories FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to financial_transactions" ON financial_transactions FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to cashback_rules" ON cashback_rules FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin'))
);

CREATE POLICY "Admin access to cashback_credits" ON cashback_credits FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager'))
);

CREATE POLICY "Admin access to cashback_redemptions" ON cashback_redemptions FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager'))
);

CREATE POLICY "Admin access to evaluations" ON evaluations FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('super_admin', 'admin', 'manager', 'employee'))
);

-- Políticas para membros (acesso limitado aos próprios dados)
CREATE POLICY "Members view own client data" ON clients FOR SELECT USING (
  person_id = auth.uid()
);

CREATE POLICY "Members view own check-ins" ON check_ins FOR SELECT USING (
  EXISTS (SELECT 1 FROM clients WHERE person_id = auth.uid() AND id = check_ins.client_id)
);

CREATE POLICY "Members insert own check-ins" ON check_ins FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM clients WHERE person_id = auth.uid() AND id = check_ins.client_id)
);

CREATE POLICY "Members view own cashback_credits" ON cashback_credits FOR SELECT USING (
  EXISTS (SELECT 1 FROM clients WHERE person_id = auth.uid() AND id = cashback_credits.client_id)
);

CREATE POLICY "Members view own evaluations" ON evaluations FOR SELECT USING (
  EXISTS (SELECT 1 FROM clients WHERE person_id = auth.uid() AND id = evaluations.client_id)
);

-- Políticas para visualização de dados públicos
CREATE POLICY "Public access to active plans" ON plans FOR SELECT USING (is_active = true);
CREATE POLICY "Public access to active gyms" ON gyms FOR SELECT USING (is_active = true);;