-- =========================================================
-- AULA PRÁTICA: JUNÇÕES COM BANCO DE DADOS
-- Disciplina: Programação e Desenvolvimento de Banco de Dados
-- Unidade 3 - Aula 1: Junções com Banco de Dados
-- =========================================================

-- ETAPA 1: CRIAÇÃO DA BASE DE DADOS E ESTRUTURAS
-- =========================================================

-- Criar banco de dados Loja
CREATE DATABASE IF NOT EXISTS Loja;
USE Loja;

-- Tabela Cliente
CREATE TABLE Cliente (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    Telefone VARCHAR(15),
    Email VARCHAR(100),
    Endereco VARCHAR(200)
);

-- Tabela ContaReceber
CREATE TABLE ContaReceber (
    ContaID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    DataVencimento DATE NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    Situacao ENUM('1', '2', '3') NOT NULL DEFAULT '1',
    Descricao VARCHAR(200),
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

-- Verificar estruturas criadas
DESCRIBE Cliente;
DESCRIBE ContaReceber;

-- =========================================================
-- ETAPA 2: SCRIPT inserir.sql - INSERÇÃO DE DADOS
-- =========================================================

-- Inserir dados na tabela Cliente (pelo menos 3 registros)
INSERT INTO Cliente (Nome, CPF, Telefone, Email, Endereco) VALUES
('João Silva Santos', '123.456.789-01', '(11) 99999-1111', 'joao.silva@email.com', 'Rua das Flores, 123 - São Paulo/SP'),
('Maria Oliveira Costa', '987.654.321-02', '(11) 88888-2222', 'maria.oliveira@email.com', 'Av. Paulista, 456 - São Paulo/SP'),
('Carlos Eduardo Lima', '456.789.123-03', '(11) 77777-3333', 'carlos.lima@email.com', 'Rua Augusta, 789 - São Paulo/SP'),
('Ana Paula Rocha', '321.654.987-04', '(11) 66666-4444', 'ana.rocha@email.com', 'Rua Oscar Freire, 321 - São Paulo/SP'),
('Pedro Henrique Alves', '789.123.456-05', '(11) 55555-5555', 'pedro.alves@email.com', 'Av. Faria Lima, 654 - São Paulo/SP');

-- Inserir dados na tabela ContaReceber (pelo menos 3 registros por cliente)
INSERT INTO ContaReceber (ClienteID, DataVencimento, Valor, Situacao, Descricao) VALUES
-- Contas do Cliente 1 (João Silva Santos)
(1, '2025-09-15', 150.00, '1', 'Mensalidade setembro'),
(1, '2025-10-15', 150.00, '1', 'Mensalidade outubro'),
(1, '2025-08-15', 150.00, '3', 'Mensalidade agosto - PAGA'),

-- Contas do Cliente 2 (Maria Oliveira Costa)
(2, '2025-09-20', 280.50, '1', 'Serviço de consultoria'),
(2, '2025-07-20', 280.50, '2', 'Serviço cancelado'),
(2, '2025-10-20', 320.00, '1', 'Projeto especial'),

-- Contas do Cliente 3 (Carlos Eduardo Lima)
(3, '2025-09-10', 500.00, '1', 'Compra de equipamentos'),
(3, '2025-08-10', 450.00, '3', 'Manutenção - PAGA'),
(3, '2025-11-10', 600.00, '1', 'Upgrade sistema'),

-- Contas do Cliente 4 (Ana Paula Rocha)
(4, '2025-09-25', 75.00, '1', 'Taxa de manutenção'),
(4, '2025-08-25', 75.00, '3', 'Taxa agosto - PAGA'),
(4, '2025-07-25', 80.00, '2', 'Taxa cancelada'),

-- Contas do Cliente 5 (Pedro Henrique Alves)
(5, '2025-10-05', 1200.00, '1', 'Licença software anual'),
(5, '2025-09-05', 300.00, '1', 'Suporte técnico'),
(5, '2025-08-05', 250.00, '3', 'Instalação - PAGA');

-- Verificar dados inseridos
SELECT * FROM Cliente;
SELECT * FROM ContaReceber;

-- =========================================================
-- ETAPA 3: SCRIPT consulta.sql - CRIAÇÃO DE VIEW
-- =========================================================

-- Criar VIEW para contas não pagas (Situacao = 1)
CREATE VIEW ContasNaoPagas AS
SELECT 
    cr.ContaID AS 'ID da Conta',
    c.Nome AS 'Nome do Cliente',
    c.CPF AS 'CPF do Cliente',
    cr.DataVencimento AS 'Data de Vencimento',
    cr.Valor AS 'Valor da Conta',
    cr.Descricao AS 'Descrição'
FROM ContaReceber cr
INNER JOIN Cliente c ON cr.ClienteID = c.ClienteID
WHERE cr.Situacao = '1'
ORDER BY cr.DataVencimento;

-- Consultar a VIEW criada
SELECT * FROM ContasNaoPagas;

-- =========================================================
-- CONSULTAS ADICIONAIS PARA DEMONSTRAÇÃO
-- =========================================================

-- Consulta simples: Todas as contas com seus clientes
SELECT 
    cr.ContaID,
    c.Nome,
    cr.Valor,
    cr.Situacao,
    CASE 
        WHEN cr.Situacao = '1' THEN 'Conta registrada'
        WHEN cr.Situacao = '2' THEN 'Conta cancelada'
        WHEN cr.Situacao = '3' THEN 'Conta paga'
    END AS 'Status'
FROM ContaReceber cr
INNER JOIN Cliente c ON cr.ClienteID = c.ClienteID;

-- Total de contas por cliente
SELECT 
    c.Nome,
    COUNT(cr.ContaID) AS 'Total de Contas',
    SUM(cr.Valor) AS 'Valor Total'
FROM Cliente c
LEFT JOIN ContaReceber cr ON c.ClienteID = cr.ClienteID
GROUP BY c.ClienteID, c.Nome;

-- =========================================================
-- FIM DO SCRIPT
-- =========================================================