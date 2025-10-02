CREATE TABLE financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL,
    category_id UUID,
    type VARCHAR(20) CHECK (type IN ('income',
    'expense',
    'transfer')),
    amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    reference_id UUID,
    transaction_date DATE DEFAULT CURRENT_DATE,
    processed_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'pending',
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);