package br.com.studio.f.api;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ClienteRepository {

    private final JdbcTemplate jdbc;

    public ClienteRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Cliente> listar() {
        String sql = """
                SELECT id, nome, telefone
                FROM clientes
                ORDER BY id
                """;

        return jdbc.query(sql, (resultado, numeroLinha) -> new Cliente(
                resultado.getLong("id"),
                resultado.getString("nome"),
                resultado.getString("telefone")));
    }

    public Cliente cadastrar(Cliente cliente) {
        String sql = """
                INSERT INTO clientes (nome, telefone)
                VALUES (?, ?)
                RETURNING id, nome, telefone
                """;

        return jdbc.queryForObject(
                sql,
                (resultado, numeroLinha) -> new Cliente(
                        resultado.getLong("id"),
                        resultado.getString("nome"),
                        resultado.getString("telefone")),
                cliente.nome(),
                cliente.telefone());
    }

    public boolean atualizar(Long id, Cliente cliente) {
        String sql = """
                UPDATE clientes
                SET nome = ?, telefone = ?
                WHERE id = ?
                """;

        int linhasAlteradas = jdbc.update(
                sql,
                cliente.nome(),
                cliente.telefone(),
                id);

        return linhasAlteradas == 1;
    }

    public boolean excluir(Long id) {
    String sql = """
        DELETE FROM clientes
        WHERE id = ?
        """;

    int linhasExcluidas = jdbc.update(sql, id);

    return linhasExcluidas == 1;
    }
}