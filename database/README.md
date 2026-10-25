# Banco PostgreSQL

Documentação e scripts SQL do banco de desenvolvimento.

Usar dados fictícios e configuração local. Nenhuma conexão com o banco do aplicativo publicado foi criada.

## Estrutura versionada do banco

O arquivo [001_criar_clientes.sql](migrations/001_criar_clientes.sql) contém a estrutura inicial da tabela `public.clientes`: id automático, nome obrigatório e não vazio, telefone obrigatório, numérico e único.

O número `001` indica a ordem do script. Por enquanto, a execução é manual: o Spring Boot não aplica esses arquivos automaticamente e não há controle automático de quais scripts já foram executados.

### Aplicar em um banco novo

1. No pgAdmin, conectado ao PostgreSQL 18, crie um banco vazio, por exemplo `studio_f_teste`.
2. Clique com o botão direito **nesse banco novo** e abra o Query Tool.
3. Use Open File para abrir `database/migrations/001_criar_clientes.sql` e execute com F5.
4. Consulte `SELECT * FROM public.clientes;`. O resultado deve ter as colunas id, nome e telefone, sem registros.

Alternativamente, no PowerShell, a partir da raiz do projeto, com o banco novo já criado:

```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -h 127.0.0.1 -p 5432 -U postgres -d studio_f_teste -v ON_ERROR_STOP=1 --single-transaction -f .\database\migrations\001_criar_clientes.sql
```

Informe a senha quando solicitada. `ON_ERROR_STOP` interrompe a execução em caso de erro; `--single-transaction` aplica o arquivo como uma única transação.

**Não execute esse script no `studio_f_dev` atual: a tabela já existe.** Não é necessário recriar a tabela para continuar usando o aplicativo. Se executado novamente no mesmo banco, o CREATE TABLE retorna erro de tabela existente. Não usamos `IF NOT EXISTS` para evitar esconder uma estrutura existente diferente da esperada.

O script cria apenas a estrutura, não copia clientes. Depois de aplicar um script em um ambiente, preserve seu conteúdo e registre futuras mudanças em novos arquivos numerados. O banco de teste não é usado pelo aplicativo sem alterar sua configuração.

### Validação realizada

Execução manual confirmada pelo desenvolvedor no banco separado `studio_f_teste`. A consulta `SELECT * FROM public.clientes;` retornou as colunas `id`, `nome` e `telefone`, com zero registros. Essa verificação confirma a criação da estrutura; não substitui testes automatizados das restrições.

## Iniciar o ambiente de desenvolvimento

Ordem: **PostgreSQL → servidor Java → Flutter**. Os comandos abaixo usam PowerShell.

### 1. PostgreSQL

Pressione Windows + R, digite `services.msc` e pressione Enter.
Localize **postgresql-x64-18**. Se estiver parado, clique com o botão direito e escolha **Iniciar**. Se estiver em execução, prossiga.

O pgAdmin não precisa estar aberto para o banco funcionar.

Configuração local do projeto:

| Item | Valor |
| --- | --- |
| Host | localhost |
| Porta | 5432 |
| Banco | studio_f_dev |
| Usuário | postgres |
| Tabela | clientes |

### 2. Servidor Java — terminal 1

```powershell
cd C:\Users\Dell\Documents\Codex\studio-f-dev\server

$senhaBanco = Read-Host "Senha do PostgreSQL" -AsSecureString
$env:STUDIO_F_DB_PASSWORD = [System.Net.NetworkCredential]::new('', $senhaBanco).Password
Remove-Variable senhaBanco

mvn spring-boot:run
```

Informe a senha do PostgreSQL, aguarde a inicialização na porta 8080 e mantenha o terminal aberto. A senha digitada fica oculta. Não grave a senha neste arquivo ou no Git.

A variável de ambiente vale para a sessão desse terminal. Ao abrir outro terminal, execute novamente os comandos de definição da senha.

- [Status da API](http://localhost:8080/status)
- [Consulta de clientes](http://localhost:8080/clientes)

O status verifica a resposta do servidor; a consulta de clientes também exige acesso ao banco.

### 3. Flutter em debug — terminal 2

Inicie o emulador Android pelo Android Studio. Em outro terminal:

```powershell
cd C:\Users\Dell\Documents\Codex\studio-f-dev\app
flutter devices
```

Copie o identificador do emulador e substitua `ID_DO_EMULADOR` no comando:

```powershell
flutter run -d ID_DO_EMULADOR
```

O comando inicia em debug por padrão. Para testar no navegador:

```powershell
flutter run -d chrome
```

Se as dependências ainda não estiverem instaladas, execute `flutter pub get` dentro de `app` antes de iniciar.

No VS Code, outra opção é selecionar o emulador como dispositivo, abrir `app/lib/main.dart` e pressionar F5 com a extensão Flutter instalada.

### Durante o desenvolvimento

| Ação | Como fazer |
| --- | --- |
| Hot Reload | Salve o código e pressione `r` no terminal do Flutter. |
| Hot Restart | Pressione `R` no terminal do Flutter. |
| Parar o Flutter | Pressione `q` no terminal do Flutter; no debug do VS Code, use Parar. |
| Parar o servidor Java | Ctrl+C no terminal do Java. |
| Aplicar alterações no Java | Pare e execute novamente `mvn spring-boot:run` no mesmo terminal. |
| Aplicar alterações no manifesto Android | Pare o Flutter e execute novamente; Hot Reload não é suficiente. |

### Consultar o banco pelo PowerShell

```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -h 127.0.0.1 -p 5432 -U postgres -d studio_f_dev
```

Informe a senha. Quando aparecer `studio_f_dev=#`, execute:

```sql
SELECT * FROM clientes ORDER BY id;
```

Essa consulta apenas lista os registros. Para sair do psql:

```text
\q
```

### Se a lista não carregar

1. Confira se o serviço PostgreSQL está em execução.
2. Confira se o Java iniciou e se a senha foi definida no terminal usado para iniciar o servidor.
3. Teste `/clientes` no navegador e consulte o erro no terminal Java.
4. No emulador Android, a API usa `10.0.2.2:8080`; no navegador do computador, usa `localhost:8080`. Aparelhos físicos exigem outro endereço.
