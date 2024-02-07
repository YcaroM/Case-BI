--Criação de tabela de transação

create table tbvendas_f(
CodCliente int,
Categoria varchar(50),
Subcategoria varchar(50),
Produto varchar(50),
Ano int,
Mes int,
Cidade varchar(50),
Valor float,
Volume float)

-- CARGA DE DADOS VIA BULK INSERT
-- Bulk insert é um mecanismo para realizar uma carga massiva de dados na tabela.
BULK INSERT tbvendas_f
	FROM 'C:\Users\ycaro\OneDrive\Desktop\CASE\vendas.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)

--Criação da tabela de potencial de venda

create table tbpotencial_f(
CodCliente int,
Ano int,
Area_Comercial float,
Area_Hibrida float,
Area_Residencial float,
Area_Industrial float,
ValorPotencial float
)

select * from tbpotencial_f

truncate table tbpotencial_f

BULK INSERT tbpotencial_f
	FROM 'C:\Users\ycaro\OneDrive\Desktop\CASE\potencial.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)

-- Criar índices para as colunas das tabelas

CREATE INDEX index_pot ON tbpotencial_f(CodCliente);
CREATE INDEX index1 ON tbvendas_f(CodCliente);