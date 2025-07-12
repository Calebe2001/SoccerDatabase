# Documentação do Banco de Dados de Futebol Europeu

## Visão Geral

Este projeto implementa uma base de dados normalizada para análise de dados de futebol, com 12 tabelas, views, funções, procedures e triggers para garantir integridade e facilitar consultas.

## Estrutura do Projeto

### 📊 **Tabelas (12)**
- **7 tabelas originais**: country, league, team, player, player_attributes, team_attributes, match
- **5 tabelas normalizadas**: season, venue, match_players, match_events, match_odds

### 👁️ **Views (3)**
- `vw_estatisticas_jogadores` - Estatísticas consolidadas dos jogadores
- `vw_performance_times` - Performance dos times por temporada
- `vw_resumo_partidas` - Resumo simplificado das partidas

### 🔧 **Funções (3)**
- `calcular_media_jogador()` - Média de atributos de um jogador
- `calcular_estatisticas_time()` - Estatísticas de um time em uma temporada
- `calcular_odds_media()` - Média das odds de uma partida

### ⚙️ **Procedures (3)**
- `atualizar_estatisticas_jogador()` - Atualiza estatísticas de jogadores
- `gerar_relatorio_temporada()` - Gera relatório completo de temporada
- `limpar_dados_antigos()` - Remove dados antigos para otimização

### 🔒 **Triggers (3)**
- `auditoria_jogador_changes()` - Auditoria de mudanças em jogadores
- `validar_odds_match()` - Validação de odds de apostas
- `atualizar_contador_partidas()` - Contadores automáticos de partidas

## Arquivos de Documentação

### 📁 **Estrutura de Pastas**
```
docs/
├── README.md                           # Esta documentação
├── normalizacao.md                     # Processo de normalização
├── views/
│   ├── README.md                       # Documentação das views
│   ├── vw_estatisticas_jogadores.sql   # DDL da view 1
│   ├── vw_performance_times.sql        # DDL da view 2
│   └── vw_resumo_partidas.sql          # DDL da view 3
├── functions/
│   ├── README.md                       # Documentação das funções
│   ├── calcular_media_jogador.sql      # DDL da função 1
│   ├── calcular_estatisticas_time.sql  # DDL da função 2
│   └── calcular_odds_media.sql         # DDL da função 3
├── procedures/
│   ├── README.md                       # Documentação das procedures
│   ├── atualizar_estatisticas_jogador.sql # DDL da procedure 1
│   ├── gerar_relatorio_temporada.sql   # DDL da procedure 2
│   └── limpar_dados_antigos.sql        # DDL da procedure 3
└── triggers/
    ├── README.md                       # Documentação dos triggers
    ├── auditoria_jogador_changes.sql   # DDL do trigger 1
    ├── validar_odds_match.sql          # DDL do trigger 2
    └── atualizar_contador_partidas.sql # DDL do trigger 3
```

## Scripts Principais

### 🗄️ **DDL Completo**
- `maquina1/relacional.sql` - DDL completo das 12 tabelas normalizadas

### 📋 **Scripts de Migração**
- Scripts para popular as novas tabelas com dados das tabelas originais
- Scripts de limpeza e otimização

## Funcionalidades Implementadas

### 🔍 **Consultas Otimizadas**
- Views pré-agregadas para consultas frequentes
- Índices otimizados para performance
- Funções reutilizáveis para cálculos complexos

### 📊 **Relatórios Automatizados**
- Procedures para geração de relatórios
- Estatísticas consolidadas por temporada
- Análises de performance de times e jogadores

### 🛡️ **Integridade de Dados**
- Triggers de validação em tempo real
- Auditoria automática de mudanças
- Contadores atualizados automaticamente

### 🧹 **Manutenção Automatizada**
- Limpeza de dados antigos
- Atualização de estatísticas
- Otimização de performance

Este diretório contém a documentação dos objetos de dados criados para o banco de dados de futebol normalizado.

## Estrutura

- **functions/**
- **procedures/**
- **triggers/**
- **views/**

## Objetivos

Todos os objetos foram criados com foco na **utilidade prática** para análise de dados de futebol.

## Banco de Dados

O banco contém 12 tabelas normalizadas com dados de:
- Jogadores e seus atributos
- Times e suas características
- Partidas e eventos
- Temporadas e ligas
- Odds de apostas 

## Docker compose (subir 1 parte)

docker compose up -d maquina1 maquina2 maquina3 dw grafana pgadmin postgresql-exporter

## Arquivos para o airflow
-> corno job (pegar scripts da tabelas normalizadas) -> sql dentro da maquina1
-> dentro da pasta dw -> fazer o ddl do star schema
-> dentro da pasta airflow, definir as models pra realizar o processo de elt na maquina1 pro dw

-> mostrar backup, restauração, monitoramento (query pesada)

## Registros

Quantidade de registros em cada tabela: (após validação de dados)

Country: 11
League: 11
Team: 288
Player: 11.060
Player_Attributes: 181.265
Team_Attributes: 489
Match: 21.374