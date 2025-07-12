# Funções SQL

## Descrição
Funções SQL para cálculos e análises úteis no contexto de dados de futebol.

## Funções Disponíveis

### 1. `calcular_media_jogador(player_id BIGINT)`
**Utilidade**: Calcula a média geral de atributos de um jogador
**Parâmetros**: `player_id` - ID do jogador (BIGINT)
**Retorna**: Média numérica dos atributos (overall_rating, potential, etc.)
**Uso**: Análise de performance individual
**Nota**: Compatível com o tipo BIGINT usado nas tabelas

**DDL**: [calcular_media_jogador.sql](./calcular_media_jogador.sql)

**Atributos calculados**:
- overall_rating, potential, finishing, dribbling, short_passing
- ball_control, acceleration, sprint_speed, agility, reactions
- balance, shot_power, jumping, stamina, strength, long_shots
- aggression, interceptions, positioning, vision, penalties
- marking, standing_tackle, sliding_tackle

### 2. `calcular_estatisticas_time(team_id INTEGER, season_name TEXT)`
**Utilidade**: Calcula estatísticas básicas de um time em uma temporada
**Parâmetros**: 
- `team_id` - ID do time (INTEGER)
- `season_name` - Nome da temporada (TEXT)
**Retorna**: Vitórias, empates, derrotas, gols marcados/sofridos
**Uso**: Relatórios de performance do time

**DDL**: [calcular_estatisticas_time.sql](./calcular_estatisticas_time.sql)

**Retorno**:
- `total_partidas` - Total de partidas disputadas
- `vitorias`, `empates`, `derrotas` - Resultados
- `gols_marcados`, `gols_sofridos` - Estatísticas de gols
- `pontos` - Pontos conquistados (3 vitórias, 1 empate)
- `aproveitamento` - Percentual de aproveitamento

### 3. `calcular_odds_media(match_id INTEGER)`
**Utilidade**: Calcula a média das odds de todas as casas de apostas para uma partida
**Parâmetros**: `match_id` - ID da partida (INTEGER)
**Retorna**: Média das odds de vitória, empate e derrota
**Uso**: Análise de probabilidades de apostas

**DDL**: [calcular_odds_media.sql](./calcular_odds_media.sql)

**Retorno**:
- `odds_media_casa` - Média das odds para vitória da casa
- `odds_media_empate` - Média das odds para empate
- `odds_media_visitante` - Média das odds para vitória do visitante
- `total_bookmakers` - Número de casas de apostas analisadas
- `favorito` - Identificação do favorito baseado nas odds

## Características
- Foco em cálculos práticos e úteis
- Reutilizáveis em diferentes consultas
- Performance otimizada
- Compatibilidade com tipos de dados das tabelas

## Exemplos de Uso

### Calcular média de atributos de um jogador:
```sql
SELECT player_name, campeonato.calcular_media_jogador(id) as media_atributos
FROM campeonato.player
WHERE id = 1;
```

### Obter estatísticas de um time em uma temporada:
```sql
SELECT * FROM campeonato.calcular_estatisticas_time(1, '2015/2016');
```

### Analisar odds médias de uma partida:
```sql
SELECT * FROM campeonato.calcular_odds_media(100);
```

### Top 10 jogadores por média de atributos:
```sql
SELECT 
    player_name,
    campeonato.calcular_media_jogador(id) as media_atributos
FROM campeonato.player
WHERE campeonato.calcular_media_jogador(id) > 0
ORDER BY media_atributos DESC
LIMIT 10;
``` 