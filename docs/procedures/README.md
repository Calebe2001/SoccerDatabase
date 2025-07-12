# Procedimentos Armazenados

## Descrição
Procedimentos SQL para operações complexas e automatizadas no banco de dados de futebol.

## Procedimentos Disponíveis

### 1. `atualizar_estatisticas_jogador(player_id INTEGER)`
**Utilidade**: Atualiza estatísticas consolidadas de um jogador
**Ação**: Calcula e atualiza médias de performance, total de partidas, etc.
**Uso**: Manutenção automática de dados agregados

**DDL**: [atualizar_estatisticas_jogador.sql](./atualizar_estatisticas_jogador.sql)

**Funcionalidades**:
- Calcula médias de `overall_rating` e `potential`
- Conta total de partidas e times que o jogador atuou
- Registra última atualização de atributos
- Validação de existência do jogador
- Log detalhado das operações

### 2. `gerar_relatorio_temporada(season_name TEXT)`
**Utilidade**: Gera relatório completo de uma temporada
**Ação**: Calcula estatísticas de todos os times, jogadores e partidas
**Uso**: Relatórios periódicos de performance

**DDL**: [gerar_relatorio_temporada.sql](./gerar_relatorio_temporada.sql)

**Estatísticas geradas**:
- Total de partidas, times e jogadores
- Total e média de gols por partida
- Melhor ataque e defesa
- Campeão da temporada
- Artilheiro
- Top 5 times por pontos

### 3. `limpar_dados_antigos(anos_antigos INTEGER)`
**Utilidade**: Remove dados antigos para otimizar performance
**Ação**: Remove partidas, eventos e odds de temporadas antigas
**Uso**: Manutenção e limpeza do banco

**DDL**: [limpar_dados_antigos.sql](./limpar_dados_antigos.sql)

**Operações de limpeza**:
- Remove eventos de partidas antigas
- Remove odds de partidas antigas
- Remove jogadores de partidas antigas
- Remove partidas antigas
- Remove temporadas e venues órfãs
- Executa VACUUM para otimização

## Características
- Operações em lote
- Automatização de tarefas repetitivas
- Manutenção de integridade dos dados
- Logs detalhados de execução
- Tratamento de erros robusto

## Exemplos de Uso

### Atualizar estatísticas de um jogador:
```sql
CALL campeonato.atualizar_estatisticas_jogador(1);
```

### Gerar relatório de uma temporada:
```sql
CALL campeonato.gerar_relatorio_temporada('2015/2016');
```

### Limpar dados com mais de 5 anos:
```sql
CALL campeonato.limpar_dados_antigos(5);
```

### Atualizar estatísticas de todos os jogadores:
```sql
DO $$
DECLARE
    player_record RECORD;
BEGIN
    FOR player_record IN SELECT id FROM campeonato.player LIMIT 100
    LOOP
        CALL campeonato.atualizar_estatisticas_jogador(player_record.id);
    END LOOP;
END $$;
``` 