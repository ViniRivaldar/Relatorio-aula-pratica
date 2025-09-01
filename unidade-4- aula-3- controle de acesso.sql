-- =========================================================
-- AULA PRÁTICA: CONTROLE DE ACESSO
-- Disciplina: Programação e Desenvolvimento de Banco de Dados
-- Unidade 4 - Aula 3: Controle de Acesso
-- =========================================================

-- Usar o banco de dados Empresa (das atividades anteriores)
USE empresa;

-- =========================================================
-- PREPARAÇÃO: CRIAÇÃO DE USUÁRIOS
-- =========================================================

-- Criar usuário júnior
CREATE USER IF NOT EXISTS 'usuario_junior'@'localhost' IDENTIFIED BY 'senha123';

-- Criar usuário sênior
CREATE USER IF NOT EXISTS 'usuario_senior'@'localhost' IDENTIFIED BY 'senha456';

-- =========================================================
-- PREPARAÇÃO: CRIAÇÃO DE TABELA DE LOG
-- =========================================================

-- Criar tabela para log de transações
CREATE TABLE IF NOT EXISTS log_transacoes (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    DataTransacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Usuario VARCHAR(50),
    TipoOperacao VARCHAR(50),
    Descricao TEXT,
    FuncionarioID INT
);

-- =========================================================
-- 1. AUTOMAÇÃO DE PROCESSOS - EVENTOS
-- =========================================================

-- Habilitar o agendador de eventos
SET GLOBAL event_scheduler = ON;

-- Criar evento para atualizar salários anualmente em 3%
CREATE EVENT IF NOT EXISTS atualizacao_salario_anual
ON SCHEDULE EVERY 1 YEAR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Atualizar salários dos funcionários em 3%
    UPDATE funcionarios 
    SET salario = salario * 1.03;
    
    -- Registrar no log
    INSERT INTO log_transacoes (Usuario, TipoOperacao, Descricao)
    VALUES ('SISTEMA', 'ATUALIZACAO_AUTOMATICA', 'Aumento anual de 3% nos salários');
END;

-- Verificar se o evento foi criado
SHOW EVENTS;

-- =========================================================
-- 2. CONTROLE TRANSACIONAL
-- =========================================================

-- Transação para transferir funcionário de departamento
START TRANSACTION;

-- Guardar dados antes da mudança para o log
SET @funcionario_id = (SELECT id FROM funcionarios WHERE nome = 'Ana Silva' LIMIT 1);
SET @depto_antigo = (SELECT departamento FROM funcionarios WHERE id = @funcionario_id);
SET @depto_novo = 'TI';

-- Atualizar departamento do funcionário
UPDATE funcionarios 
SET departamento = @depto_novo 
WHERE id = @funcionario_id;

-- Registrar a mudança no log de transações
INSERT INTO log_transacoes (Usuario, TipoOperacao, Descricao, FuncionarioID)
VALUES (
    USER(), 
    'TRANSFERENCIA_DEPARTAMENTO', 
    CONCAT('Funcionário transferido de ', @depto_antigo, ' para ', @depto_novo),
    @funcionario_id
);

-- Confirmar a transação
COMMIT;

-- Verificar resultado da transação
SELECT f.nome, f.departamento, l.Descricao, l.DataTransacao
FROM funcionarios f
JOIN log_transacoes l ON f.id = l.FuncionarioID
WHERE f.id = @funcionario_id;

-- =========================================================
-- 3. CONTROLE DE ACESSO
-- =========================================================

-- Conceder permissões básicas ao usuário júnior (apenas SELECT)
GRANT SELECT ON empresa.funcionarios TO 'usuario_junior'@'localhost';
GRANT SELECT ON empresa.log_transacoes TO 'usuario_junior'@'localhost';

-- Conceder permissões completas ao usuário sênior
GRANT SELECT, INSERT, UPDATE ON empresa.funcionarios TO 'usuario_senior'@'localhost';
GRANT SELECT, INSERT, UPDATE ON empresa.log_transacoes TO 'usuario_senior'@'localhost';

-- Aplicar as mudanças de privilégios
FLUSH PRIVILEGES;

-- Verificar privilégios dos usuários
SHOW GRANTS FOR 'usuario_junior'@'localhost';
SHOW GRANTS FOR 'usuario_senior'@'localhost';

-- =========================================================
-- REVOGAR PERMISSÕES DE ATUALIZAÇÃO DE SALÁRIO (JÚNIOR)
-- =========================================================

-- Garantir que usuário júnior NÃO pode modificar salários
-- (já está restrito com apenas SELECT, mas vamos ser explícitos)
REVOKE UPDATE ON empresa.funcionarios FROM 'usuario_junior'@'localhost';

-- =========================================================
-- TESTES DE FUNCIONALIDADE
-- =========================================================

-- Testar se o evento está funcionando (simulação)
-- Nota: Em ambiente real, aguardaria 1 ano. Para teste, podemos executar manualmente:
-- UPDATE funcionarios SET salario = salario * 1.03;

-- Verificar logs de transações
SELECT * FROM log_transacoes ORDER BY DataTransacao DESC;

-- Verificar estrutura final
SELECT 
    nome,
    departamento,
    salario
FROM funcionarios
ORDER BY departamento, nome;

-- =========================================================
-- VERIFICAÇÃO DE EVENTOS ATIVOS
-- =========================================================

-- Listar eventos criados
SELECT 
    EVENT_NAME,
    STATUS,
    EVENT_TYPE,
    INTERVAL_VALUE,
    INTERVAL_FIELD,
    STARTS,
    EVENT_DEFINITION
FROM INFORMATION_SCHEMA.EVENTS
WHERE EVENT_SCHEMA = 'empresa';

-- =========================================================
-- FIM DO SCRIPT
-- =========================================================
