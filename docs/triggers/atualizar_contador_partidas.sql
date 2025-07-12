-- =====================================================
-- TRIGGER: atualizar_contador_partidas
-- =====================================================
-- Descrição: Mantém contadores atualizados automaticamente
-- Trigger: AFTER INSERT/DELETE na tabela match
-- Ação: Atualiza contadores de partidas por time e temporada
-- Uso: Manter estatísticas sempre atualizadas

-- Primeiro, criar a tabela de contadores se não existir
CREATE TABLE IF NOT EXISTS campeonato.team_match_counters (
    id SERIAL PRIMARY KEY,
    team_id INTEGER NOT NULL,
    season_name TEXT NOT NULL,
    total_matches INTEGER DEFAULT 0,
    home_matches INTEGER DEFAULT 0,
    away_matches INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(team_id, season_name)
);

-- Função do trigger
CREATE OR REPLACE FUNCTION campeonato.atualizar_contador_partidas()
RETURNS TRIGGER AS $$
BEGIN
    -- Para INSERT
    IF TG_OP = 'INSERT' THEN
        -- Atualiza contador do time da casa
        INSERT INTO campeonato.team_match_counters (team_id, season_name, total_matches, home_matches, away_matches)
        SELECT 
            t.id,
            NEW.season,
            1,
            1,
            0
        FROM campeonato.team t
        WHERE t.team_api_id = NEW.home_team_api_id
        ON CONFLICT (team_id, season_name) DO UPDATE SET
            total_matches = team_match_counters.total_matches + 1,
            home_matches = team_match_counters.home_matches + 1,
            last_updated = CURRENT_TIMESTAMP;
        
        -- Atualiza contador do time visitante
        INSERT INTO campeonato.team_match_counters (team_id, season_name, total_matches, home_matches, away_matches)
        SELECT 
            t.id,
            NEW.season,
            1,
            0,
            1
        FROM campeonato.team t
        WHERE t.team_api_id = NEW.away_team_api_id
        ON CONFLICT (team_id, season_name) DO UPDATE SET
            total_matches = team_match_counters.total_matches + 1,
            away_matches = team_match_counters.away_matches + 1,
            last_updated = CURRENT_TIMESTAMP;
        
        RAISE NOTICE 'Contadores atualizados para partida %: Time casa % e Time visitante %', 
            NEW.id, NEW.home_team_api_id, NEW.away_team_api_id;
        
        RETURN NEW;
    
    -- Para DELETE
    ELSIF TG_OP = 'DELETE' THEN
        -- Atualiza contador do time da casa
        UPDATE campeonato.team_match_counters
        SET 
            total_matches = total_matches - 1,
            home_matches = home_matches - 1,
            last_updated = CURRENT_TIMESTAMP
        WHERE team_id IN (
            SELECT id FROM campeonato.team WHERE team_api_id = OLD.home_team_api_id
        ) AND season_name = OLD.season;
        
        -- Atualiza contador do time visitante
        UPDATE campeonato.team_match_counters
        SET 
            total_matches = total_matches - 1,
            away_matches = away_matches - 1,
            last_updated = CURRENT_TIMESTAMP
        WHERE team_id IN (
            SELECT id FROM campeonato.team WHERE team_api_id = OLD.away_team_api_id
        ) AND season_name = OLD.season;
        
        -- Remove registros com contador zero
        DELETE FROM campeonato.team_match_counters 
        WHERE total_matches <= 0;
        
        RAISE NOTICE 'Contadores atualizados para remoção da partida %: Time casa % e Time visitante %', 
            OLD.id, OLD.home_team_api_id, OLD.away_team_api_id;
        
        RETURN OLD;
    
    -- Para UPDATE (se season ou times mudarem)
    ELSIF TG_OP = 'UPDATE' THEN
        -- Se a temporada mudou
        IF OLD.season IS DISTINCT FROM NEW.season THEN
            -- Remove da temporada antiga
            UPDATE campeonato.team_match_counters
            SET 
                total_matches = total_matches - 1,
                home_matches = home_matches - 1,
                last_updated = CURRENT_TIMESTAMP
            WHERE team_id IN (
                SELECT id FROM campeonato.team WHERE team_api_id = OLD.home_team_api_id
            ) AND season_name = OLD.season;
            
            UPDATE campeonato.team_match_counters
            SET 
                total_matches = total_matches - 1,
                away_matches = away_matches - 1,
                last_updated = CURRENT_TIMESTAMP
            WHERE team_id IN (
                SELECT id FROM campeonato.team WHERE team_api_id = OLD.away_team_api_id
            ) AND season_name = OLD.season;
            
            -- Adiciona na nova temporada
            INSERT INTO campeonato.team_match_counters (team_id, season_name, total_matches, home_matches, away_matches)
            SELECT 
                t.id,
                NEW.season,
                1,
                1,
                0
            FROM campeonato.team t
            WHERE t.team_api_id = NEW.home_team_api_id
            ON CONFLICT (team_id, season_name) DO UPDATE SET
                total_matches = team_match_counters.total_matches + 1,
                home_matches = team_match_counters.home_matches + 1,
                last_updated = CURRENT_TIMESTAMP;
            
            INSERT INTO campeonato.team_match_counters (team_id, season_name, total_matches, home_matches, away_matches)
            SELECT 
                t.id,
                NEW.season,
                1,
                0,
                1
            FROM campeonato.team t
            WHERE t.team_api_id = NEW.away_team_api_id
            ON CONFLICT (team_id, season_name) DO UPDATE SET
                total_matches = team_match_counters.total_matches + 1,
                away_matches = team_match_counters.away_matches + 1,
                last_updated = CURRENT_TIMESTAMP;
        END IF;
        
        -- Remove registros com contador zero
        DELETE FROM campeonato.team_match_counters 
        WHERE total_matches <= 0;
        
        RETURN NEW;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Criar o trigger
DROP TRIGGER IF EXISTS trigger_atualizar_contador_partidas ON campeonato.match;

CREATE TRIGGER trigger_atualizar_contador_partidas
    AFTER INSERT OR UPDATE OR DELETE ON campeonato.match
    FOR EACH ROW
    EXECUTE FUNCTION campeonato.atualizar_contador_partidas();

-- Comentários
COMMENT ON TABLE campeonato.team_match_counters IS 
'Tabela de contadores de partidas por time e temporada';

COMMENT ON FUNCTION campeonato.atualizar_contador_partidas() IS 
'Função do trigger para manter contadores de partidas atualizados automaticamente';

COMMENT ON TRIGGER trigger_atualizar_contador_partidas ON campeonato.match IS 
'Trigger para atualizar contadores de partidas automaticamente'; 