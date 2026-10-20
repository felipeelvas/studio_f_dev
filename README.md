# Studio F — projeto de desenvolvimento e estudo

Sistema de gestão de salão desenvolvido por etapas para praticar Flutter/Dart, Java e PostgreSQL. O projeto é separado do aplicativo Studio F publicado e utiliza um banco local de desenvolvimento.

## Estado atual

O módulo de clientes permite cadastrar, consultar, editar e excluir registros com persistência no PostgreSQL (CRUD completo).

**Flutter → API HTTP Java/Spring Boot → PostgreSQL**

### Tarefas concluídas

- [x] Preparação das ferramentas e organização do projeto.
- [x] Home Flutter e navegação para a lista de clientes.
- [x] Lista com ListView.builder, carregamento e mensagens de erro.
- [x] Formulário reutilizável para cadastro e edição.
- [x] Nome e telefone obrigatórios e normalização do telefone para dígitos.
- [x] API Spring Boot com endereço de status.
- [x] Integração Flutter/API usando GET, POST, PUT e DELETE.
- [x] Exclusão por id com confirmação e opção de cancelar no aplicativo.
- [x] Configuração de acesso local pelo navegador e emulador Android.
- [x] Banco studio_f_dev e tabela clientes criados no pgAdmin.
- [x] Consultas SQL parametrizadas com JdbcTemplate.
- [x] Id gerado pelo banco e representado em Java e Dart.
- [x] Telefone único no banco e tratamento de duplicidade no cadastro e na edição.
- [x] Senha configurada por variável de ambiente.
- [x] Primeiro commit publicado no GitHub.

### Verificações realizadas

Testes manuais confirmaram cadastro e edição pelo emulador Android, consulta pela API e pelo pgAdmin, bloqueio de campos vazios e telefones repetidos e permanência dos dados após reiniciar o Java. A exclusão de um cliente de teste foi confirmada por consultas SQL no psql: o registro foi removido e os demais permaneceram. A primeira consulta integrada também foi testada no navegador.

Ainda não há uma suíte automatizada validando esse fluxo. A execução em iOS e a distribuição nas lojas não foram verificadas.

## Tecnologias

- Flutter/Dart e pacote http.
- Java 21, Spring Boot 4.1.1 e Maven.
- Spring JDBC e driver PostgreSQL.
- PostgreSQL 18 e pgAdmin 4.

## Organização

| Pasta | Responsabilidade |
| --- | --- |
| app/ | Aplicativo Flutter; estrutura gerada para Android, iOS e web. |
| server/ | API Java, validações e acesso ao banco. |
| database/ | Espaço reservado para documentação e futuras migrações SQL. |
| docs/ | Roteiro de aprendizado e resenha dos conceitos estudados. |

## API

| Método | Endereço | Função |
| --- | --- | --- |
| GET | /status | Retorna “Studio F API funcionando”. |
| GET | /clientes | Lista id, nome e telefone dos clientes. |
| POST | /clientes | Cadastra cliente; resposta 201. |
| PUT | /clientes/{id} | Atualiza cliente pelo id; resposta 200. |
| DELETE | /clientes/{id} | Exclui cliente pelo id; resposta 204, sem corpo. |

Cadastro e edição recebem JSON com nome e telefone. A API responde 400 para dados inválidos, 404 para edição ou exclusão de cliente inexistente e 409 para telefone repetido.

## Executar localmente

### 1. Banco

Com PostgreSQL disponível em localhost:5432, crie o banco studio_f_dev. Abra o Query Tool nesse banco e execute uma vez:

```sql
CREATE TABLE clientes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT clientes_nome_preenchido
        CHECK (length(trim(nome)) > 0),
    CONSTRAINT clientes_telefone_numerico
        CHECK (telefone ~ '^[0-9]+$')
);
```

A aplicação não cria a tabela automaticamente. Se ela já existir, não execute o CREATE novamente. Não há inserção automática de clientes de teste.

### 2. Servidor

No PowerShell, a partir da raiz do projeto:

```powershell
cd server
$senhaBanco = Read-Host "Senha do PostgreSQL" -AsSecureString
$env:STUDIO_F_DB_PASSWORD = [System.Net.NetworkCredential]::new('', $senhaBanco).Password
Remove-Variable senhaBanco
mvn spring-boot:run
```

O application.properties aponta para studio_f_dev com usuário postgres e lê a senha de STUDIO_F_DB_PASSWORD. Ajuste endereço e usuário se sua instalação for diferente. A variável vale para essa sessão do terminal; não grave a senha no código.

Mantenha o terminal aberto. Consulte [status](http://localhost:8080/status) e [clientes](http://localhost:8080/clientes). Para parar, use Ctrl+C.

### 3. Flutter

Em outro terminal, a partir da raiz do projeto:

```powershell
cd app
flutter pub get
flutter run -d chrome
```

Para Android, inicie um emulador, consulte `flutter devices` e execute `flutter run -d ID_DO_EMULADOR`, substituindo o identificador pelo dispositivo listado.

O serviço usa localhost:8080 no navegador e 10.0.2.2:8080 no Android, configuração destinada ao emulador. Aparelhos físicos precisam de configuração própria. O manifesto de debug permite HTTP local e a API permite CORS de http://localhost:* para GET, POST, PUT e DELETE. Essas configurações são de desenvolvimento.

## Próximas etapas

- [ ] Preservar os dados digitados no formulário quando o servidor rejeitar uma operação.
- [ ] Versionar migrações SQL e ampliar a documentação de aprendizado.
- [ ] Criar testes automatizados do fluxo de clientes.
- [ ] Implementar autenticação e permissões de administrador e profissionais.
- [ ] Adicionar serviços, categorias, pacotes e profissionais.
- [ ] Implementar agenda e prevenção de conflitos de horário.
- [ ] Adicionar comanda, produtos e registro manual de pagamentos.
- [ ] Implementar comissões, aluguel, repasses e relatórios.
- [ ] Preparar distribuição web, Android e iOS.

O projeto atual ainda não possui login, controle de acesso, agenda ou integração de pagamentos. Use dados fictícios durante o aprendizado e mantenha este banco separado do aplicativo publicado.

## Material de estudo

- [Roteiro de aprendizado](docs/roteiro.md)
- [Resenha: conceitos e primeira etapa do aplicativo](docs/resenha.md)

Cada etapa busca uma entrega pequena que possa ser compreendida, testada e modificada pelo desenvolvedor.
