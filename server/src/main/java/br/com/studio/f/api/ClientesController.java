package br.com.studio.f.api;

import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;


@CrossOrigin(originPatterns = "http://localhost:*", methods = {
        RequestMethod.GET,
        RequestMethod.POST,
        RequestMethod.PUT,
        RequestMethod.DELETE
}, allowedHeaders = "*")

@RestController
public class ClientesController {

    private final ClienteRepository repository;

    public ClientesController(ClienteRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/clientes")
    public List<Cliente> listarClientes() {
        return repository.listar();
    }

    @PostMapping("/clientes")
    @ResponseStatus(HttpStatus.CREATED)
    public Cliente cadastrarCliente(@RequestBody Cliente recebido) {

        if (recebido.nome() == null || recebido.telefone() == null) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Nome e telefone são obrigatórios.");
        }

        String nome = recebido.nome().trim();
        String telefone = recebido.telefone().replaceAll("[^0-9]", "");

        if (nome.isEmpty() || nome.length() > 150
                || telefone.isEmpty() || telefone.length() > 20) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Confira o nome e o telefone informados.");
        }

        Cliente cliente = new Cliente(nome, telefone);

        try {
            return repository.cadastrar(cliente);
        } catch (DuplicateKeyException erro) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Já existe um cliente com esse telefone.");
        }
    }

    @PutMapping("/clientes/{id}")
    public Cliente atualizarCliente(
            @PathVariable("id") Long id,
            @RequestBody Cliente recebido) {

        if (recebido.nome() == null || recebido.telefone() == null) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Nome e telefone são obrigatórios.");
        }

        String nome = recebido.nome().trim();
        String telefone = recebido.telefone().replaceAll("[^0-9]", "");

        if (nome.isEmpty() || nome.length() > 150
                || telefone.isEmpty() || telefone.length() > 20) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Confira o nome e o telefone informados.");
        }

        Cliente cliente = new Cliente(id, nome, telefone);

        try {
            boolean atualizado = repository.atualizar(id, cliente);

            if (!atualizado) {
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Cliente não encontrado.");
            }

            return cliente;
        } catch (DuplicateKeyException erro) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Já existe um cliente com esse telefone.");
        }
    }

    @DeleteMapping("/clientes/{id}")
        @ResponseStatus(HttpStatus.NO_CONTENT)
        public void excluirCliente(@PathVariable("id") Long id) {
            boolean excluido = repository.excluir(id);

            if (!excluido) {
                throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "Cliente não encontrado."
                );
            }
        }
}