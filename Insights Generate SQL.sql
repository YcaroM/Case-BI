-- Relacionando as tabelas e salvando em tabelas temporárias

select		V.Ano,
			V.CodCliente,
			sum(distinct P.ValorPotencial) as ValorPotencial,
			sum(V.Valor) as ValorVendas
into		#temp1
from		tbvendas_f V
inner join	tbpotencial_f P
on			V.CodCliente = P.CodCliente
and			V.Ano = P.Ano
group by	V.Ano,V.CodCliente

select * from #temp1

-- Formatação dos números 

select Ano,
	format(sum(ValorPotencial),'###,##0.00','pt-br') as ValorPotencial,
	format(sum(ValorVendas),'###,##0.00','pt-br') as ValorVendas,
	format(sum(ValorPotencial) - sum(ValorVendas),'###,##0.00','pt-br') as Oportunidade,
	abs(((sum(ValorVendas)/sum(ValorPotencial))*100)-100) [Oportunidade%]
from #temp1
group by Ano
order by Ano

--Gerando insights sobre a expectativa de oportunidade de vendas e sobre a porcentagem alcançada
select Ano,
		round(abs(((sum(ValorVendas)/sum(ValorPotencial))*100)-100),1) [Oportunidade%],
		round(abs(abs(((sum(ValorVendas)/sum(ValorPotencial))*100)-100)-100),1) [Alcançado%]
from #temp1
group by Ano
order by Ano


-- Insights sobre o Valor total arrecadado entre os produtor por ano através de uma tabela pivot
select *
from	(
		select Ano,
				Categoria,
				Valor
		from	tbvendas_f
		) T 
pivot (sum(Valor) for Categoria in ([X],[XTZ250],[XT660],[CB750])) C
order by Ano

--Total de clientes em potencial por ano
select P.Ano, count(distinct CodCliente) as Qtde
from tbpotencial_f P
where not exists (select.1
					from tbvendas_f V
					where V.CodCliente = P.CodCliente
					and V.Ano = P.Ano
					)
group by P.Ano


-- Insight sobre a quantidade de clientes reais por ano
select	Ano,
		count(distinct CodCliente) as QtdeClientes
from tbvendas_f
group by Ano
order by Ano

--Criação de tabela que mostra VALOR TOTAL DE COMPRAS por ÁREA e VALOR TOTAL DAS VENDAS EM POTENCIAL
select Ano,
		sum(Area_Comercial) as VALOR_Area_Comercial,
		sum(Area_Hibrida) as VALOR_Area_Hibrida,
		sum(Area_Industrial) as VALOR_Area_Industrial,
		sum(Area_Residencial) as VALOR_Area_Residencial,

		sum(Area_Comercial) + 
		sum(Area_Hibrida) +
		sum(Area_Industrial) +
		sum(Area_Residencial) as VALOR_AreaTotal,

		sum(ValorPotencial) as ValorVendasPotencial
into #tmp_nc
from tbpotencial_f P
where not exists (select 1
					from tbvendas_f V
					where P.CodCliente = V.CodCliente
					and V.Ano = P.Ano)
group by Ano

select * from #tmp_nc order by Ano

-- Transformar em porcentagem a quantia proveniente de compras por área para gerar insights sobre o crescimento de compras em determinada região
select Ano,
		(Area_Comercial/AreaTotal)*100 as [Area_Comercial%],
		(Area_Hibrida/AreaTotal)*100 as [Area_Hibrida%],
		(Area_Industrial/AreaTotal)*100 as [Area_Industrial%],
		(Area_Residencial/AreaTotal)*100 as [Area_Residencial%],
		ValorVendasPotencial
from #tmp_nc order by Ano
  


--Análise por cidade:
--Gerando os valores para as top 10 cidades:
select *
into #tmp_cidades
from ( select top 10
		cidade,
		sum(valor) as Valor
		from tbvendas_f
		group by Cidade
		order by 2 desc)
x order by 2

select * from #tmp_cidades 

select round(sum(valor),2) as ValoTotal from #tmp_cidades

--Percentual das 10 cidades:
declare @total_top10 as float
select @total_top10 = sum(valor) from #tmp_cidades
select round(@total_top10/sum(valor)*100,2) as Perc from tbvendas_f

--Total de clientes nas top 10 cidades:
select count(distinct CodCliente) as QtdClientes from tbvendas_f where Cidade in (select Cidade from #tmp_cidades) 
--Total de transações nas top 10 cidades: 
select count(CodCliente) as QtdTransacoes from tbvendas_f where Cidade in (select Cidade from #tmp_cidades)
--Total de transações em todas as cidades:
select count(codcliente) as TotTransacoes from tbvendas_f

