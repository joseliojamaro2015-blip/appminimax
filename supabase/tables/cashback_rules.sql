CREATE TABLE cashback_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50),
    percentage DECIMAL(5,2),
    fixed_amount DECIMAL(10,2),
    min_purchase_amount DECIMAL(10,2),
    max_cashback_amount DECIMAL(10,2),
    valid_from DATE,
    valid_until DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);