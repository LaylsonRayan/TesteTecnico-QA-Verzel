# 🛒 Desafio Técnico - QA Verzel Store

Este repositório contém a estratégia de testes, documentação de cenários em Gherkin, relatórios de bugs encontrados e a automação de API desenvolvida para o processo seletivo de QA da **Verzel**.

O ambiente testado é uma API *stateless* hospedada em ambiente Cloudflare Workers, responsável por efetuar o cálculo de cupons de desconto e frete do carrinho de compras.

---

## 📂 Onde encontrar cada entrega?

Para facilitar a avaliação, o projeto foi estruturado seguindo as melhores práticas de mercado:

*   **Item 1 (Cenários em Gherkin):** Localizados na pasta `features/` (`features/cupons.feature` e `features/frete_e_limites.feature`).
*   **Item 2 & 4 (Execução e Evidências):** Documentados na tabela presente logo abaixo neste arquivo README.
*   **Item 3 (Report de Bugs):** Arquivo `BUGS.md` localizado na raiz do projeto.
*   **Item 5 (Automação Playwright):** Scripts localizados na pasta `tests/carrinho.spec.js`.
*   **Apoio Técnico (Requests Manuais):** Arquivo `api-requests/testes.http` utilizado para os testes manuais exploratórios via REST Client.

---

## 📊 Itens 2 & 4: Tabela de Execução de Testes e Evidências

Todos os cenários foram executados manualmente e validados através de chamadas HTTP diretas contra o endpoint de produção da API da Verzel Store.

| ID | Cenário de Teste | Endpoint | Payload Enviado | Resultado Esperado | Resultado Real Obtido | Status Final |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **01** | Fronteira exata do Frete Grátis (R\$ 200,00) | `/api/carrinho/calcular` | `P005` (Qtd: 2) | Frete: R\$ 0.00<br>freteGratis: true | Frete: R\$ 19.90<br>freteGratis: false | ❌ **FALHOU (Bug 01)** |
| **02** | Limite inferior do Frete Fixo | `/api/carrinho/calcular` | `P003` (Qtd: 1) | Frete: R\$ 19.90<br>Faltante: R\$ 10.10 | Frete: R\$ 19.90<br>Faltante: R\$ 10.10 |  **PASSOU** |
| **03** | Quebrar limite máximo de itens (Qtd: 6) | `/api/carrinho/calcular` | `P008` (Qtd: 6) | Status 422 ou erro de validação | Status 200 OK<br>Aceitou 6 unidades | ❌ **FALHOU (Bug 02)** |
| **04** | Aplicação de cupom válido (BEMVINDO10) | `/api/carrinho/calcular` | `P005` (Qtd: 1) + cupom | Desconto: R\$ 10.00<br>aplicado: true | Desconto: R\$ 10.00<br>aplicado: true |  **PASSOU** |
| **05** | Cupom com minúsculas e espaços | `/api/carrinho/calcular` | `P005` (Qtd: 1) + " bemvindo10 " | Desconto: R\$ 10.00<br>aplicado: true | Desconto: R\$ 10.00<br>aplicado: true |  **PASSOU** |
| **06** | Uso de cupom expirado no cálculo | `/api/carrinho/calcular` | `P005` (Qtd: 1) + VERAO2026 | Desconto: R\$ 0.00<br>mensagem: "Cupom expirado." | Desconto: R\$ 0.00<br>mensagem: "Cupom expirado." |  **PASSOU** |
| **07** | Criação de pedido com sucesso | `/api/pedidos` | Cliente válido + `P005` + Cupom válido | Status 201 Created<br>Retornar num. pedido | Status 201 Created<br>Pedido VZ-731244 |  **PASSOU** |
| **08** | Criar pedido com nome inválido | `/api/pedidos` | Nome: "Maria" (Sem sobrenome) | Status 422<br>Código: DADOS_INVALIDOS | Status 422<br>Código: DADOS_INVALIDOS |  **PASSOU** |
| **09** | Criar pedido com cupom expirado | `/api/pedidos` | Cliente válido + Cupom VERAO2026 | Status 422<br>Código: CUPOM_EXPIRADO | Status 422<br>Código: CUPOM_EXPIRADO |  **PASSOU** |

---

## 🛠️ Item 6: Como Rodar a Automação (Playwright)

Siga os passos abaixo para clonar o repositório, instalar as dependências e rodar os testes automatizados localmente em sua máquina.

### 📋 Pré-requisitos
Antes de começar, você vai precisar ter instalado em sua máquina:
*   [Node.js](https://nodejs.org) (Versão 18 ou superior recomendada)
*   [Git](https://git-scm.com)

### 🚀 Instalação e Execução

1. **Instale as dependências do projeto:**
   ```bash
   npm install
   ```

2. **Execute os testes automatizados:**
   ```bash
   npx playwright test
   ```

3. **Para visualizar o relatório detalhado da execução:**
   ```bash
   npx playwright show-report
   ```

> 💡 **Nota Importante sobre a Execução:** Ao rodar os testes, você notará que o cenário referente à fronteira de frete grátis irá falhar de propósito. Isso foi implementado intencionalmente para demonstrar a capacidade da automação de capturar regressões e erros ativos no endpoint de produção (mapeado detalhadamente no arquivo `BUGS.md`).
