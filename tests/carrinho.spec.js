const { test, expect } = require('@playwright/test');

const BASE_URL = 'https://verzel-store.qa-test-verzel-store.workers.dev/api';

test.describe('Testes de API - Verzel Store (Cálculo do Carrinho)', () => {

  // Cenário 1: Validar aplicação de cupom válido com sucesso
  test('Deve aplicar cupom BEMVINDO10 com 10% de desconto', async ({ request }) => {
    const response = await request.post(`${BASE_URL}/carrinho/calcular`, {
      data: {
        itens: [{ produtoId: 'P005', quantidade: 1 }],
        cupom: 'BEMVINDO10'
      }
    });

    expect(response.status()).toBe(200);
    const body = await response.json();

    expect(body.subtotal).toBe(100);
    expect(body.desconto).toBe(10); // 10% de 100
    expect(body.cupom.aplicado).toBe(true);
    expect(body.cupom.codigo).toBe('BEMVINDO10');
  });

  // Cenário 2: Validar tratamento de cupom inválido/inexistente
  test('Deve retornar que o cupom é inválido se enviado código inexistente', async ({ request }) => {
    const response = await request.post(`${BASE_URL}/carrinho/calcular`, {
      data: {
        itens: [{ produtoId: 'P005', quantidade: 1 }],
        cupom: 'CUPOM_ERRADO_123'
      }
    });

    expect(response.status()).toBe(200);
    const body = await response.json();

    expect(body.desconto).toBe(0);
    expect(body.cupom.aplicado).toBe(false);
    expect(body.cupom.mensagem).toBe('Cupom inválido.');
  });

  // Cenário 3: Automação do BUG encontrado - Fronteira do Frete Grátis (R\$ 200,00)
  // NOTA: Este teste vai falhar de propósito porque encontramos um bug real na API!
  test('Deve conceder frete grátis para subtotal exatamente igual a R\$ 200,00', async ({ request }) => {
    const response = await request.post(`${BASE_URL}/carrinho/calcular`, {
      data: {
        itens: [{ produtoId: 'P005', quantity: 2 }] // 2 mochilas = R\$ 200,00
      }
    });

    expect(response.status()).toBe(200);
    const body = await response.json();

    // Validações baseadas no critério de aceite CA06
    expect(body.subtotal).toBe(200);
    expect(body.freteGratis).toBe(true); 
    expect(body.frete).toBe(0);
  });

});
