# Triggers

## Descrição
Triggers SQL para manter integridade dos dados e auditoria automática.

## Triggers Disponíveis

### 1. `auditoria_jogador_changes()`
**Utilidade**: Registra todas as mudanças na tabela de jogadores
**Trigger**: AFTER INSERT/UPDATE/DELETE na tabela `player`
**Ação**: Cria log de auditoria com data, usuário e tipo de operação
**Uso**: Rastreamento de mudanças nos dados

**DDL**: [auditoria_jogador_changes.sql](./auditoria_jogador_changes.sql)

**Tabela de auditoria**: `player_audit_log`
- `id` - ID único do log
- `player_id` - ID do jogador
- `player_name` - Nome do jogador
- `operation_type` - Tipo de operação (INSERT/UPDATE/DELETE)
- `operation_date` - Data/hora da operação
- `user_name` - Usuário que executou a operação
- `old_values` - Valores antigos (JSONB)
- `new_values` - Valores novos (JSONB)
- `additional_info` - Informações adicionais sobre mudanças

### 2. `validar_odds_match()`
**Utilidade**: Valida se as odds inseridas são consistentes
**Trigger**: BEFORE INSERT/UPDATE na tabela `match_odds`
**Ação**: Verifica se odds estão em range válido (0.1 a 100)
**Uso**: Garantir qualidade dos dados de apostas

**DDL**: [validar_odds_match.sql](./validar_odds_match.sql)

**Validações realizadas**:
- Range das odds (0.1 a 100)
- Consistência matemática (soma dos inversos > 1)
- Bookmaker não nulo/vazio
- Match ID válido e existente
- Margem de lucro (warnings para valores extremos)

### 3. `atualizar_contador_partidas()`
**Utilidade**: Mantém contadores atualizados automaticamente
**Trigger**: AFTER INSERT/DELETE na tabela `match`
**Ação**: Atualiza contadores de partidas por time e temporada
**Uso**: Manter estatísticas sempre atualizadas

**DDL**: [atualizar_contador_partidas.sql](./atualizar_contador_partidas.sql)

**Tabela de contadores**: `team_match_counters`
- `id` - ID único do contador
- `team_id` - ID do time
- `season_name` - Nome da temporada
- `total_matches` - Total de partidas
- `home_matches` - Partidas como mandante
- `away_matches` - Partidas como visitante
- `last_updated` - Última atualização

## Características
- Garantia de integridade dos dados
- Auditoria automática
- Validação em tempo real
- Contadores automáticos
- Logs detalhados

## Exemplos de Uso

### Verificar logs de auditoria de um jogador:
```sql
SELECT 
    operation_type,
    operation_date,
    user_name,
    additional_info
FROM campeonato.player_audit_log
WHERE player_id = 1
ORDER BY operation_date DESC;
```

### Verificar contadores de partidas de um time:
```sql
SELECT 
    season_name,
    total_matches,
    home_matches,
    away_matches,
    last_updated
FROM campeonato.team_match_counters
WHERE team_id = 1
ORDER BY season_name;
```

### Testar validação de odds:
```sql
-- Isso deverá gerar erro
INSERT INTO campeonato.match_odds (match_id, bookmaker, home_odds, draw_odds, away_odds)
VALUES (1, 'TEST', 0.05, 2.0, 3.0);

-- Isso deverá rodar normalmente
INSERT INTO campeonato.match_odds (match_id, bookmaker, home_odds, draw_odds, away_odds)
VALUES (1, 'TEST', 2.0, 3.0, 4.0);
```

### Verificar estatísticas de mudanças:
```sql
SELECT 
    operation_type,
    COUNT(*) as total_operations,
    MIN(operation_date) as primeira_operacao,
    MAX(operation_date) as ultima_operacao
FROM campeonato.player_audit_log
GROUP BY operation_type;
``` 