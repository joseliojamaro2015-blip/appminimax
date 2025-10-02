CREATE TABLE cashback_redemptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    credit_ids JSONB,
    redeemed_amount DECIMAL(10,2),
    redemption_type VARCHAR(50),
    description TEXT,
    redeemed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID
);