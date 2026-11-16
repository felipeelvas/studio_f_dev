# API Java

Pasta reservada para a API Java com Spring Boot.

O servidor validará os dados e as permissões e concentrará as regras de agenda e comissões. A primeira funcionalidade será cadastrar e consultar clientes no PostgreSQL.

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