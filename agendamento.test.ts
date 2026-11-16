import { describe, expect, it } from 'vitest';
import { existeConflito, type Agendamento } from './agendamento';

const criar = (inicio: number, fim: number, profissionalId = 1): Agendamento => ({
  profissionalId, inicio, fim,
});

describe('existeConflito', () => {
  it.each([
    [570, 630], // Sobreposicao pela esquerda.
    [630, 690], // Sobreposicao pela direita.
    [610, 650], // Novo contido no existente.
    [570, 690], // Existente contido no novo.
    [600, 660], // Intervalos identicos.
    [600, 630], // Mesmo inicio.
    [630, 660], // Mesmo fim.
  ])('detecta conflito para [%i, %i)', (inicio, fim) => {
    expect(existeConflito(criar(inicio, fim), [criar(600, 660)])).toBe(true);
  });

  it.each([
    [500, 550], // Antes, com intervalo.
    [700, 750], // Depois, com intervalo.
    [540, 600], // Consecutivo antes.
    [660, 720], // Consecutivo depois.
  ])('aceita horario sem conflito [%i, %i)', (inicio, fim) => {
    expect(existeConflito(criar(inicio, fim), [criar(600, 660)])).toBe(false);
  });

  it('permite atendimento simultaneo por profissionais diferentes', () => {
    expect(existeConflito(criar(600, 660), [criar(600, 660, 2)])).toBe(false);
  });

  it('retorna false para lista vazia', () => {
    expect(existeConflito(criar(0, 1440), [])).toBe(false);
  });

  it('encontra conflito em lista desordenada com varios profissionais', () => {
    const existentes = [criar(900, 960), criar(600, 660, 2), criar(600, 660)];
    expect(existeConflito(criar(610, 620), existentes)).toBe(true);
  });

  it('aceita os limites 0 e 1440 e duracao de um minuto', () => {
    expect(existeConflito(criar(0, 1), [criar(0, 1440)])).toBe(true);
    expect(existeConflito(criar(1439, 1440), [criar(0, 1440)])).toBe(true);
    expect(existeConflito(criar(0, 1440), [criar(1439, 1440)])).toBe(true);
    expect(existeConflito(criar(0, 1), [criar(1, 1440)])).toBe(false);
  });

  describe.each([
    [-1, 60],       // Inicio negativo.
    [0, -1],        // Fim negativo.
    [60, 60],       // Duracao zero.
    [120, 60],      // Intervalo invertido.
    [1439, 1441],   // Fim acima do limite.
    [1440, 1441],   // Inicio no fim do dia.
    [0.5, 60],      // Inicio fracionario.
    [0, 60.5],      // Fim fracionario.
    [NaN, 60],
    [0, NaN],
    [Infinity, 60],
    [0, Infinity],
    [-Infinity, 60],
    [0, -Infinity],
  ])('rejeita intervalo [%s, %s)', (inicio, fim) => {
    it('no novo agendamento', () => {
      expect(() => existeConflito(criar(inicio, fim), [])).toThrow(RangeError);
    });

    it('em existente de outro profissional', () => {
      expect(() => existeConflito(criar(600, 660), [criar(inicio, fim, 2)]))
        .toThrow(RangeError);
    });
  });

  it('valida registros invalidos posteriores a um conflito', () => {
    const existentes = [criar(610, 620), criar(0, 0, 2)];
    expect(() => existeConflito(criar(600, 660), existentes)).toThrow(RangeError);
  });

  it.each([true, false])('preserva entradas quando o resultado e %s', (conflito) => {
    const novo = Object.freeze(criar(600, 660));
    const existentes = [criar(900, 960), criar(610, 620, conflito ? 1 : 2)];
    const copia = existentes.map((item) => ({ ...item }));
    const referencias = [...existentes];
    existentes.forEach((item) => Object.freeze(item));
    Object.freeze(existentes);

    expect(existeConflito(novo, existentes)).toBe(conflito);
    expect(novo).toEqual(criar(600, 660));
    expect(existentes).toEqual(copia);
    existentes.forEach((item, indice) => expect(item).toBe(referencias[indice]));
  });
});
