-- Executar uma unica vez em um banco de desenvolvimento novo.
-- O banco deve existir antes da execucao deste arquivo.
-- Nao remove registros e nao insere dados de teste.

CREATE TABLE public.clientes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL UNIQUE,

    CONSTRAINT clientes_nome_preenchido
        CHECK (length(trim(nome)) > 0),

    CONSTRAINT clientes_telefone_numerico
        CHECK (telefone ~ '^[0-9]+$')
);
