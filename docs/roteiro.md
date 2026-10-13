# Roteiro de aprendizado

## Etapa 1 — Cliente do formulário ao banco

Objetivo: compreender o caminho completo de uma informação entre aplicativo, servidor e banco.

- Flutter: widgets, estado do formulário, validação e chamadas HTTP.
- Java: classes, métodos, API HTTP, validação e tratamento de erros.
- PostgreSQL: tabela, identificador, inserção, consulta e unicidade do telefone.
- Integração: cadastrar um cliente e exibi-lo na lista após consultar a API.

Critérios: nome e telefone obrigatórios; telefone normalizado antes da comparação; duplicatas rejeitadas; erros apresentados com mensagens compreensíveis.

## Regras do negócio para as próximas etapas

- A primeira versão será de uso interno, com administrador e profissionais.
- Profissionais acessarão apenas sua própria agenda e resultados financeiros.
- Profissionais poderão cadastrar clientes, serviços e pacotes.
- Serviços e valores efetivamente prestados poderão ser ajustados no atendimento.
- A comanda poderá conter serviços e produtos.
- Pagamentos serão registrados manualmente: Pix, crédito, débito e dinheiro, incluindo divisão entre formas de pagamento.
- O percentual de comissão representa a participação do profissional.
- Modelo comissionado: configuração individual, incluindo 70% para o profissional e 30% para o salão.
- Modelo de aluguel: 100% das vendas para o profissional; aluguel separado das vendas.
- Registrar quem recebeu os pagamentos e os repasses efetivamente realizados.
- Acesso de clientes será uma etapa futura, com serviços e valores autorizados pelo salão.

Essas regras são referência para a nova implementação. Não implicam importar dados reais ou modificar o sistema publicado.
