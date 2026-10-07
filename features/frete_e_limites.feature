Funcionalidade: Regras de Cálculo de Frete
  Como um cliente da Verzel Store
  Quero que o frete seja calculado dinamicamente com base no valor dos meus produtos
  Para entender os custos de entrega ou o benefício do frete grátis

  Contexto:
    Dado que a API está disponível no endereço informado

  Cenário: Frete grátis ativado no valor exato da fronteira limite (CA06)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade |
      | P005      | 2          |
    Então o status da resposta deve ser 200
    E o subtotal deve ser exatamente 200.00
    E o frete deve ser 0.00
    E o campo freteGratis deve ser verdadeiro
    E o valorFaltanteFreteGratis deve ser 0.00

  Cenário: Frete fixo cobrado para valores abaixo de duzentos reais (CA07)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade |
      | P002      | 1          |
    Então o status da resposta deve ser 200
    E o subtotal deve ser 139.90
    E o frete deve ser 19.90
    E o campo freteGratis deve ser falso
    E o valorFaltanteFreteGratis deve ser exatamente 60.10

  Cenário: Frete grátis avaliado usando o valor antes da dedução do cupom (CA08)
    Quando eu enviar uma requisição de cálculo para "/api/carrinho/calcular" com:

      | produtoId | quantidade | cupom      |
      | P007      | 1          | BEMVINDO10 |
    Então o subtotal deve ser 229.90
    E o desconto aplicado deve ser 22.99
    E o frete deve permanecer como 0.00
    E o total final deve ser exatamente 206.91
