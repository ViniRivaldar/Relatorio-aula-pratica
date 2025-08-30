-- =========================================================
-- AULA PRÁTICA: USO DE CONSTRAINTS
-- Disciplina: Programação e Desenvolvimento de Banco de Dados
-- Unidade 2 - Aula 3: Uso de Constraints
-- =========================================================

-- Conectar ao banco de dados empresa (criado na aula anterior)
USE empresa;

-- Verificar estrutura atual da tabela funcionarios
DESCRIBE funcionarios;

-- =========================================================
-- 1. INSERÇÃO DE DADOS
-- =========================================================
-- Inserir novos funcionários na tabela 'funcionarios'

INSERT INTO funcionarios (nome, departamento, salario, data_admissao) VALUES
('Juliana Souza', 'Marketing', 4900.00, '2022-01-15'),
('Lucas Pereira', 'TI', 6200.00, '2022-03-10'),
('Mariana Lima', 'Financeiro', 5100.00, '2021-11-20');

-- Verificar dados inseridos
SELECT * FROM funcionarios;

-- =========================================================
-- 2. ATUALIZAÇÃO DE DADOS
-- =========================================================
-- Atualizar o salário de um funcionário específico, aumentando-o em 10%

-- Aumentar salário da Ana Silva em 10%
UPDATE funcionarios 
SET salario = salario * 1.10 
WHERE nome = 'Ana Silva';

-- Verificar a atualização
SELECT nome, salario FROM funcionarios WHERE nome = 'Ana Silva';

-- =========================================================
-- 3. EXCLUSÃO DE DADOS
-- =========================================================
-- Excluir registros de funcionários baseado em critérios específicos

-- Excluir todos os funcionários do departamento TI
DELETE FROM funcionarios 
WHERE departamento = 'TI';

-- Verificar exclusão
SELECT * FROM funcionarios WHERE departamento = 'TI';

-- Listar funcionários restantes
SELECT * FROM funcionarios;

-- =========================================================
-- 4. MODIFICAÇÃO DE ESTRUTURA DE TABELA
-- =========================================================

-- 4.1 Adicionar nova coluna 'email' à tabela funcionarios
ALTER TABLE funcionarios 
ADD COLUMN email VARCHAR(100);

-- 4.2 Alterar tipo da coluna 'salario' de DECIMAL para FLOAT
ALTER TABLE funcionarios 
MODIFY COLUMN salario FLOAT;

-- 4.3 Remover a coluna 'data_admissao' da tabela
ALTER TABLE funcionarios 
DROP COLUMN data_admissao;

-- Verificar nova estrutura da tabela
DESCRIBE funcionarios;

-- =========================================================
-- 5. MANIPULAÇÃO DE CONSTRAINTS
-- =========================================================

-- Adicionar constraint UNIQUE para a coluna 'email'
ALTER TABLE funcionarios 
ADD CONSTRAINT unique_email UNIQUE (email);

-- Verificar constraints da tabela
SHOW CREATE TABLE funcionarios;

-- =========================================================
-- TESTE DAS MODIFICAÇÕES
-- =========================================================

-- Atualizar alguns emails para testar a constraint
UPDATE funcionarios SET email = 'ana.silva@empresa.com' WHERE nome = 'Ana Silva';
UPDATE funcionarios SET email = 'carlos.oliveira@empresa.com' WHERE nome = 'Carlos Oliveira';
UPDATE funcionarios SET email = 'juliana.souza@empresa.com' WHERE nome = 'Juliana Souza';

-- Verificar estrutura e dados finais
SELECT * FROM funcionarios;

-- =========================================================
-- FIM DO SCRIPT
-- =========================================================