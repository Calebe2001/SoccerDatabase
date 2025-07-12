# Views

## Descrição
Views SQL para simplificar consultas complexas e criar relatórios pré-definidos.

## Views Disponíveis

### 1. `vw_estatisticas_jogadores`
**Utilidade**: View consolidada com estatísticas completas dos jogadores
**Conteúdo**: Dados do jogador + médias de atributos + total de partidas
**Uso**: Consultas rápidas de performance individual

**DDL**: [vw_estatisticas_jogadores.sql](./vw_estatisticas_jogadores.sql)

**Colunas principais**:
- `id`, `player_name`, `birthday`, `height`, `weight`
- `media_overall_rating`, `media_potential`, `media_finishing`, etc.
- `total_partidas`, `total_times_jogou`
- `preferred_foot`, `attacking_work_rate`, `defensive_work_rate`

### 2. `vw_performance_times`
**Utilidade**: View com performance consolidada dos times por temporada
**Conteúdo**: Vitórias, empates, derrotas, gols, pontos, posição
**Uso**: Análise de performance e ranking dos times

**DDL**: [vw_performance_times.sql](./vw_performance_times.sql)

**Colunas principais**:
- `season`, `team_id`, `team_long_name`, `league_name`, `country_name`
- `total_partidas`, `total_vitorias`, `total_empates`, `total_derrotas`
- `total_gols_marcados`, `total_gols_sofridos`, `pontos`, `saldo_gols`
- `aproveitamento_percentual`
- Estatísticas separadas por mandante/visitante

### 3. `vw_resumo_partidas`
**Utilidade**: View simplificada com informações essenciais das partidas
**Conteúdo**: Times, resultado, data, liga, odds médias
**Uso**: Consultas rápidas de resultados e apostas

**DDL**: [vw_resumo_partidas.sql](./vw_resumo_partidas.sql)

**Colunas principais**:
- `match_id`, `season`, `date`, `stage`
- `home_team_name`, `away_team_name`, `resultado`
- `league_name`, `country_name`
- `odds_media_casa`, `odds_media_empate`, `odds_media_visitante`
- `total_eventos`, `total_gols_eventos`, `total_cartoes`

## Características
- Consultas pré-otimizadas
- Dados agregados prontos para uso
- Simplificação de queries complexas
- Performance melhorada para relatórios

## Exemplos de Uso

### Consulta de top jogadores por overall rating:
```sql
SELECT player_name, media_overall_rating, total_partidas
FROM campeonato.vw_estatisticas_jogadores
WHERE media_overall_rating IS NOT NULL
ORDER BY media_overall_rating DESC
LIMIT 10;
```

### Ranking de times por temporada:
```sql
SELECT team_long_name, pontos, total_vitorias, saldo_gols
FROM campeonato.vw_performance_times
WHERE season = '2015/2016'
ORDER BY pontos DESC, saldo_gols DESC;
```

### Partidas com maiores odds:
```sql
SELECT home_team_name, away_team_name, resultado, odds_media_empate
FROM campeonato.vw_resumo_partidas
WHERE odds_media_empate > 3.0
ORDER BY odds_media_empate DESC;
``` 