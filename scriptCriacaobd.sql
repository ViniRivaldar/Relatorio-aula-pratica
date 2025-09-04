-- Criação do banco de dados MoveRent
CREATE SCHEMA MoveRent;
USE MoveRent;

-- Criação da tabela PESSOA
CREATE TABLE PESSOA (
    CPF VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    INDEX idx_nome (nome),
    INDEX idx_email (email)
);

-- Criação da tabela CICLOMOTOR
CREATE TABLE CICLOMOTOR (
    IDCM INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    cor VARCHAR(30) NOT NULL,
    INDEX idx_nome_ciclo (nome),
    INDEX idx_ano (ano)
);

-- Criação da tabela LOCACAO
CREATE TABLE LOCACAO (
    IDLOC INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    local VARCHAR(200) NOT NULL,
    CPF VARCHAR(11) NOT NULL,
    IDCM INT NOT NULL,
    FOREIGN KEY (CPF) REFERENCES PESSOA(CPF)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (IDCM) REFERENCES CICLOMOTOR(IDCM)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_data (data),
    INDEX idx_cpf_fk (CPF),
    INDEX idx_idcm_fk (IDCM)
);

-- Criação da tabela TRAJETO
CREATE TABLE TRAJETO (
    IDTRAJETO INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    local VARCHAR(200) NOT NULL,
    IDLOC INT NOT NULL,
    FOREIGN KEY (IDLOC) REFERENCES LOCACAO(IDLOC)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_data_trajeto (data),
    INDEX idx_idloc_fk (IDLOC)
);

-- Inserção de dados de exemplo
INSERT INTO PESSOA (CPF, nome, email, telefone) VALUES
('12345678901', 'João Silva', 'joao.silva@email.com', '11987654321'),
('98765432101', 'Maria Santos', 'maria.santos@email.com', '11876543210');

INSERT INTO CICLOMOTOR (nome, ano, cor) VALUES
('Eco Bike 2024', 2024, 'Verde'),
('Urban Scooter', 2023, 'Azul'),
('City Rider', 2024, 'Vermelho');

INSERT INTO LOCACAO (data, hora, local, CPF, IDCM) VALUES
('2024-09-03', '08:30:00', 'Estação Vila Madalena', '12345678901', 1),
('2024-09-03', '14:15:00', 'Estação Faria Lima', '98765432101', 2);

INSERT INTO TRAJETO (data, hora, local, IDLOC) VALUES
('2024-09-03', '08:35:00', 'Rua Harmonia, 123', 1),
('2024-09-03', '08:40:00', 'Av. Paulista, 1000', 1),
('2024-09-03', '14:20:00', 'Rua Bela Cintra, 500', 2);
