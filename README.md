# Studio F — projeto de desenvolvimento e estudo

Nova implementação do sistema do salão, separada do aplicativo atualmente publicado.

## Tecnologias planejadas

- Flutter/Dart: aplicativo Android, iOS e plataforma web.
- Java com Spring Boot: API e regras do negócio.
- PostgreSQL: armazenamento dos dados.

Os frameworks e as dependências ainda não foram instalados. Esta primeira etapa organiza o projeto; não há aplicação executável nesta pasta.

## Organização

| Pasta | Responsabilidade |
| --- | --- |
| `app/` | Projeto Flutter, a ser iniciado na próxima etapa. |
| `server/` | API Java/Spring Boot, a ser iniciada na próxima etapa. |
| `database/` | Estrutura e migrações do PostgreSQL. |
| `docs/` | Roteiro de aprendizado e decisões do projeto. |

## Primeiro objetivo

Construir o cadastro de clientes completo: formulário Flutter, API Java e persistência no PostgreSQL. Nome e telefone serão obrigatórios, com prevenção de telefones duplicados.

Usar inicialmente dados fictícios. Não conectar este projeto ao banco, às credenciais ou aos clientes do Studio F publicado.

## Desenvolvimento por etapas

1. Verificar e preparar as ferramentas de desenvolvimento. ✅
2. Criar os projetos Flutter e Java e configurar o PostgreSQL local.
3. Implementar o cadastro e a consulta de clientes.
4. Adicionar serviços e profissionais.
5. Implementar agenda e prevenção de conflitos de horário.
6. Adicionar comanda, produtos e pagamentos manuais.
7. Implementar participação do profissional, repasses e relatórios.
8. Preparar a distribuição web, Android e iOS.

Cada etapa deve ter uma entrega pequena que possa ser compreendida, testada e modificada pelo desenvolvedor.
