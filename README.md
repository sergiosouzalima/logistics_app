Logistics App
================

Este serviço de logística, auxilia na entrega de mercadorias mostrando o melhor caminho entre dois pontos.

Ruby on Rails
-------------

Esta aplicação foi construída usando:

- Ruby 2.2.1
- Rails 4.2.3

Para saber mais [Installing Rails](http://railsapps.github.io/installing-rails.html).

Desafio
---------------

Criar este Webservices de entregas visando sempre o menor custo.

Para popular a base de dados o sistema precisa expor um Webservice que aceite o formato
de malha logística (exemplo abaixo), nesta mesma requisição o requisitante deverá
informar um nome para este mapa.

É importante que os mapas sejam persistidos para evitar que a cada novo deploy
todas as informações desapareçam.

O formato de malha logística é bastante simples, cada linha mostra uma
rota: ponto de origem, ponto de destino e distância entre os pontos em quilômetros.

- A B 10
- B D 15
- A C 20
- C D 30
- B E 50
- D E 30

Com os mapas carregados o requisitante irá procurar o menor valor de entrega e seu
caminho, para isso ele passará o mapa, nome do ponto de origem, nome do ponto de
destino, autonomia do caminhão (km/l) e o valor do litro do combustivel

Um exemplo de entrada seria, mapa SP, origem A, destino D, autonomia 10,
valor do litro 2,50; a resposta seria a rota A B D com custo de 6,25.

2.50 / 10 * 25 = 6.25


Motivação
-------------------------

Hoje em dia a construção de sites é uma realidade.

Ferramentas open source são largamente utilizadas e neste caso, o framework
Ruby On Rails para construção de soluções web, será usado.

Além de uma comunidade ativa sempre auxiliando desenvolvedores, Ruby On Rails
é baseado na linguagem Ruby, construída para tornar o desenvolvimento
de software mais amigável.

Ruby On Rails também permite a integração com outras linguagens e ferramentas
e caso seja necessário, esta solução poderá ser integrada com outras
tecnologias para questões de performance por exemplo.

Instalação
-------------------------

Ao instalar, para reinicializar e alimentar o banco de dados com dados de exemplo,
lembre-se de executar no diretório da aplicação:

- rake db:setup


### CONSULTA DE ROTAS
-------------------------

**Exemplo de consulta pelo browser:**

- [http://localhost:3000/api/v1/routes/get_route.json?map_name=SP&origin=A&destination=C&fuel_autonomy=10&fuel_price=2.5](http://localhost:3000/api/v1/routes/get_route.json?map_name=SP&origin=A&destination=C&fuel_autonomy=10&fuel_price=2.5)

**Exemplo de consulta pelo terminal, usando o comando curl:**

- $ curl "http://localhost:3000/api/v1/routes/get_route.json?map_name=SP&origin=A&destination=C&fuel_autonomy=10&fuel_price=2.5"

**Exemplo de resposta:**

```html
{
  "name":"SP",
  "status":"OK",
  "code":"OK",
  "fallback_msg":{
    "distance":20,"cost":5.0,"directions":["A","C"]
  }
}
```

**Exemplo de respostas com mensagem de erro:**

```html
{
  "name":"XX",
  "status":"ERROR",
  "code":"WRONG_DATA",
  "fallback_msg":"map_name not found"
}
```

```html
{
  "name":"SP",
  "status":"ERROR",
  "code":"WRONG_DATA",
  "fallback_msg":"origin route not found"
}
```

### CRIAÇAO DE MAPA
-----------------------------

**Exemplo de criaçao pelo terminal, usando o comando curl:**

- $ curl localhost:3000/api/v1/routes/create_map.json -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d @spec/fixtures/parameters.json

**Exemplo de resposta:**

```html
{"name":"SP","status":"OK","code":"OK","fallback_msg":"Map and routes created successfully"}
```

**Exemplo de resposta com mensagem de erro:**

```html
{"name":"SP","status":"ERROR","code":"WRONG_DATA","fallback_msg":"invalid parameter. 'Routes' must be a 3 elements hash"}
```

