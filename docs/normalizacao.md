# Normalização da Base de Dados de Futebol

## Visão Geral

Este documento descreve o processo de normalização realizado na base de dados de futebol, transformando de 7 tabelas originais para 12 tabelas normalizadas.

## Estrutura Original (7 Tabelas)

1. **country** - Países
2. **league** - Ligas  
3. **team** - Times
4. **player** - Jogadores
5. **player_attributes** - Atributos dos jogadores
6. **team_attributes** - Atributos dos times
7. **match** - Partidas (tabela principal com dados desnormalizados)

## Estrutura Normalizada (12 Tabelas)

### Tabelas Mantidas (7)
1. **country** - Países
2. **league** - Ligas
3. **team** - Times
4. **player** - Jogadores
5. **player_attributes** - Atributos dos jogadores
6. **team_attributes** - Atributos dos times
7. **match** - Partidas (mantida para compatibilidade)

### Novas Tabelas Normalizadas (5)
8. **season** - Normalização de temporadas
9. **venue** - Normalização de estádios/localidades
10. **match_players** - Normalização de jogadores por partida (1NF)
11. **match_events** - Normalização de eventos da partida (1NF)
12. **match_odds** - Normalização de odds de apostas (1NF)

## Processo de Normalização

### Passo 1: Análise da Base Original
- Identificação de dados desnormalizados na tabela `match`
- Análise de relacionamentos e dependências
- Mapeamento de chaves primárias e estrangeiras

### Passo 2: Criação das Novas Tabelas

### Passo 3: Migração de Dados

#### 3.1 População da Tabela SEASON

campeonato/
├── country (1)
├── league (2) → country
├── team (3)
├── player (4)
├── player_attributes (5) → player
├── team_attributes (6) → team
├── season (7)
├── venue (8) → country
├── match (9) → country, league
├── match_players (10) → match, team, player
├── match_events (11) → match, player, team
└── match_odds (12) → match

## Scripts Disponíveis

- `maquina1/relacional.sql` - DDL completo das 12 tabelas
- Scripts de migração de dados (executados manualmente)
- Índices para otimização de performance