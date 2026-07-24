-- =============================================
-- FLOWFISCAL ERP - DATABASE SCHEMA
-- =============================================

-- =============================================
-- 1. TABELAS DE USUÁRIOS E SEGURANÇA
-- =============================================

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    permissions JSONB DEFAULT '[]',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    profile_id INTEGER NOT NULL REFERENCES profiles(id),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 2. TABELAS DE CADASTRO BÁSICO
-- =============================================

CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    legal_name VARCHAR(255),
    address VARCHAR(500),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id),
    name VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    address VARCHAR(500),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE cost_centers (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id),
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(company_id, code)
);

CREATE TABLE rubrics (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id),
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(company_id, code)
);

CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id),
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id),
    contract_number VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    contract_value DECIMAL(15, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 3. TABELAS DE GESTÃO DE NOTAS FISCAIS
-- =============================================

CREATE TYPE invoice_status AS ENUM (
    'received',
    'operational',
    'analyst',
    'manager',
    'accounting',
    'financial',
    'payment',
    'reconciliation',
    'completed',
    'rejected'
);

CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id),
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id),
    contract_id INTEGER REFERENCES contracts(id),
    cost_center_id INTEGER REFERENCES cost_centers(id),
    rubric_id INTEGER REFERENCES rubrics(id),
    invoice_number VARCHAR(100) NOT NULL,
    invoice_series VARCHAR(10),
    invoice_date DATE NOT NULL,
    invoice_value DECIMAL(15, 2) NOT NULL,
    status invoice_status DEFAULT 'received',
    nf_xml TEXT,
    nf_pdf BYTEA,
    file_path VARCHAR(500),
    hash_value VARCHAR(64),
    is_duplicate BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(company_id, supplier_id, invoice_number, invoice_series)
);

CREATE TABLE invoice_history (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    previous_status invoice_status,
    new_status invoice_status NOT NULL,
    changed_by INTEGER NOT NULL REFERENCES users(id),
    comments TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE invoice_approvals (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    approval_level VARCHAR(50) NOT NULL, -- operational, analyst, manager, accounting, financial, payment
    assigned_to INTEGER NOT NULL REFERENCES users(id),
    status VARCHAR(50) DEFAULT 'pending', -- pending, approved, rejected
    rejection_reason TEXT,
    approved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE invoice_comments (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 4. TABELAS FINANCEIRAS
-- =============================================

CREATE TABLE invoice_items (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    item_number INTEGER,
    description VARCHAR(500),
    quantity DECIMAL(10, 2),
    unit_price DECIMAL(15, 2),
    total_value DECIMAL(15, 2),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE invoice_allocations (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    cost_center_id INTEGER NOT NULL REFERENCES cost_centers(id),
    rubric_id INTEGER NOT NULL REFERENCES rubrics(id),
    allocation_percentage DECIMAL(5, 2),
    allocation_value DECIMAL(15, 2),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE correction_letters (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    letter_number VARCHAR(100) NOT NULL,
    reason TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- pending, issued, approved
    issued_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 5. TABELAS DE PAGAMENTO
-- =============================================

CREATE TABLE invoices_boletos (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    boleto_number VARCHAR(50) UNIQUE,
    due_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'open', -- open, paid, overdue, cancelled
    payment_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 6. TABELAS DE AUDITORIA E LOGS
-- =============================================

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- ÍNDICES PARA PERFORMANCE
-- =============================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_profile ON users(profile_id);
CREATE INDEX idx_companies_cnpj ON companies(cnpj);
CREATE INDEX idx_suppliers_company ON suppliers(company_id);
CREATE INDEX idx_suppliers_cnpj ON suppliers(cnpj);
CREATE INDEX idx_invoices_company ON invoices(company_id);
CREATE INDEX idx_invoices_supplier ON invoices(supplier_id);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_contract ON invoices(contract_id);
CREATE INDEX idx_invoices_date ON invoices(invoice_date);
CREATE INDEX idx_invoices_hash ON invoices(hash_value);
CREATE INDEX idx_invoice_history_invoice ON invoice_history(invoice_id);
CREATE INDEX idx_invoice_approvals_invoice ON invoice_approvals(invoice_id);
CREATE INDEX idx_invoice_approvals_user ON invoice_approvals(assigned_to);
CREATE INDEX idx_invoice_comments_invoice ON invoice_comments(invoice_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at);

-- =============================================
-- VIEWS PARA RELATÓRIOS
-- =============================================

CREATE VIEW v_invoices_summary AS
SELECT
    i.id,
    c.name as company_name,
    s.name as supplier_name,
    i.invoice_number,
    i.invoice_date,
    i.invoice_value,
    i.status,
    COUNT(DISTINCT ia.id) as approval_steps_completed,
    COUNT(DISTINCT ic.id) as comments_count
FROM invoices i
LEFT JOIN companies c ON i.company_id = c.id
LEFT JOIN suppliers s ON i.supplier_id = s.id
LEFT JOIN invoice_approvals ia ON i.id = ia.invoice_id AND ia.status = 'approved'
LEFT JOIN invoice_comments ic ON i.id = ic.invoice_id
GROUP BY i.id, c.name, s.name, i.invoice_number, i.invoice_date, i.invoice_value, i.status;

CREATE VIEW v_invoices_by_status AS
SELECT
    status,
    COUNT(*) as count,
    SUM(invoice_value) as total_value
FROM invoices
GROUP BY status;

CREATE VIEW v_supplier_expenses AS
SELECT
    s.id,
    s.name as supplier_name,
    c.name as company_name,
    COUNT(i.id) as invoice_count,
    SUM(i.invoice_value) as total_amount,
    AVG(i.invoice_value) as average_amount
FROM suppliers s
LEFT JOIN companies c ON s.company_id = c.id
LEFT JOIN invoices i ON s.id = i.supplier_id
GROUP BY s.id, s.name, c.name;

-- =============================================
-- TRIGGERS PARA AUDITORIA
-- =============================================

CREATE OR REPLACE FUNCTION log_audit()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_logs (action, table_name, record_id, new_values, created_at)
    VALUES (TG_ARGV[0], TG_TABLE_NAME, NEW.id, row_to_json(NEW), NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_invoices AFTER INSERT OR UPDATE ON invoices
    FOR EACH ROW EXECUTE FUNCTION log_audit('INVOICE_MODIFIED');

CREATE TRIGGER audit_users AFTER INSERT OR UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION log_audit('USER_MODIFIED');
