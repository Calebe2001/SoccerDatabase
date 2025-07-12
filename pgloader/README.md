# PGLoader - Processo de Carga de Dados

Este diretório contém os arquivos necessários para carregar a base de dados SQLite do Kaggle para o PostgreSQL usando o PGLoader.

## 📁 Arquivos

- `base.sqlite` - Base de dados SQLite limpa e pronta para carga
- `comprehensive_clean.sql` - Script SQL para limpeza completa dos dados
- `pg.load` - Configuração do PGLoader
- `pgloader.conf` - Configuração alternativa do PGLoader
- `run.sh` - Script de execução do PGLoader
- `logfile.log` - Log de execução do PGLoader

## 🚀 Como Usar

### 1. Preparação dos Dados

Se você tiver um arquivo SQLite original com problemas, execute:

```bash
sqlite3 base.sqlite < comprehensive_clean.sql
```

### 2. Execução do PGLoader

```bash
sudo bash run.sh
```

## 🔧 Problemas Resolvidos

### Problema 1: Foreign Key Constraints
**Sintoma:** Erro de foreign key mismatch durante a carga
**Solução:** Remoção de foreign key constraints problemáticas no SQLite

### Problema 2: Valores "NIL"
**Sintoma:** Erro "invalid input syntax for type bigint: NIL"
**Solução:** Conversão de valores "NIL" para NULL

### Problema 3: Referências Inválidas
**Sintoma:** Jogadores referenciados em Match que não existem em Player
**Solução:** Filtragem de registros com referências válidas

### Problema 4: Configuração de Porta
**Sintoma:** Erro de conexão recusada
**Solução:** Correção da porta de 15432 para 5432

## 📊 Estrutura da Base

### Tabelas Originais (SQLite)
- `Country` (11 registros) - Países
- `League` (11 registros) - Ligas
- `Team` (299 registros) - Times
- `Player` (11.060 registros) - Jogadores
- `Player_Attributes` (183.978 registros) - Atributos dos jogadores
- `Team_Attributes` (1.458 registros) - Atributos dos times
- `Match` (21.374 registros) - Partidas

### Schema Final (PostgreSQL)
- Schema: `campeonato`
- Todas as tabelas carregadas sem foreign key constraints
- Dados limpos e consistentes

## ⚠️ Importante

- O arquivo `base.sqlite` já está limpo e pronto para uso
- Execute `comprehensive_clean.sql` apenas se tiver um arquivo original com problemas
- O PGLoader está configurado para conectar na porta 5432 (PostgreSQL padrão)
- Todos os dados são carregados no schema `campeonato`

## 📈 Resultado Final

- **218.191 registros** carregados com sucesso
- **Zero erros** na carga final
- **7 tabelas** criadas no PostgreSQL
- Base pronta para uso com Airflow e dbt 