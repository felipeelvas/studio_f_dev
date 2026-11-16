# Aplicativo Flutter

Pasta reservada para o aplicativo Android, iOS e web.

O projeto Flutter será criado após verificar as ferramentas instaladas. A primeira funcionalidade será o formulário e a listagem de clientes.

### Flutter em debug — terminal

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
