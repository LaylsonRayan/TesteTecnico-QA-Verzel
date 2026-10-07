Funcionalidade: Aplicação de Cupons de Desconto no Carrinho
  Como um cliente da Verzel Store
  Quero aplicar um cupom de desconto no meu carrinho
  Para pagar menos na compra dos meus produtos

  Contexto:
    Dado que a API está disponível no endereço informado

  Cenário: Aplicação de cupom válido com 10% de desconto (CA01 e CA11)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade | cupom       |
      | P005      | 1          | BEMVINDO10  |
    Então o status da resposta deve ser 200
    E o subtotal deve ser 100.00
    E o desconto deve ser 10.00
    E o cupom deve retornar "aplicado" como verdadeiro
    E a mensagem deve ser "Cupom aplicado: 10% de desconto nos produtos."

  Cenário: Cupom válido digitado em formato misto/minúsculo (CA02)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade | cupom       |
      | P005      | 1          | bemVindo10  |
    Então o status da resposta deve ser 200
    E o desconto deve ser 10.00
    E o cupom deve constar como aplicado

  Cenário: Cupom válido contendo espaços nas extremidades (CA02)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade | cupom          |
      | P005      | 1          | " BEMVINDO10 " |
    Então o status da resposta deve ser 200
    E o desconto deve ser 10.00
    E o cupom deve constar como aplicado

  Cenário: Tentativa de uso de cupom inexistente no cálculo (CA03)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade | cupom       |
      | P005      | 1          | INVALIDO123 |
    Então o status da resposta deve ser 200
    E o desconto deve ser 0.00
    E o cupom deve retornar "aplicado" como falso
    E a mensagem deve ser "Cupom inválido."

  Cenário: Tentativa de uso de cupom expirado no cálculo (CA04)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade | cupom     |
      | P005      | 1          | VERAO2026 |
    Então o status da resposta deve ser 200
    E o desconto deve ser 0.00
    E o cupom deve retornar "aplicado" como falso
    E a mensagem deve ser "Cupom expirado."

  Cenário: Desconto do cupom não deve incidir sobre o valor do frete (CA09)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade | cupom       |
      | P005      | 1          | BEMVINDO10  |
    Então o subtotal deve ser 100.00
    E o frete cobrado deve ser 19.90
    E o desconto deve ser exatamente 10.00
    E o total final calculado deve ser 109.90

  Cenário: Erro ao tentar criar pedido final com cupom inválido
    Quando eu enviar uma requisição de criação de pedido para "/api/pedidos" com:

      | cliente.nome | cliente.email     | cliente.cep | produtoId | quantidade | cupom       |
      | Maria Silva  | maria@exemplo.com | 01310-100   | P005      | 1          | INVALIDO123 |
    Então o status da resposta deve ser 422
    E o corpo da resposta deve conter o código de erro "CUPOM_INVALIDO"

  Cenário: Erro ao tentar criar pedido final com cupom expirado
    Quando eu enviar uma requisição de criação de pedido para "/api/pedidos" com:

      | cliente.nome | cliente.email     | cliente.cep | produtoId | quantidade | cupom     |
      | Maria Silva  | maria@exemplo.com | 01310-100   | P005      | 1          | VERAO2026 |
    Then o status da resposta deve ser 422
    E o corpo da resposta deve conter o código de erro "CUPOM_EXPIRADO"


# language: pt
Funcionalidade: Validação das Regras do Carrinho e Pedidos - Verzel Store

  Contexto:
    Dado que o usuário interage com o ambiente de testes da API da Verzel Store

  Esquema do Cenário: Validar cálculo de cupons e frete no carrinho
    Quando enviar uma requisição POST para "/api/carrinho/calcular" com o produto "<produtoId>", quantidade <quantidade> e cupom "<cupom>"
    Então o status da resposta deve ser 200
    E o subtotal calculado deve ser <subtotal>
    E o desconto aplicado deve ser <desconto>
    E o frete cobrado deve ser <frete>
    E o valor total deve ser <total>

    Exemplos:

      | produtoId | quantidade | cupom        | subtotal | desconto | frete | total  |
      | P003      | 1          |              | 189.9    | 0        | 19.9  | 209.8  |
      | P005      | 1          | BEMVINDO10   | 100      | 10       | 19.9  | 109.9  |
      | P005      | 1          |  bemvindo10  | 100      | 10       | 19.9  | 109.9  |
      | P005      | 1          | VERAO2026    | 100      | 0        | 19.9  | 119.9  |

  Cenário: Bloqueio de criação de pedido com nome sem sobrenome
    Quando enviar uma requisição POST para "/api/pedidos" com o nome "Maria", e-mail "maria@exemplo.com" e produto "P005"
    Então o status da resposta deve ser 422
    E o código de erro retornado deve ser "DADOS_INVALIDOS"
    E a mensagem deve solicitar nome e sobrenome

  Cenário: Bloqueio de criação de pedido com cupom expirado
    Quando enviar uma requisição POST para "/api/pedidos" com dados do cliente válidos e o cupom "VERAO2026"
    Então o status da resposta deve ser 422
    E o código de erro retornado deve ser "CUPOM_EXPIRADO"
