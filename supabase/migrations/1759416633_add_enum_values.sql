-- Migration: add_enum_values
-- Created at: 1759416633

-- Adicionar valores necessários ao enum user_role
DO $$
BEGIN
    -- Adicionar super_admin se não existir
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'super_admin' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'super_admin';
    END IF;
    
    -- Adicionar employee se não existir  
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'employee' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'employee';
    END IF;
    
    -- Adicionar member se não existir
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'member' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'member';
    END IF;
    
    -- Adicionar org_admin se não existir
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'org_admin' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'org_admin';
    END IF;
    
    -- Adicionar unit_manager se não existir
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'unit_manager' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')) THEN
        ALTER TYPE user_role ADD VALUE 'unit_manager';
    END IF;
END $$;;