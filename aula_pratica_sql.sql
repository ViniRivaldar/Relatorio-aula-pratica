-- =========================================================
-- AULA PRÁTICA: CRIAÇÃO DE TABELAS E CONSULTAS SQL
-- Disciplina: Programação e Desenvolvimento de Banco de Dados
-- Unidade 1 - Aula 4: Criação de Tabelas
-- =========================================================

-- 1. CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;

-- 2. CRIAÇÃO DA TABELA 'funcionarios'
-- Tabela para armazenar informações dos funcionários da empresa
CREATE TABLE funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    departamento VARCHAR(50) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    data_admissao DATE NOT NULL
);

-- Verificar se a tabela foi criada corretamente
DESCRIBE funcionarios;

-- 3. INSERÇÃO DE DADOS DE EXEMPLO
-- Inserindo dados fictícios de pelo menos 5 funcionários com diferentes departamentos e salários
INSERT INTO funcionarios (nome, departamento, salario, data_admissao) VALUES
('Ana Silva', 'Financeiro', 5000.00, '2018-03-15'),
('Bruno Santos', 'TI', 6500.00, '2019-07-20'),
('Carlos Oliveira', 'RH', 4500.00, '2020-01-10'),
('Daniela Costa', 'TI', 7000.00, '2017-11-05'),
('Eduardo Lima', 'Financeiro', 5500.00, '2021-02-28'),
('Fernanda Alves', 'Marketing', 4800.00, '2019-09-12'),
('Gabriel Rocha', 'TI', 6800.00, '2020-06-18'),
('Helena Martins', 'RH', 4200.00, '2018-12-03'),
('Igor Fernandes', 'Marketing', 5200.00, '2021-05-14'),
('Amanda Pereira', 'Financeiro', 5300.00, '2020-08-25');

-- Verificar se os dados foram inseridos
SELECT * FROM funcionarios;

-- =========================================================
-- 4. CONSULTAS SQL CONFORME SOLICITADO
-- =========================================================

-- 4.1 CONSULTA SIMPLES: Listar todos os funcionários do departamento de TI
SELECT * FROM funcionarios 
WHERE departamento = 'TI';

-- 4.2 RENOMEAÇÃO E OPERAÇÕES COM STRINGS: 
-- Consultar nome e departamento com alias e nomes em maiúsculas
SELECT 
    UPPER(nome) AS `Nome do Funcionário`,
    departamento AS `Área de Atuação`
FROM funcionarios;

-- 4.3 ORDENAÇÃO E AGRUPAMENTO:
-- Total de salários por departamento, ordenado do maior para o menor
SELECT 
    departamento,
    SUM(salario) AS `Total de Salários`
FROM funcionarios
GROUP BY departamento
ORDER BY SUM(salario) DESC;

-- 4.4 CONSULTA COM LIKE:
-- Encontrar funcionários cujo nome começa com 'A'
SELECT * FROM funcionarios 
WHERE nome LIKE 'A%';

-- =========================================================
-- CONSULTAS ADICIONAIS PARA DEMONSTRAR OUTROS CONCEITOS
-- =========================================================

-- Funcionários cujo nome termina com 'a'
SELECT * FROM funcionarios 
WHERE nome LIKE '%a';

-- Funcionários cujo nome contém 'Silva'
SELECT * FROM funcionarios 
WHERE nome LIKE '%Silva%';

-- Funcionários com salário maior que 5000
SELECT 
    nome,
    departamento,
    salario
FROM funcionarios
WHERE salario > 5000.00
ORDER BY salario DESC;

-- Média salarial por departamento
SELECT 
    departamento,
    AVG(salario) AS `Média Salarial`,
    COUNT(*) AS `Número de Funcionários`
FROM funcionarios
GROUP BY departamento
ORDER BY AVG(salario) DESC;

-- Funcionários admitidos após 2019
SELECT 
    nome,
    departamento,
    data_admissao
FROM funcionarios
WHERE data_admissao > '2019-12-31'
ORDER BY data_admissao;

-- Departamento com maior número de funcionários
SELECT 
    departamento,
    COUNT(*) AS `Quantidade de Funcionários`
FROM funcionarios
GROUP BY departamento
ORDER BY COUNT(*) DESC;

-- =========================================================
-- FIM DO SCRIPT
-- =========================================================