-- =====================================================
-- PROCEDURE: limpar_dados_antigos
-- =====================================================
-- Descrição: Remove dados antigos para otimizar performance
-- Ação: Remove partidas, eventos e odds de temporadas antigas
-- Uso: Manutenção e limpeza do banco

CREATE OR REPLACE PROCEDURE campeonato.limpar_dados_antigos(anos_antigos INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    ano_limite INTEGER;
    total_partidas_removidas INTEGER := 0;
    total_eventos_removidos INTEGER := 0;
    total_odds_removidas INTEGER := 0;
    total_jogadores_partida_removidos INTEGER := 0;
    temporada_limite TEXT;
    record RECORD;
BEGIN
    -- Calcula o ano limite baseado no ano atual
    SELECT EXTRACT(YEAR FROM CURRENT_DATE) - anos_antigos INTO ano_limite;
    
    -- Constrói a temporada limite (formato: 2015/2016)
    temporada_limite := (ano_limite - 1)::TEXT || '/' || ano_limite::TEXT;
    
    RAISE NOTICE 'Iniciando limpeza de dados antigos...';
    RAISE NOTICE 'Removendo dados anteriores a: %', temporada_limite;
    
    -- Lista temporadas que serão removidas
    RAISE NOTICE 'Temporadas que serão removidas:';
    FOR record IN 
        SELECT DISTINCT season 
        FROM campeonato.match 
        WHERE season < temporada_limite 
        ORDER BY season
    LOOP
        RAISE NOTICE '- %', record.season;
    END LOOP;
    
    -- Remove eventos de partidas antigas
    SELECT COUNT(*)
    INTO total_eventos_removidos
    FROM campeonato.match_events me
    JOIN campeonato.match m ON m.id = me.match_id
    WHERE m.season < temporada_limite;
    
    DELETE FROM campeonato.match_events 
    WHERE match_id IN (
        SELECT id FROM campeonato.match WHERE season < temporada_limite
    );
    
    -- Remove odds de partidas antigas
    SELECT COUNT(*)
    INTO total_odds_removidas
    FROM campeonato.match_odds mo
    JOIN campeonato.match m ON m.id = mo.match_id
    WHERE m.season < temporada_limite;
    
    DELETE FROM campeonato.match_odds 
    WHERE match_id IN (
        SELECT id FROM campeonato.match WHERE season < temporada_limite
    );
    
    -- Remove jogadores de partidas antigas
    SELECT COUNT(*)
    INTO total_jogadores_partida_removidos
    FROM campeonato.match_players mp
    JOIN campeonato.match m ON m.id = mp.match_id
    WHERE m.season < temporada_limite;
    
    DELETE FROM campeonato.match_players 
    WHERE match_id IN (
        SELECT id FROM campeonato.match WHERE season < temporada_limite
    );
    
    -- Remove partidas antigas
    SELECT COUNT(*)
    INTO total_partidas_removidas
    FROM campeonato.match 
    WHERE season < temporada_limite;
    
    DELETE FROM campeonato.match 
    WHERE season < temporada_limite;
    
    -- Remove temporadas antigas (se não houver mais partidas)
    DELETE FROM campeonato.season 
    WHERE season_name < temporada_limite;
    
    -- Remove venues antigas (se não houver mais referências)
    DELETE FROM campeonato.venue 
    WHERE id NOT IN (
        SELECT DISTINCT venue_id 
        FROM campeonato.match 
        WHERE venue_id IS NOT NULL
    );
    
    -- Exibe relatório da limpeza
    RAISE NOTICE '========================================';
    RAISE NOTICE 'RELATÓRIO DE LIMPEZA CONCLUÍDA';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Partidas removidas: %', total_partidas_removidas;
    RAISE NOTICE 'Eventos removidos: %', total_eventos_removidos;
    RAISE NOTICE 'Odds removidas: %', total_odds_removidas;
    RAISE NOTICE 'Jogadores de partida removidos: %', total_jogadores_partida_removidos;
    RAISE NOTICE 'Temporada limite: %', temporada_limite;
    RAISE NOTICE '========================================';
    
    -- Executa VACUUM para liberar espaço
    RAISE NOTICE 'Executando VACUUM para otimizar espaço...';
    -- VACUUM ANALYZE campeonato.match;
    -- VACUUM ANALYZE campeonato.match_events;
    -- VACUUM ANALYZE campeonato.match_odds;
    -- VACUUM ANALYZE campeonato.match_players;
    
    RAISE NOTICE 'Limpeza concluída com sucesso!';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro durante a limpeza de dados antigos: %', SQLERRM;
END;
$$;

-- Comentário da procedure
COMMENT ON PROCEDURE campeonato.limpar_dados_antigos(INTEGER) IS 
'Remove dados antigos do banco para otimizar performance, baseado no número de anos'; 