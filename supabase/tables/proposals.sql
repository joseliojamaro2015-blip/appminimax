CREATE TABLE proposals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    plan_id UUID NOT NULL,
    proposal_date DATE DEFAULT CURRENT_DATE,
    valid_until DATE,
    amount DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
    status VARCHAR(20) DEFAULT 'pending',
    notes TEXT,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);