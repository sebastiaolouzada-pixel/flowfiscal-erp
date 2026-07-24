-- =============================================
-- FLOWFISCAL ERP - DADOS INICIAIS (SEEDS)
-- =============================================

-- =============================================
-- 1. INSERIR PERFIS PADRÃO
-- =============================================

INSERT INTO profiles (name, description, permissions) VALUES
('Administrador', 'Acesso total ao sistema', '["*"]'),
('Gerente', 'Acesso gerencial e aprovações', '["invoices:view", "invoices:approve", "reports:view", "users:view"]'),
('Analista', 'Análise de notas fiscais', '["invoices:view", "invoices:edit", "invoices:comment"]'),
('Operacional', 'Entrada de dados', '["invoices:create", "invoices:view", "invoices:edit"]'),
('Financeiro', 'Gestão financeira', '["invoices:view", "financial:view", "financial:edit", "reports:view"]'),
('Contador', 'Acesso contábil', '["invoices:view", "accounting:view", "accounting:edit", "reports:view"]');

-- =============================================
-- 2. INSERIR USUÁRIO ADMIN
-- =============================================

-- Senha: admin123 (hash bcrypt)
INSERT INTO users (email, full_name, password_hash, profile_id, is_active) VALUES
('admin@flowfiscal.com', 'Administrador Sistema', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5YmMxSUTPcJFm', 1, TRUE);

-- =============================================
-- 3. INSERIR DADOS DE TESTE - EMPRESA
-- =============================================

INSERT INTO companies (name, cnpj, legal_name, address, city, state, zip_code, phone, email, is_active) VALUES
('Empresa Teste', '12.345.678/0001-90', 'Empresa Teste LTDA', 'Rua das Flores, 123', 'São Paulo', 'SP', '01234-567', '(11) 3456-7890', 'contato@empresateste.com.br', TRUE),
('Acme Corporation', '98.765.432/0001-01', 'Acme Corporation LTDA', 'Av. Paulista, 1000', 'São Paulo', 'SP', '01311-100', '(11) 2345-6789', 'contact@acme.com.br', TRUE),
('Tech Solutions', '11.222.333/0001-44', 'Tech Solutions Brasil LTDA', 'Rua da Inovação, 500', 'Rio de Janeiro', 'RJ', '20000-000', '(21) 3333-4444', 'info@techsolutions.com.br', TRUE);

-- =============================================
-- 4. INSERIR FORNECEDORES
-- =============================================

INSERT INTO suppliers (company_id, name, cnpj, contact_person, email, phone, address, city, state, zip_code, is_active) VALUES
-- Fornecedores da Empresa Teste
(1, 'Fornecedor A', '11.111.111/0001-11', 'João Silva', 'contato@fornecedora.com.br', '(11) 1111-1111', 'Rua A, 100', 'São Paulo', 'SP', '02000-000', TRUE),
(1, 'Fornecedor B', '22.222.222/0001-22', 'Maria Santos', 'vendas@fornecedorb.com.br', '(11) 2222-2222', 'Rua B, 200', 'São Paulo', 'SP', '03000-000', TRUE),
(1, 'Fornecedor C', '33.333.333/0001-33', 'Carlos Oliveira', 'sales@fornecedorc.com.br', '(11) 3333-3333', 'Rua C, 300', 'São Paulo', 'SP', '04000-000', TRUE),

-- Fornecedores da Acme Corporation
(2, 'Global Supplies', '44.444.444/0001-44', 'Pedro Costa', 'contato@globalsupplies.com.br', '(21) 4444-4444', 'Av. Brasil, 400', 'Rio de Janeiro', 'RJ', '21000-000', TRUE),
(2, 'National Services', '55.555.555/0001-55', 'Ana Paula', 'vendas@nationalservices.com.br', '(21) 5555-5555', 'Rua Nacional, 500', 'Rio de Janeiro', 'RJ', '22000-000', TRUE),

-- Fornecedores da Tech Solutions
(3, 'IT Services Global', '66.666.666/0001-66', 'Lucas Ferreira', 'suporte@itservicesglobal.com.br', '(85) 6666-6666', 'Rua Tech, 600', 'Fortaleza', 'CE', '60000-000', TRUE);

-- =============================================
-- 5. INSERIR CENTROS DE CUSTO
-- =============================================

INSERT INTO cost_centers (company_id, code, name, description, is_active) VALUES
-- Empresa Teste
(1, 'CC001', 'Administrativo', 'Centro de custo administrativo', TRUE),
(1, 'CC002', 'Operacional', 'Centro de custo operacional', TRUE),
(1, 'CC003', 'Vendas', 'Centro de custo de vendas', TRUE),
(1, 'CC004', 'TI', 'Tecnologia da Informação', TRUE),
(1, 'CC005', 'RH', 'Recursos Humanos', TRUE),

-- Acme Corporation
(2, 'CC001', 'Matriz', 'Matriz São Paulo', TRUE),
(2, 'CC002', 'Filial RJ', 'Filial Rio de Janeiro', TRUE),

-- Tech Solutions
(3, 'CC001', 'Desenvolvimento', 'Desenvolvimento de software', TRUE),
(3, 'CC002', 'Infraestrutura', 'Infraestrutura e Cloud', TRUE);

-- =============================================
-- 6. INSERIR RUBRICAS
-- =============================================

INSERT INTO rubrics (company_id, code, name, description, is_active) VALUES
-- Empresa Teste
(1, 'RUB001', 'Aluguel', 'Despesas de aluguel', TRUE),
(1, 'RUB002', 'Utilities', 'Água, luz e internet', TRUE),
(1, 'RUB003', 'Materiais', 'Materiais de escritório', TRUE),
(1, 'RUB004', 'Serviços', 'Serviços terceirizados', TRUE),
(1, 'RUB005', 'Transporte', 'Despesas de transporte', TRUE),

-- Acme Corporation
(2, 'RUB001', 'Operacional', 'Despesas operacionais', TRUE),
(2, 'RUB002', 'Investimento', 'Investimentos e equipamentos', TRUE),

-- Tech Solutions
(3, 'RUB001', 'Software', 'Licenças de software', TRUE),
(3, 'RUB002', 'Hardware', 'Hardware e equipamentos', TRUE);

-- =============================================
-- 7. INSERIR CONTRATOS
-- =============================================

INSERT INTO contracts (company_id, supplier_id, contract_number, description, start_date, end_date, contract_value, is_active) VALUES
(1, 1, 'CT-001-2026', 'Fornecimento de materiais', '2026-01-01', '2026-12-31', 50000.00, TRUE),
(1, 2, 'CT-002-2026', 'Serviços de consultoria', '2026-01-01', '2026-06-30', 75000.00, TRUE),
(1, 3, 'CT-003-2026', 'Manutenção de equipamentos', '2026-01-01', '2026-12-31', 30000.00, TRUE),
(2, 4, 'CT-001-2026', 'Fornecimento de produtos', '2026-01-01', '2026-12-31', 100000.00, TRUE),
(3, 6, 'CT-001-2026', 'Serviços de cloud computing', '2026-01-01', '2026-12-31', 60000.00, TRUE);

-- =============================================
-- 8. INSERIR NOTAS FISCAIS DE TESTE
-- =============================================

INSERT INTO invoices (company_id, supplier_id, contract_id, cost_center_id, rubric_id, invoice_number, invoice_series, invoice_date, invoice_value, status, is_duplicate, notes) VALUES
-- Notas da Empresa Teste
(1, 1, 1, 1, 1, '001', '1', '2026-07-01', 5000.00, 'received', FALSE, 'NF normal'),
(1, 1, 1, 1, 1, '002', '1', '2026-07-05', 3500.00, 'operational', FALSE, 'NF em análise operacional'),
(1, 2, 2, 3, 4, '001', '1', '2026-07-10', 15000.00, 'analyst', FALSE, 'Aguardando análise'),
(1, 3, 3, 4, 2, '001', '1', '2026-07-15', 8000.00, 'manager', FALSE, 'Para aprovação do gestor'),
(1, 1, 1, 2, 3, '003', '1', '2026-07-20', 2500.00, 'accounting', FALSE, 'Em contabilidade'),

-- Notas da Acme Corporation
(2, 4, 4, 6, 1, '001', '1', '2026-07-02', 25000.00, 'received', FALSE, 'Nota grande'),
(2, 5, NULL, 6, 2, '001', '1', '2026-07-12', 18000.00, 'financial', FALSE, 'Pronta para financeiro'),

-- Notas da Tech Solutions
(3, 6, 5, 8, 1, '001', '1', '2026-07-08', 12000.00, 'completed', FALSE, 'Processada e concluída');

-- =============================================
-- 9. INSERIR HISTÓRICO DE NOTAS
-- =============================================

INSERT INTO invoice_history (invoice_id, previous_status, new_status, changed_by, comments) VALUES
(2, 'received', 'operational', 1, 'Iniciado processo operacional'),
(3, 'received', 'analyst', 1, 'Encaminhado para análise'),
(4, 'received', 'manager', 1, 'Encaminhado para gestor'),
(5, 'received', 'accounting', 1, 'Encaminhado para contabilidade'),
(6, 'received', 'received', 1, 'Recebido no sistema'),
(7, 'received', 'financial', 1, 'Encaminhado para financeiro'),
(8, 'received', 'completed', 1, 'Processada completamente');

-- =============================================
-- 10. INSERIR APROVAÇÕES
-- =============================================

INSERT INTO invoice_approvals (invoice_id, approval_level, assigned_to, status) VALUES
(2, 'operational', 1, 'pending'),
(3, 'analyst', 1, 'pending'),
(4, 'manager', 1, 'pending'),
(5, 'accounting', 1, 'pending'),
(6, 'operational', 1, 'pending'),
(7, 'financial', 1, 'pending'),
(8, 'financial', 1, 'approved');

-- =============================================
-- 11. INSERIR COMENTÁRIOS
-- =============================================

INSERT INTO invoice_comments (invoice_id, user_id, comment) VALUES
(1, 1, 'Nota recebida e aguardando processamento'),
(2, 1, 'Iniciando análise operacional'),
(3, 1, 'Documento em análise'),
(6, 1, 'Nota de alto valor, requer atenção especial');

-- =============================================
-- 12. INSERIR ITENS DE NOTAS
-- =============================================

INSERT INTO invoice_items (invoice_id, item_number, description, quantity, unit_price, total_value) VALUES
-- Nota 001 - Empresa Teste
(1, 1, 'Material de escritório', 100.00, 25.00, 2500.00),
(1, 2, 'Impressoras', 5.00, 500.00, 2500.00),

-- Nota 002 - Empresa Teste
(2, 1, 'Papel A4', 50.00, 40.00, 2000.00),
(2, 2, 'Canetas', 200.00, 7.50, 1500.00),

-- Nota 001 - Acme Corporation
(6, 1, 'Produto A', 100.00, 150.00, 15000.00),
(6, 2, 'Produto B', 50.00, 200.00, 10000.00);

-- =============================================
-- 13. INSERIR ALOCAÇÕES
-- =============================================

INSERT INTO invoice_allocations (invoice_id, cost_center_id, rubric_id, allocation_percentage, allocation_value) VALUES
(1, 1, 1, 100.00, 5000.00),
(2, 1, 1, 100.00, 3500.00),
(3, 3, 4, 100.00, 15000.00),
(6, 6, 1, 100.00, 25000.00);

-- =============================================
-- 14. INSERIR BOLETOS
-- =============================================

INSERT INTO invoices_boletos (invoice_id, boleto_number, due_date, amount, status) VALUES
(1, '12345.67890 12345 123456 123456789 12345678901234', '2026-08-01', 5000.00, 'open'),
(3, '98765.43210 98765 987654 987654321 98765432109876', '2026-08-10', 15000.00, 'open'),
(6, '11111.22222 33333 444444 555555555 66666666666666', '2026-08-02', 25000.00, 'open');
