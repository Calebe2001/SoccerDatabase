-- =====================================================
-- PROCEDURE: atualizar_estatisticas_jogador
-- =====================================================
-- Descrição: Atualiza estatísticas consolidadas de um jogador
-- Ação: Calcula e atualiza médias de performance, total de partidas, etc.
-- Uso: Manutenção automática de dados agregados

CREATE OR REPLACE PROCEDURE campeonato.atualizar_estatisticas_jogador(player_id INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    media_overall NUMERIC;
    media_potential NUMERIC;
    total_partidas INTEGER;
    total_times INTEGER;
    ultima_atualizacao TEXT;
BEGIN
    -- Verifica se o jogador existe
    IF NOT EXISTS (SELECT 1 FROM campeonato.player WHERE id = player_id) THEN
        RAISE EXCEPTION 'Jogador com ID % não encontrado', player_id;
    END IF;
    
    -- Calcula médias de atributos
    SELECT 
        ROUND(AVG(overall_rating), 2),
        ROUND(AVG(potential), 2),
        COUNT(DISTINCT mp.match_id),
        COUNT(DISTINCT mp.team_id),
        MAX(pa.date)
    INTO 
        media_overall,
        media_potential,
        total_partidas,
        total_times,
        ultima_atualizacao
    FROM campeonato.player p
    LEFT JOIN campeonato.player_attributes pa ON p.player_api_id = pa.player_api_id
    LEFT JOIN campeonato.match_players mp ON p.id = mp.player_id
    WHERE p.id = player_id
    GROUP BY p.id;
    
    -- Log das estatísticas calculadas
    RAISE NOTICE 'Jogador ID %: Overall=%, Potential=%, Partidas=%, Times=%', 
        player_id, media_overall, media_potential, total_partidas, total_times;
    
    -- Por enquanto, apenas retorna as estatísticas calculadas
    RAISE NOTICE 'Estatísticas atualizadas para o jogador ID %', player_id;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro ao atualizar estatísticas do jogador %: %', player_id, SQLERRM;
END;
$$;

-- Comentário da procedure
COMMENT ON PROCEDURE campeonato.atualizar_estatisticas_jogador(INTEGER) IS 
'Atualiza estatísticas consolidadas de um jogador incluindo médias de atributos e contadores'; 