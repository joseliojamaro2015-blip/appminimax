CREATE TABLE evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    evaluation_type VARCHAR(50),
    evaluator_id UUID,
    metrics JSONB DEFAULT '{}',
    notes TEXT,
    evaluation_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);