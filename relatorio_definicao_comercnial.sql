select *                                                                                                                                                                                       
  from (                                                                                                                                                                                       
     select
       'Nome Campanha',
       'Data Início',
       'Data Fim',
       'Lojas',
       'Seqproduto',		   
       'Descrição',                                                                                                                                                                          
       'Descrição Secundaria',                                                                                                                                                                             
       'Limite por Cliente', 
       'Tipo Oferta',
       'PMZ',
       'Verba Sell Out',
       'Preco De',                                                                                                                                                                               
       'Preço Varejo',
       'Cartão Guanabara',
       'Clube + Amigo',
       'Observações',
       'Projeeção Venda',
       'Link Imagem'
         ) as x                                                                                                                                                                             
   union all                                                                                                                                                                                   
(
select 
	concat(c.seqcampanha, ' -', c.nome) as campanha,
	to_char(c.inicio, 'DD-MM-YYYY') as data_inicio,
	to_char(c.fim, 'DD-MM-YYYY') as data_fim,
	array_to_string(array_agg(distinct(l.loja)),', ') as loja,
	p.seqproduto::text as seqproduto,
	o.descricao::text as descrocao_oferta,
	o.campos->>'subtitulo' as descricao_secundaria,
	o.regra->>'limite_por_cliente' as limite_cliente,
	
	case o.regra->>'tipo'
      when 'normal'
        then 'NORMAL'
      when 'fidelidade'
        then 'CLUBE + AMIGO'
      when 'fidelidade-muffato'
        then 'CARTÃO GUANABARA'
      else ''
    end as tipo_oferta,
   
    round(((avg(pl.custo_liquido))::numeric/(1-((pl.aliquota)::numeric / 100))), 2)::text as pmz,
    
      case true
	  		when po.sellout is null or po.sellout = 0
				then round(coalesce(o.sellout, 0), 2)::text
			else round(po.sellout, 2)::text
	  end as sellout,
    
	min(to_char((o.regra->>'preco_de')::numeric, '"R$ "FM999G999G990D00')) as preco_de,
	
	case o.regra->>'tipo'
		when 'normal'
			then to_char((o.regra->>'preco_granel')::numeric, '"R$ "FM999G999G990D00')
		when 'fidelidade'
			then to_char((o.regra->>'preco_normal')::numeric, '"R$ "FM999G999G990D00')
		when 'fidelidade-muffato'
			then to_char((o.regra->>'preco_normal')::numeric, '"R$ "FM999G999G990D00')
		else '?'
	end as preco_varejo,
	
	case o.regra->>'tipo'
		when 'fidelidade-muffato'
			then to_char((o.regra->>'preco_fidelidade')::numeric, '"R$ "FM999G999G990D00')
		else ''
	end as cartao_guanabara,
	
	case o.regra->>'tipo'
		when 'fidelidade'
			then to_char((o.regra->>'preco_fidelidade')::numeric, '"R$ "FM999G999G990D00')
		else ''
	end as clube_amigo,
	--array_to_string(array_agg(distinct(m.mensagem)),', ')::text as observacao
	max(coalesce(m.mensagem, ''))::text as observacao,
	--round(po.projecao_venda, 2)::text as projecao_venda
	round(sum(po.projecao_venda),2)::text as projecao_venda,
	max(coalesce(i.url, '')) as url
from smarket_produto_ofertado po
inner join smarket_oferta o on o.seqoferta = po.seqoferta
inner join smarket_produto p on p.seqproduto = po.seqproduto
inner join smarket_campanha c on c.seqcampanha = o.seqcampanha
inner join smarket_campanha_lojas cl on cl.campanha_id = c.seqcampanha 
inner join smarket_loja l on l.seqloja = cl.loja_id 
left join smarket_imagem_oferta io on io.seqoferta = o.seqoferta 
left join smarket_imagem i on i.seqimagem = io.seqimagem
left join smarket_mensagem m on m.oferta = po.seqoferta 
join (select aliquota,seqloja,custo_liquido,seqproduto from smarket_produto_loja group by 1,2,3,4) pl on pl.seqloja = cl.loja_id and pl.seqproduto = po.seqproduto
where c.seqcampanha = 131
group by c.seqcampanha, p.seqproduto, o.descricao,o.campos, o.regra, po.sellout, o.sellout, po.projecao_venda, pl.aliquota
order by 4,5
);
