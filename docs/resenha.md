# Studio F Dev — entendendo o que construímos até agora

Começamos o Studio F Dev como um projeto de aprendizado. Nosso primeiro objetivo é entender como criar telas, representar informações e permitir que o usuário cadastre clientes. Antes de conectar servidor e banco de dados, estamos aprendendo esse fluxo dentro do próprio aplicativo.

Usamos **Dart** como linguagem de programação e **Flutter** para construir a interface. Dart permite escrever classes, variáveis, funções e regras de validação. Flutter utiliza esse código para desenhar as telas e responder às ações do usuário.

## 1. O início do aplicativo: `main.dart`

O arquivo `main.dart` é o ponto de entrada do aplicativo. A função `main()` inicia a execução, e o `runApp()` recebe o widget que será a raiz da interface.

O `MaterialApp` configura a estrutura geral do aplicativo, como tema e tela inicial. No nosso projeto, ele abre a `HomePage`.

Isso estabelece o primeiro caminho:

**Iniciar o aplicativo → abrir a Home → acessar Clientes.**

## 2. A tela inicial: `home_page.dart`

Criamos a `HomePage` com o título Studio F Beauty e um botão para acessar os clientes.

A estrutura da tela usa alguns widgets:

- **`Scaffold`:** organiza a página, incluindo barra superior, conteúdo e botões.
- **`AppBar`:** apresenta o título no topo.
- **`Center`:** centraliza seu conteúdo.
- **`ElevatedButton`:** cria um botão com uma ação.
- **`Text`:** mostra um texto.

Um **widget** é uma peça da interface. Uma tela Flutter é construída combinando essas peças.

Ao tocar no botão Clientes, executamos o `Navigator.push()`. Ele coloca uma nova tela sobre a anterior. O `MaterialPageRoute` define qual página será aberta.

A Home continua disponível por baixo; ao voltar, o usuário retorna a ela.

## 3. Representando um cliente: `cliente.dart`

Criamos a classe `Cliente` para representar os dados de uma pessoa:

```dart
class Cliente {
  final String nome;
  final String telefone;

  const Cliente({
    required this.nome,
    required this.telefone,
  });
}
```

Essa classe não desenha uma tela. Ela organiza informações.

**`String`** é o tipo usado para textos. O telefone também é texto, pois representa um identificador de contato, e não um número com o qual faremos cálculos.

**`final`** significa que o campo recebe seu valor uma vez e não pode ser reatribuído naquele objeto. Se criarmos um cliente com determinado nome, não poderemos simplesmente atribuir outro nome ao mesmo campo.

O **construtor** é usado para criar um objeto:

```dart
final cliente = Cliente(
  nome: 'Felipe Elvas',
  telefone: '61998138835',
);
```

O **`required`** exige que os argumentos sejam informados ao criar o objeto. Ele não impede, sozinho, que sejam enviados textos vazios. Por isso também precisamos validar os valores no formulário.

O **`const`** permite criar objetos constantes quando os argumentos são conhecidos durante a compilação, como nossos clientes de teste. Para informações digitadas pelo usuário, criamos o objeto sem `const`.

## 4. A lista de clientes: `clientes_page.dart`

Primeiro exibimos um cliente de teste. Depois criamos uma lista com Ana, Bruno e Carla.

Usamos:

```dart
final List<Cliente> _clientes = [
  // Clientes de teste.
];
```

**`List<Cliente>`** indica uma lista cujos elementos são objetos do tipo `Cliente`.

Embora a variável seja `final`, podemos adicionar elementos à lista. O que não podemos fazer é atribuir outra lista à mesma variável. A referência fica fixa, mas o conteúdo dessa lista pode mudar.

Para exibir os clientes, usamos o **`ListView.builder`**. Ele constrói as linhas conforme elas são necessárias para a visualização.

O `itemCount` informa quantos elementos existem. O `itemBuilder` recebe o índice da linha e usa esse índice para acessar o cliente:

```dart
final cliente = _clientes[index];
```

Os índices começam em zero. Portanto, uma lista com três clientes tem as posições **0, 1 e 2**.

Cada linha usa um **`ListTile`**, com ícone, nome e telefone.

## 5. Abrindo a tela de cadastro

Adicionamos um **`FloatingActionButton`**, o botão flutuante com o símbolo **+**.

Ao tocar nele, o aplicativo abre a `ClienteFormPage`. Essa tela começou apenas com um título e um texto. Depois acrescentamos os campos Nome e Telefone e o botão Salvar.

Utilizamos:

- **`TextFormField`:** campo de preenchimento.
- **`InputDecoration`:** configura rótulo e borda do campo.
- **`SizedBox`:** cria espaço entre os elementos.
- **`Padding`:** cria margem interna ao redor do conteúdo.
- **`ListView`:** permite rolar o formulário quando necessário, inclusive com o teclado aberto.

O `keyboardType: TextInputType.phone` solicita um teclado adequado para telefone nos dispositivos que oferecem essa opção. Ele facilita a digitação, mas não substitui a validação.

## 6. Guardando o conteúdo dos campos

Para acessar os textos digitados, criamos dois **`TextEditingController`**:

```dart
final _nomeController = TextEditingController();
final _telefoneController = TextEditingController();
```

Cada controller foi associado ao seu campo. Ao salvar, conseguimos ler:

