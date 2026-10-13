package br.com.studio.f.api;

public record Cliente(Long id, String nome, String telefone) {
    
    public Cliente(String nome, String telefone) {
        this(null, nome, telefone);
    }
}