# Banco PostgreSQL

Pasta reservada para a documentação e as migrações do banco de desenvolvimento.

Usar dados fictícios e configuração local. Nenhuma conexão com o banco do aplicativo publicado foi criada.

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
