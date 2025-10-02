CREATE TABLE sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    plan_id UUID NOT NULL,
    employee_id UUID,
    total_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2) DEFAULT 0,
    final_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending',
    payment_method VARCHAR(50),
    sale_date DATE DEFAULT CURRENT_DATE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);