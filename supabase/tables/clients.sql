CREATE TABLE clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID NOT NULL,
    branch_id UUID,
    membership_number VARCHAR(50) UNIQUE,
    plan_type VARCHAR(50),
    plan_start_date DATE,
    plan_end_date DATE,
    monthly_fee DECIMAL(10,2),
    payment_status VARCHAR(20) DEFAULT 'active',
    emergency_contact JSONB DEFAULT '{}',
    health_info JSONB DEFAULT '{}',
    preferences JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);