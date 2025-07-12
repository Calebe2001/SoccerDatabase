-- =====================================================
-- PROCEDURE: gerar_relatorio_temporada
-- =====================================================
-- Descrição: Gera relatório completo de uma temporada
-- Ação: Calcula estatísticas de todos os times, jogadores e partidas
-- Uso: Relatórios periódicos de performance

CREATE OR REPLACE PROCEDURE campeonato.gerar_relatorio_temporada(season_name TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    total_partidas INTEGER;
    total_times INTEGER;
    total_jogadores INTEGER;
    total_gols INTEGER;
    media_gols_por_partida NUMERIC;
    melhor_ataque INTEGER;
    melhor_defesa INTEGER;
    campeao TEXT;
    artilheiro TEXT;
    record RECORD;
BEGIN
    -- Verifica se a temporada existe
    IF NOT EXISTS (SELECT 1 FROM campeonato.match WHERE season = season_name LIMIT 1) THEN
        RAISE EXCEPTION 'Temporada % não encontrada', season_name;
    END IF;
    
    -- Estatísticas gerais da temporada
    SELECT 
        COUNT(*) as total_partidas,
        COUNT(DISTINCT home_team_api_id) + COUNT(DISTINCT away_team_api_id) as total_times,
        SUM(home_team_goal + away_team_goal) as total_gols,
        ROUND(AVG(home_team_goal + away_team_goal), 2) as media_gols
    INTO 
        total_partidas,
        total_times,
        total_gols,
        media_gols_por_partida
    FROM campeonato.match 
    WHERE season = season_name;
    
    -- Total de jogadores únicos na temporada
    SELECT COUNT(DISTINCT mp.player_id)
    INTO total_jogadores
    FROM campeonato.match_players mp
    JOIN campeonato.match m ON m.id = mp.match_id
    WHERE m.season = season_name;
    
    -- Melhor ataque (mais gols marcados)
    SELECT t.team_long_name
    INTO melhor_ataque
    FROM campeonato.team t
    JOIN campeonato.match m ON (m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id)
    WHERE m.season = season_name
    GROUP BY t.id, t.team_long_name
    ORDER BY SUM(
        CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal 
             WHEN m.away_team_api_id = t.team_api_id THEN m.away_team_goal 
             ELSE 0 END
    ) DESC
    LIMIT 1;
    
    -- Melhor defesa (menos gols sofridos)
    SELECT t.team_long_name
    INTO melhor_defesa
    FROM campeonato.team t
    JOIN campeonato.match m ON (m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id)
    WHERE m.season = season_name
    GROUP BY t.id, t.team_long_name
    ORDER BY SUM(
        CASE WHEN m.home_team_api_id = t.team_api_id THEN m.away_team_goal 
             WHEN m.away_team_api_id = t.team_api_id THEN m.home_team_goal 
             ELSE 0 END
    ) ASC
    LIMIT 1;
    
    -- Campeão (mais pontos)
    SELECT t.team_long_name
    INTO campeao
    FROM campeonato.team t
    JOIN campeonato.match m ON (m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id)
    WHERE m.season = season_name
    GROUP BY t.id, t.team_long_name
    ORDER BY (
        COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal THEN 1 END) +
        COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal > m.home_team_goal THEN 1 END)
    ) * 3 + (
        COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal = m.away_team_goal THEN 1 END) +
        COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal = m.home_team_goal THEN 1 END)
    ) DESC
    LIMIT 1;
    
    -- Artilheiro (mais gols em eventos)
    SELECT p.player_name
    INTO artilheiro
    FROM campeonato.player p
    JOIN campeonato.match_events me ON me.player_id = p.id
    JOIN campeonato.match m ON m.id = me.match_id
    WHERE m.season = season_name AND me.event_type = 'goal'
    GROUP BY p.id, p.player_name
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    -- Exibe o relatório
    RAISE NOTICE '========================================';
    RAISE NOTICE 'RELATÓRIO DA TEMPORADA: %', season_name;
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Total de Partidas: %', total_partidas;
    RAISE NOTICE 'Total de Times: %', total_times;
    RAISE NOTICE 'Total de Jogadores: %', total_jogadores;
    RAISE NOTICE 'Total de Gols: %', total_gols;
    RAISE NOTICE 'Média de Gols por Partida: %', media_gols_por_partida;
    RAISE NOTICE 'Melhor Ataque: %', melhor_ataque;
    RAISE NOTICE 'Melhor Defesa: %', melhor_defesa;
    RAISE NOTICE 'Campeão: %', campeao;
    RAISE NOTICE 'Artilheiro: %', artilheiro;
    RAISE NOTICE '========================================';
    
    -- Top 5 times por pontos
    RAISE NOTICE 'TOP 5 TIMES:';
    FOR record IN 
        SELECT 
            t.team_long_name,
            COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal THEN 1 END) +
            COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal > m.home_team_goal THEN 1 END) as vitorias,
            COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal = m.away_team_goal THEN 1 END) +
            COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal = m.home_team_goal THEN 1 END) as empates,
            (
                COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal THEN 1 END) +
                COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal > m.home_team_goal THEN 1 END)
            ) * 3 + (
                COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal = m.away_team_goal THEN 1 END) +
                COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal = m.home_team_goal THEN 1 END)
            ) as pontos
        FROM campeonato.team t
        JOIN campeonato.match m ON (m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id)
        WHERE m.season = season_name
        GROUP BY t.id, t.team_long_name
        ORDER BY pontos DESC
        LIMIT 5
    LOOP
        RAISE NOTICE '% - % pts (% vitórias, % empates)', 
            record.team_long_name, record.pontos, record.vitorias, record.empates;
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro ao gerar relatório da temporada %: %', season_name, SQLERRM;
END;
$$;

-- Comentário da procedure
COMMENT ON PROCEDURE campeonato.gerar_relatorio_temporada(TEXT) IS 
'Gera relatório completo de uma temporada com estatísticas de times, jogadores e partidas'; 