# Projeto SQL para geração de insights para uma empresa de venda de motos
## O projeto visa coletar dados das tabelas Vendas.csv e Potencial.csv de uma vendedora de motos fictícia e fazer uma primeira extração de Insights via MySQLServer

Primeiramente criamos tabelas de transação e de potencial de vendas, após isso carregamos os dados das tabelas via BULK INSERT e criamos índices para os dados.
Após isso, utilizamos tabelas temporárias para gerar diversos dados que nos possibilitam gerar insights para a empresa. 

## Alguns dos dados gerados foram: 
1) Total de clientes em potencial por ano;
2) Quantidade real de clientes por ano;
3) Porcentagem do valor de vendas em determinada área;
4) Valores de venda para as top 10 cidades.
etc.

Ycaro César Albano Martins
