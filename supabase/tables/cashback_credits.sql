CREATE TABLE cashback_credits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    rule_id UUID NOT NULL,
    sale_id UUID,
    earned_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'earned',
    expires_at DATE,
    redeemed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);