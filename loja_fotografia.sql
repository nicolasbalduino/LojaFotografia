CREATE DATABASE Fuji;
GO
use Fuji;

CREATE TABLE Produto (
    [codigo]      INT             NOT NULL IDENTITY,
    [descricao]   VARCHAR(100)    NOT NULL,
    [qtdMinima]   INT             NOT NULL,
    [qtdEstoque]  INT             NOT NULL,
    [tipo]        INT             NOT NULL,
    [precoCusto]  DECIMAL(5,2)    NOT NULL,
    [precoVenda]  DECIMAL(5,2)    NOT NULL,

    CONSTRAINT PK_Produto PRIMARY KEY ([codigo])
);

CREATE TABLE ClienteFisico (
    [codigo]      INT             NOT NULL IDENTITY,
    [nome]        VARCHAR(100)    NOT NULL,
    [foneRes]     VARCHAR(10),
    [foneCom]     VARCHAR(11),
    [foneCel]     VARCHAR(11),
    [rg]          VARCHAR(14)     NOT NULL,
    [cpf]         VARCHAR(11)     NOT NULL,
    [sexo]        CHAR            NOT NULL,
    [dataNasc]    DATE            NOT NULL,
    [logradouro]  VARCHAR(120)    NOT NULL,
    [numero]      INT,
    [cep]         VARCHAR(8)      NOT NULL,
    [bairro]      VARCHAR(100)    NOT NULL,
    [complemento] VARCHAR(10),
    [localidade]  VARCHAR(10),
    [uf]          CHAR(2)         NOT NULL,

    CONSTRAINT PK_PessoaFisica PRIMARY KEY ([codigo]),
    CONSTRAINT UN_ClienteFisico_Cpf UNIQUE([cpf])
);

CREATE TABLE ClienteJuridico (
    [codigo]          INT           NOT NULL IDENTITY,
    [nome]            VARCHAR(100)  NOT NULL,
    [foneRes]         VARCHAR(10),
    [foneCom]         VARCHAR(11),
    [foneCel]         VARCHAR(11),
    [cnpj]            VARCHAR(14)   NOT NULL,
    [inscEstad]       VARCHAR(11),
    [nomeResponsavel] VARCHAR(100)  NOT NULL,
    [logradouro]      VARCHAR(120)    NOT NULL,
    [numero]          INT,
    [cep]             VARCHAR(8)      NOT NULL,
    [bairro]          VARCHAR(100)    NOT NULL,
    [complemento]     VARCHAR(10),
    [localidade]      VARCHAR(10),
    [uf]              CHAR(2)         NOT NULL,

    CONSTRAINT PK_PessoaJuridica PRIMARY KEY ([codigo]),
    CONSTRAINT UN_ClienteJuridico_Cnpj UNIQUE([cnpj])
);

CREATE TABLE Funcionario (
    [codigo]      INT           NOT NULL IDENTITY,
    [nome]        VARCHAR(100)  NOT NULL,
    [foneRes]     VARCHAR(10),
    [foneCom]     VARCHAR(11),
    [foneCel]     VARCHAR(11)   NOT NULL,
    [rg]          VARCHAR(14)   NOT NULL,
    [cpf]         VARCHAR(11)   NOT NULL,
    [sexo]        CHAR          NOT NULL,
    [dataNasc]    DATE          NOT NULL,
    [logradouro]  VARCHAR(120)    NOT NULL,
    [numero]      INT,
    [cep]         VARCHAR(8)      NOT NULL,
    [bairro]      VARCHAR(100)    NOT NULL,
    [complemento] VARCHAR(10),
    [localidade]  VARCHAR(10),
    [uf]          CHAR(2)         NOT NULL,

    CONSTRAINT PK_Funcionario PRIMARY KEY ([codigo]),
    CONSTRAINT UN_Funcionario_Cpf UNIQUE([cpf])
);

CREATE TABLE Venda (
    [numero]            INT             NOT NULL IDENTITY,
    [dataVenda]         DATETIME        NOT NULL DEFAULT(GETUTCDATE() - 3),
    [condPagt]          CHAR(2)         NOT NULL,
    [valorVenda]        DECIMAL(7,2),
    [codCliente]        INT             NOT NULL,
    [tipoCliente]       CHAR(2)         NOT NULL, -- CF, CJ
    [codFuncionario]    INT             NOT NULL,

    CONSTRAINT PK_Venda                 PRIMARY KEY ([numero]),
    CONSTRAINT FK_Venda_Funcionario     FOREIGN KEY ([codFuncionario]) REFERENCES Funcionario(codigo)
    -- no momento de inserir um endereco ocorre conflito por causa das FKs 
    -- teoricamente eh necessario que o valor a ser inserido exista nas 2 tabelas
    -- CONSTRAINT FK_Venda_ClienteFisico   FOREIGN KEY ([codCliente])     REFERENCES ClienteFisico(codigo),
    -- CONSTRAINT FK_Venda_ClienteJuridico FOREIGN KEY ([codCliente])     REFERENCES ClienteJuridico(codigo),
);

CREATE TABLE VendaItem (
    [numVenda]        INT             NOT NULL,
    [codProduto]      INT             NOT NULL,
    [precoVenda]      DECIMAL(7,2)    NOT NULL,
    [qtd]             INT             NOT NULL,
    [valorTotalItem]  DECIMAL(7,2)    NOT NULL,

    CONSTRAINT PK_VendaItem         PRIMARY KEY (numVenda, codProduto),
    CONSTRAINT FK_VendaItem_Venda   FOREIGN KEY (numvenda)      REFERENCES Venda(numero),
    CONSTRAINT FK_VEndaItem_Produto FOREIGN KEY (codProduto)    REFERENCES Produto(codigo)
);
GO

