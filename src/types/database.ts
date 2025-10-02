export interface Profile {
  id: string
  full_name?: string
  avatar_url?: string
  phone?: string
  cpf?: string
  birth_date?: string
  address?: any
  emergency_contact?: any
  consents?: any
  role?: 'admin' | 'manager' | 'employee' | 'member' | 'super_admin' | 'org_admin' | 'unit_manager'
  company_id?: string
  corporate_company_id?: string
  status?: string
  approved_by?: string
  approved_at?: string
  member_id?: string
  created_at?: string
  updated_at?: string
}

export interface Organization {
  id: string
  name: string
  slug: string
  document_number?: string
  email?: string
  phone?: string
  address?: any
  business_hours?: any
  logo_url?: string
  settings?: any
  timezone?: string
  status?: 'active' | 'inactive'
  created_at?: string
  updated_at?: string
}

export interface Unit {
  id: string
  organization_id: string
  name: string
  code: string
  document_number?: string
  email?: string
  phone?: string
  address?: any
  coordinates?: any
  capacity?: number
  amenities?: string[]
  business_hours?: any
  manager_id?: string
  settings?: any
  status?: 'active' | 'inactive' | 'maintenance'
  created_at?: string
  updated_at?: string
}

export interface Plan {
  id: string
  name: string
  type?: string
  duration_months?: number
  price: number
  features?: any
  is_active?: boolean
  created_at?: string
  updated_at?: string
}

export interface CheckIn {
  id: string
  client_id: string
  gym_id?: string
  check_in_time: string
  check_out_time?: string
  method?: string
  qr_code?: string
  notes?: string
  created_at?: string
}

export interface DashboardStats {
  totalMembers: number
  activeMembers: number
  totalUnits: number
  monthlyRevenue: number
  todayCheckins: number
  pendingSales: number
  cashbackCredits: number
  growthRate: number
}

export interface DailyStats {
  id: string
  organization_id: string
  unit_id?: string
  stat_date: string
  total_checkins: number
  unique_visitors: number
  new_members: number
  revenue_cents: number
  occupancy_rate: number
  member_satisfaction?: number
  created_at?: string
}

export interface Product {
  id: string
  organization_id: string
  name: string
  description?: string
  type: 'product' | 'service' | 'plan'
  sku?: string
  price_cents: number
  cost_cents?: number
  stock_quantity?: number
  min_stock_level?: number
  images?: string[]
  specifications?: any
  category?: string
  status?: 'active' | 'inactive' | 'discontinued'
  created_at?: string
  updated_at?: string
}

export interface CashbackRule {
  id: string
  name: string
  type?: string
  percentage: number
  fixed_amount: number
  min_purchase_amount: number
  max_cashback_amount: number
  valid_from: string
  valid_until?: string
  is_active?: boolean
  created_at?: string
  updated_at?: string
}

// Adicionando interface para Cliente
export interface Client {
  id: string
  person_id: string
  branch_id?: string
  membership_number?: string
  plan_type?: string
  plan_start_date?: string
  plan_end_date?: string
  monthly_fee?: number
  payment_status?: 'ativo' | 'pendente' | 'suspenso'
  emergency_contact?: any
  health_info?: any
  preferences?: any
  is_active?: boolean
  created_at?: string
  updated_at?: string
  // Dados da pessoa (join)
  full_name?: string
  email?: string
  phone?: string
  cpf_cnpj?: string
  birth_date?: string
  gender?: string
  address?: string
  city?: string
  state?: string
  postal_code?: string
}

export interface Person {
  id: string
  type: 'individual' | 'company'
  full_name: string
  email?: string
  phone?: string
  cpf_cnpj?: string
  birth_date?: string
  gender?: string
  address?: string
  city?: string
  state?: string
  postal_code?: string
  notes?: string
  is_active?: boolean
  created_at?: string
  updated_at?: string
}