```dart
_nomeController.text
_telefoneController.text
```

Também implementamos o método **`dispose()`**, que libera os controllers quando a tela é removida. Isso faz parte do cuidado com os recursos utilizados pelo aplicativo.

O caractere **`_`** no início de um nome indica que ele é privado à biblioteca Dart — normalmente, ao arquivo em que foi declarado.

## 7. `StatelessWidget`, `StatefulWidget` e estado

A tela inicial usa um **`StatelessWidget`**, pois não precisa manter informações mutáveis próprias para o comportamento que implementamos.

A lista de clientes passou a usar um **`StatefulWidget`**, porque seu conteúdo muda quando adicionamos alguém. O formulário também passou a usar essa estrutura para manter seus controllers e gerenciar seu ciclo de vida.

O **estado** é a informação mantida por uma tela durante seu funcionamento. Na lista, os clientes cadastrados fazem parte desse estado.

Quando adicionamos um cliente, usamos:

```dart
setState(() {
  _clientes.add(cliente);
});
```

O `add()` acrescenta o objeto à lista. O `setState()` informa ao Flutter que houve uma mudança e que a interface precisa ser reconstruída para refletir os novos dados.

## 8. Validando o cadastro

Antes de criar o cliente, tratamos os valores digitados.

No nome, usamos:

```dart
final nome = _nomeController.text.trim();
```

O `trim()` remove espaços no começo e no final. Assim, um campo preenchido apenas com espaços passa a ser considerado vazio.

No telefone, usamos:

```dart
final telefone = _telefoneController.text
    .replaceAll(RegExp(r'[^0-9]'), '');
```

A expressão regular identifica tudo que não seja um dígito de 0 a 9. O `replaceAll()` remove esses caracteres.

Por exemplo, `61 99813-8835` passa a ser `61998138835`. Isso ajuda a comparar números escritos com diferentes separadores.

Essa normalização ainda é básica: não valida DDD, quantidade de dígitos ou código do país. Essas regras poderão ser acrescentadas depois.

Se nome ou telefone estiverem vazios, mostramos uma mensagem com **`SnackBar`** e encerramos a ação usando `return`.

Apesar de termos usado `TextFormField`, nesta etapa a validação foi escrita diretamente no botão Salvar. Ainda não implementamos a validação por um widget `Form` com `validator`.

## 9. Devolvendo o cliente para a lista

Com os campos preenchidos, criamos um objeto `Cliente` e executamos:

```dart
Navigator.pop(context, cliente);
```

Esse comando fecha o formulário e devolve o cliente para a tela que o abriu.

Na lista, usamos:

```dart
final cliente = await Navigator.push<Cliente>(
  // Configuração da navegação.
);
```

O **`await`** aguarda o resultado da navegação sem bloquear a interface. Quando o formulário fecha, a função continua.

Por isso, o método foi declarado com **`async`** e retorna `Future<void>`: ele realiza uma operação assíncrona e não entrega um valor útil ao seu chamador.

Se o usuário voltar sem salvar, o resultado pode ser `null`. Verificamos essa situação antes de continuar.

Também verificamos **`mounted`**, que indica se aquele estado ainda está associado à interface. Isso evita tentar atualizar uma tela que já foi removida enquanto aguardávamos o resultado.

## 10. Impedindo telefones repetidos

Antes de adicionar o cliente, usamos o método **`any()`**:

```dart
final telefoneRepetido = _clientes.any(
  (existente) => existente.telefone == cliente.telefone,
);
```

Ele verifica se existe algum elemento que atende à condição. Nesse caso, procuramos um cliente com o mesmo telefone.

A expressão com **`=>`** é uma função curta: recebe um cliente existente e retorna o resultado da comparação.

Se o telefone já estiver cadastrado, mostramos uma mensagem e não adicionamos outro cliente. Caso contrário, atualizamos a lista.

Nesta versão, essa conferência acontece na lista em memória. Quando integrarmos o banco, também precisaremos garantir a unicidade no servidor e no banco de dados.

## 11. O fluxo completo que já funciona

Construímos este caminho:

1. O usuário abre o aplicativo.
2. A Home permite acessar Clientes.
3. A lista mostra os clientes de teste.
4. O botão **+** abre Novo cliente.
5. O usuário informa nome e telefone.
6. Salvar verifica os campos obrigatórios.
7. O formulário devolve um objeto `Cliente`.
8. A lista verifica se o telefone já existe.
9. O novo cliente aparece na tela.

Você confirmou que o cadastro funcionou. Portanto, já conseguimos conectar **interface, entrada de dados, validação, navegação e atualização de estado**.

## 12. O que ainda falta

Os novos clientes ficam apenas na memória do aplicativo. Ao reiniciá-lo ou recarregar a página, esses cadastros desaparecem e a lista inicial volta.

Ainda não conectamos essa funcionalidade ao servidor Java nem ao PostgreSQL. Também não implementamos edição, exclusão ou autenticação neste projeto de estudo.

O próximo avanço será continuar aprimorando o cadastro e, depois, percorrer o caminho completo:

**Aplicativo Flutter → API Java → banco PostgreSQL.**

A base que construímos permite entender esse processo com mais clareza: primeiro representamos os dados, depois os recebemos pela interface, validamos as informações e atualizamos o que o usuário vê.