CREATE OR ALTER PROC InsertFuncionario 
@Nome VARCHAR(100), @FoneRes VARCHAR(10), @FoneCom VARCHAR(11), @FoneCel VARCHAR(11), 
@Rg VARCHAR(14), @Cpf VARCHAR(11), @Sexo CHAR, @DataNasc DATE, @Logradouro VARCHAR(120), @Numero INT, @Cep VARCHAR(8), 
@Bairro VARCHAR(100), @Complemento VARCHAR(10), @Localidade VARCHAR(10), @Uf CHAR(2)
AS
BEGIN
    INSERT INTO Funcionario (nome, foneRes, foneCom, foneCel, rg, cpf, sexo, dataNasc, logradouro, numero, cep, 
                                bairro, complemento, localidade, uf) VALUES (
        @Nome,
        @FoneRes,
        @FoneCom,
        @FoneCel,
        @Rg,
        @Cpf,
        @Sexo,
        @DataNasc,
        @Logradouro,
        @Numero,
        @Cep,
        @Bairro,
        @Complemento,
        @Localidade,
        @Uf
    );
END;
GO

CREATE OR ALTER PROC InsertClienteFisico 
@Nome VARCHAR(100), @FoneRes VARCHAR(10), @FoneCom VARCHAR(11), @FoneCel VARCHAR(11), 
@Rg VARCHAR(14), @Cpf VARCHAR(11), @Sexo CHAR, @DataNasc DATE, @Logradouro VARCHAR(120), @Numero INT, @Cep VARCHAR(8), 
@Bairro VARCHAR(100), @Complemento VARCHAR(10), @Localidade VARCHAR(10), @Uf CHAR(2)
AS
BEGIN
    INSERT INTO ClienteFisico (nome, foneRes, foneCom, foneCel, rg, cpf, sexo, dataNasc, logradouro, numero, cep, 
                    bairro, complemento, localidade, uf) VALUES (
        @Nome,
        @FoneRes,
        @FoneCom,
        @FoneCel,
        @Rg,
        @Cpf,
        @Sexo,
        @DataNasc,
        @Logradouro,
        @Numero,
        @Cep,
        @Bairro,
        @Complemento,
        @Localidade,
        @Uf
    );
END;
GO

CREATE OR ALTER PROC InsertClienteJuridico 
@Nome VARCHAR(100), @FoneRes VARCHAR(10), @FoneCom VARCHAR(11), @FoneCel VARCHAR(11), 
@Cnpj VARCHAR(14), @InscEstad VARCHAR(11), @NomeResponsavel VARCHAR(100), @Logradouro VARCHAR(120), @Numero INT, @Cep VARCHAR(8), 
@Bairro VARCHAR(100), @Complemento VARCHAR(10), @Localidade VARCHAR(10), @Uf CHAR(2)
AS
BEGIN
    INSERT INTO ClienteJuridico (nome, foneRes, foneCom, foneCel, cnpj, inscEstad, nomeResponsavel, logradouro, numero, cep, 
                                    bairro, complemento, localidade, uf) VALUES (
        @Nome,
        @FoneRes,
        @FoneCom,
        @FoneCel,
        @Cnpj,
        @InscEstad,
        @NomeResponsavel,
        @Logradouro,
        @Numero,
        @Cep,
        @Bairro,
        @Complemento,
        @Localidade,
        @Uf
    );
END;
GO

CREATE OR ALTER PROC InsertProduto 
@Descricao VARCHAR(100), @QtdMinima INT, @QtdEstoque INT, @Tipo INT, @PrecoCusto DECIMAL(5,2)
AS
BEGIN
    INSERT INTO Produto (descricao, qtdMinima, qtdEstoque, tipo, precoCusto, precoVenda) VALUES (
        @Descricao,
        @QtdMinima,
        @QtdEstoque,
        @Tipo,
        @PrecoCusto,
        (@PrecoCusto * 2)
    );
END;
GO

CREATE OR ALTER PROC InsertVenda 
@CondPagt CHAR(2), @TipoCliente CHAR(2), @CodCliente INT, @CodFuncionario INT
AS
BEGIN
    INSERT INTO Venda (condPagt, codCliente, tipoCliente, codFuncionario) VALUES (
        @CondPagt,
        @CodCliente,
        @TipoCliente,
        @CodFuncionario
    );
END;
GO

EXEC.InsertFuncionario 'Nicolas', '', '', '16997654312', '568174793', '45962709888', 'M', '2001-05-29', 'Rua Waldemar Simões', 120, '15910000', 'São Guilherme', '', '', 'SP';
GO
EXEC.InsertClienteFisico 'Antonoio', '', '', '16997654312', '568174793', '45962709888', 'M', '2001-05-28', 'Rua Waldemar Simões', 120, '15910000', 'São Guilherme', '', '', 'SP';
GO
EXEC.InsertClienteJuridico 'Balduino LTDA.', '', '', '', '132', '321', 'Nicolas Balduino', 'Rua Waldemar Simões', 120, '15910000', 'São Guilherme', '', '', 'SP';
GO
EXEC.InsertProduto 'Album de Foto', 2, 2, 1, 10.00;
GO
EXEC.InsertVenda 'CC', 'CF', 1, 1;