export interface Agendamento {
  profissionalId: number;
  inicio: number;
  fim: number;
}

function validarIntervalo(agendamento: Agendamento): void {
  const { inicio, fim } = agendamento;

  if (
    !Number.isInteger(inicio) ||
    !Number.isInteger(fim) ||
    inicio < 0 ||
    inicio >= fim ||
    fim > 1440
  ) {
    throw new RangeError('Intervalo inválido: esperado 0 <= inicio < fim <= 1440, em minutos inteiros.');
  }
}

export function existeConflito(
  novo: Agendamento,
  existentes: Agendamento[],
): boolean {
  validarIntervalo(novo);

  // Valida todos os registros, inclusive os posteriores a um conflito.
  for (const existente of existentes) {
    validarIntervalo(existente);
  }

  // Intervalos [inicio, fim): o fim de um pode ser o inicio de outro.
  return existentes.some(
    (existente) =>
      existente.profissionalId === novo.profissionalId &&
      novo.inicio < existente.fim &&
      existente.inicio < novo.fim,
  );
}
