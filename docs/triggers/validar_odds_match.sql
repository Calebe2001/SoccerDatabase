-- =====================================================
-- TRIGGER: validar_odds_match
-- =====================================================
-- Descrição: Valida se as odds inseridas são consistentes
-- Trigger: BEFORE INSERT/UPDATE na tabela match_odds
-- Ação: Verifica se odds estão em range válido (0.1 a 100)
-- Uso: Garantir qualidade dos dados de apostas

-- Função do trigger
CREATE OR REPLACE FUNCTION campeonato.validar_odds_match()
RETURNS TRIGGER AS $$
BEGIN
    -- Validação de range das odds (0.1 a 100)
    IF NEW.home_odds IS NOT NULL AND (NEW.home_odds < 0.1 OR NEW.home_odds > 100) THEN
        RAISE EXCEPTION 'Odds da casa (%.2f) fora do range válido (0.1 a 100)', NEW.home_odds;
    END IF;
    
    IF NEW.draw_odds IS NOT NULL AND (NEW.draw_odds < 0.1 OR NEW.draw_odds > 100) THEN
        RAISE EXCEPTION 'Odds do empate (%.2f) fora do range válido (0.1 a 100)', NEW.draw_odds;
    END IF;
    
    IF NEW.away_odds IS NOT NULL AND (NEW.away_odds < 0.1 OR NEW.away_odds > 100) THEN
        RAISE EXCEPTION 'Odds do visitante (%.2f) fora do range válido (0.1 a 100)', NEW.away_odds;
    END IF;
    
    -- Validação de consistência das odds (soma dos inversos deve ser > 1)
    IF NEW.home_odds IS NOT NULL AND NEW.draw_odds IS NOT NULL AND NEW.away_odds IS NOT NULL THEN
        IF (1.0/NEW.home_odds + 1.0/NEW.draw_odds + 1.0/NEW.away_odds) <= 1.0 THEN
            RAISE EXCEPTION 'Odds inconsistentes: soma dos inversos (%.4f) deve ser > 1.0', 
                (1.0/NEW.home_odds + 1.0/NEW.draw_odds + 1.0/NEW.away_odds);
        END IF;
    END IF;
    
    -- Validação de bookmaker válido
    IF NEW.bookmaker IS NULL OR LENGTH(TRIM(NEW.bookmaker)) = 0 THEN
        RAISE EXCEPTION 'Bookmaker não pode ser nulo ou vazio';
    END IF;
    
    -- Validação de match_id válido
    IF NEW.match_id IS NULL THEN
        RAISE EXCEPTION 'Match ID não pode ser nulo';
    END IF;
    
    -- Verifica se a partida existe
    IF NOT EXISTS (SELECT 1 FROM campeonato.match WHERE id = NEW.match_id) THEN
        RAISE EXCEPTION 'Partida com ID % não existe', NEW.match_id;
    END IF;
    
    -- Validação de margem de lucro (opcional, pode ser ajustada)
    IF NEW.home_odds IS NOT NULL AND NEW.draw_odds IS NOT NULL AND NEW.away_odds IS NOT NULL THEN
        DECLARE
            margem_lucro NUMERIC;
        BEGIN
            margem_lucro := (1.0/NEW.home_odds + 1.0/NEW.draw_odds + 1.0/NEW.away_odds) - 1.0;
            
            -- Se a margem for muito baixa (< 2%), gera warning
            IF margem_lucro < 0.02 THEN
                RAISE WARNING 'Margem de lucro muito baixa (%.2f%%) para bookmaker %', 
                    margem_lucro * 100, NEW.bookmaker;
            END IF;
            
            -- Se a margem for muito alta (> 50%), gera warning
            IF margem_lucro > 0.50 THEN
                RAISE WARNING 'Margem de lucro muito alta (%.2f%%) para bookmaker %', 
                    margem_lucro * 100, NEW.bookmaker;
            END IF;
        END;
    END IF;
    
    -- Log de validação bem-sucedida
    RAISE NOTICE 'Odds validadas com sucesso para partida % e bookmaker %', 
        NEW.match_id, NEW.bookmaker;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar o trigger
DROP TRIGGER IF EXISTS trigger_validar_odds_match ON campeonato.match_odds;

CREATE TRIGGER trigger_validar_odds_match
    BEFORE INSERT OR UPDATE ON campeonato.match_odds
    FOR EACH ROW
    EXECUTE FUNCTION campeonato.validar_odds_match();

-- Comentários
COMMENT ON FUNCTION campeonato.validar_odds_match() IS 
'Função do trigger para validar consistência e range das odds de apostas';

COMMENT ON TRIGGER trigger_validar_odds_match ON campeonato.match_odds IS 
'Trigger para validar odds antes de inserção/atualização'; 