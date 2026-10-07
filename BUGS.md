
🐜 BUG 01: Cobrança indevida de frete no limite exato de R$ 200,00

• Descrição: O sistema cobra taxa de frete fixo de R$ 19,90 mesmo quando o subtotal dos produtos atinge o valor exato da fronteira de frete grátis (R$ 200,00). O critério de aceite CA06 especifica explicitamente que o frete deve ser gratuito para valores a partir de R$ 200,00, inclusive.
• Passos para reproduzir: Enviar uma requisição POST para /api/carrinho/calcular com o item P005 e quantidade 2 (Subtotal = R$ 200,00).
• Resultado esperado: frete: 0, freteGratis: true, valorFaltanteFreteGratis: 0.
• Resultado real: frete: 19.9, freteGratis: false, valorFaltanteFreteGratis: 0, total: 219.9.
• Severidade: Alta (Impacta diretamente a regra financeira e engana o cliente).

🐜 BUG 02: Ausência de validação para quantidade máxima de produtos permitida na API

• Descrição: A API de cálculo do carrinho aceita a inclusão de 6 ou mais unidades de um único produto, ignorando completamente a restrição descrita no critério de aceite CA10, que estipula o teto máximo de 5 unidades por item para a Interface e para a API.
• Passos para reproduzir: Enviar uma requisição POST para /api/carrinho/calcular contendo o item P008 com quantidade 6.
• Resultado esperado: Retorno de erro HTTP 422 Unprocessable Entity com o código QUANTIDADE_MAXIMA_EXCEDIDA.
• Resultado real: Retorno HTTP 200 OK, processando o carrinho normalmente com dotação total de 6 itens.
• Severidade: Média (Falta de validação de regras de negócio na camada de backend)