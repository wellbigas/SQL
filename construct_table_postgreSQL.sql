-- passo 1
integer
real
serial
numeric

varchar(n)
char(n)
text

boolean

date
time
timestamp

DROP TABLE aluno, aluno_curso, curso;
-- passo 2
create table aluno (
    id serial PRIMARY KEY,
    nome varchar(255),
    cpf char(11) UNIQUE NOT NULL,
    observacao text, 
    idade integer,
    dinheiro numeric (10,2),
    altura real,
    ativo boolean,
    data_nascimento date NOT NULL,
    hora_alura time,
    matriculado_em timestamp
)

--passo 3
select * from aluno

--passo 4
insert into aluno (
    nome, 
    cpf,
    observacao,
    idade,
    dinheiro,
    altura,
    ativo,
    data_nascimento,
    hora_alura,
    matriculado_em
) 
values (
    'wellington', 
    '08393817943',
    'aluno matriculado',
    28,
    145.99,
    1.75,
    true,
    '1994-07-16',
    '18:35:00',
    '2022-06-22 15:39:00'
)
--passo 5
select * from aluno
--passo 6

update aluno 
    set nome = 'Wellington Luís Moreno Bigas',
    cpf = '12345678910'
where id = 1

--passo 7 inserir mais informações 
insert into aluno (
     nome, 
     cpf,
     observacao,
     idade,
     dinheiro,
     altura,
     ativo,
     data_nascimento,
     hora_alura,
     matriculado_em
)
values (
    'Julio Cesar de Souza Mauro', 
    '59328007432', 
    'aluno matriculado', 
    22,590.50, 
    1.82, true, 
    '2000-06-13', 
    '20:40:00', 
    '2022-06-22 16:06:00'
)
--passo 8
select * from aluno

--passo 9 deletar uma linha
begin; -- antes de deletar, importante utilizar o BEGIN caso precisar retornar, pois foi deletado a coluna errada ou sem colocar um WHERE. 

delete 
    from aluno
where id = 3

rollback; -- é importante o ROLLBACK, caso ao verificar que foi deletado o conteúdo errado você pode utilizar essa função para voltar antes do detelete, onde foi usando o BEGIN para isso.
commit; -- é caso tiver certeza que foi deletado o conteúdo correto. 

insert into aluno (nome) values ('Meteus Aguiar');
insert into aluno (nome, cpf, data_nascimento) values ('Eliane Moreno Galante Bigas', '12579848557', '1966-11-17' );
insert into aluno (nome) values ('Valdir Bigas');
insert into aluno (nome) values ('Fabíola Moreno Bigas ');
insert into aluno (nome, cpf, data_nascimento) values ('Thiago Morello', '45897882535', '1988-09-20');
insert into aluno (nome, cpf, data_nascimento) values ('Lucas Morello', '45897579535', '1991-01-27');
insert into aluno (nome, cpf, data_nascimento) values ('Rafaela Morello', '45892342535', '1995-07-15');
insert into aluno (nome, cpf, data_nascimento) values ('Douglas Pitz', '45897652535', '1996-09-07');
insert into aluno (nome, cpf, data_nascimento) values ('Juliana Rosa', '45897821635', '1999-09-10');
insert into aluno (nome, cpf, data_nascimento) values ('Gabriel Bigas Mauro', '03597821635', '1997-11-21');
insert into aluno (nome, cpf, data_nascimento) values ('William Bigas Mauro', '00297821635', '2004-05-10');
insert into aluno (nome, cpf, data_nascimento) values ('Josiel Soares', '00397821635', '1994-09-13');


-- update no id do aluno
update aluno set ativo = 'true' where id = 5
update aluno set observacao = 'aluno matriculado' where id = 5




-- Criar tabela com coluna primary
drop table curso; -- deletar tabela 
create table curso (
    id serial, -- TIRAR DUVIDA COM WILL, PORQUE QUANDO TENTO INSERIR ALGO QUE NÃO É POSSIVEL, MESMO ASSIM GERA UM SERIAL ID
    codigo integer PRIMARY KEY, -- UNIQUE PARA NÃO CONSEGUIR REPETIR O CÓDIGO OU DEFINIR COMO 'PRIMARY KEY' PARA DEFINIR QUE É UMA CHAVE UNICA
    nome varchar (255) not null
)

select * from curso



-- não é possivel inserir nenhuma dessa informações no insert pois algum dos campos são nullo, sendo que foi setado ao criar tabela, que não seria possivel realizar esse insert. 
insert into curso (codigo, nome) values (null, null)
insert into curso (codigo, nome) values (1, null)
insert into curso (codigo, nome) values (null, 'curso de HTML')

-- criado as infomrações do curso
insert into curso (codigo, nome) values (23, 'curso de HTML');
insert into curso (codigo, nome) values (12, 'java script');
insert into curso (codigo, nome) values (25, 'Java');

-- selecionar as tabelas que serão relacionadas 
select * from aluno
select * from curso

--alterar nome da coluna na tabela 
alter table curso rename id_curso to codigo_curso

drop table aluno_curso; -- remover taela
-- criar uma tabela de relacionamento entre curso e aluno.
create table aluno_curso (
    aluno_id integer,
    curso_id integer,
    primary key (aluno_id, curso_id),
    --ON DELETE CASCATE,
    
    foreign key (aluno_id)
    references aluno (id),
    foreign key (curso_id)
    references curso (codigo)
    )
    
-- select na tabela
select * from aluno_curso

-- inserir curso para aluno utilizando insert 
 
insert into aluno_curso (aluno_id, curso_id) values (1,23);
insert into aluno_curso (aluno_id, curso_id) values (2,23);
insert into aluno_curso (aluno_id, curso_id) values (3,23);

insert into aluno_curso (aluno_id, curso_id) values (5,25)

select * from aluno_curso
select * from aluno

select
    a.id as "ID Aluno",
    a.nome as "Nome do Aluno",
    a.cpf as "CPF do Aluno",
    a.observacao as "Observações",
    c.nome as "Nome do curso",
    ac.curso_id as "ID Curso",
    a.ativo as "Ativo"
from aluno a 
left join aluno_curso ac on ac.aluno_id = a.id 
left join curso c on c.codigo = ac.curso_id
order by a.id


