module pontesCariri

-- Criando uma cidade generica.
abstract sig Cidade {}

-- Criando as regioes da cidade
one sig Norte extends Cidade {}
one sig Leste extends Cidade {}
one sig Oeste extends Cidade {}
one sig Sul extends Cidade {}

-- Ponte generica para o problema, a ponte servira de conexao para as regioes da cidade.
abstract sig Ponte {
	conexoes : set Cidade 
} 

-- Pontes especificas do problema, utilizando uniao para representar as conexoes especificas entre as regioes do problema do problema.
one sig Ponte1 extends Ponte {} {conexoes = Norte + Oeste}
one sig Ponte2 extends Ponte {} {conexoes = Norte + Oeste}
one sig Ponte3 extends Ponte {} {conexoes =  Norte + Leste}
one sig Ponte4 extends Ponte {} {conexoes = Leste + Oeste}
one sig Ponte5 extends Ponte {} {conexoes = Leste + Sul}
one sig Ponte6 extends Ponte {} {conexoes = Sul + Oeste}
one sig Ponte7 extends Ponte {} {conexoes = Sul + Oeste}

-- Definicao de um caminho para cobertura das pontes, contendo um passo inicial. 
one sig Caminho { 
	passoInicial : Passo 
}

-- Definicao do passo para caminhar pelas pontes, o passo começa de um lado da ponte e termina do outro lado da mesma.
sig Passo {
	de, para: Cidade,
	via: Ponte,
	proximoPasso : lone Passo} {via.conexoes = de + para}

-- Funcao para caminhar pelas pontes, o destino do passo atual é o começo do próximo.
fun passos (c:Caminho) : set Passo {
	c.passoInicial.*proximoPasso
}

-- Predicado que cobre todas as pontes, um caminho gerado que consegue a cobertura total, uma caminho que cubra todas as pontes.
pred caminho {
	some c:Caminho | passos[c].via = Ponte
}

-- Fato que gera o caminho para "atravessarmos" as pontes.
fact {all p:Passo, proximo:p.proximoPasso | proximo.de = p.para}

-- Fato que garante que sempre ocorrerá próximos passos, para não ocorrer passos "flutuantes" no modelo. 
fact {all p:Passo, c:Caminho | (some p1:Passo | p = p1.proximoPasso or p = c.passoInicial)}

-- Fato que garante que se um passo atravessar uma ponte e outro passo atravessar a mesma ponte, então esse passos serão iguais.
fact {all a,b:Passo | (a.via = b.via) implies (a = b)}

-- Fato que define a quantiade de conexoes.
fact {all p:Ponte | #p.conexoes = 2}

-- Assert que garante que nao tera caminho vazio, pois nao faz sentido.
assert garanteNaoTemCaminhoVazio { all c:Caminho | some c.passoInicial }

-- Assert que garante a precedencia de passos, em passo inicial e proximo para outros casos. 
assert garantePrecedenciaDePassos {all p:Passo | some q:Passo, c:Caminho | p = q.proximoPasso or p = c.passoInicial}

-- Assert que garante a existencia de pelo menos um caminho.
assert contemCaminho {#Caminho >= 1}

pred show[]{}
run show
