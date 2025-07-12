-- =====================================================
-- TRIGGER: auditoria_jogador_changes
-- =====================================================
-- Descrição: Registra todas as mudanças na tabela de jogadores
-- Trigger: AFTER INSERT/UPDATE/DELETE na tabela player
-- Ação: Cria log de auditoria com data, usuário e tipo de operação
-- Uso: Rastreamento de mudanças nos dados

-- Primeiro, criar a tabela de auditoria se não existir
CREATE TABLE IF NOT EXISTS campeonato.player_audit_log (
    id SERIAL PRIMARY KEY,
    player_id BIGINT,
    player_name TEXT,
    operation_type VARCHAR(10) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    operation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_name TEXT DEFAULT CURRENT_USER,
    old_values JSONB,
    new_values JSONB,
    additional_info TEXT
);

-- Função do trigger
CREATE OR REPLACE FUNCTION campeonato.auditoria_jogador_changes()
RETURNS TRIGGER AS $$
DECLARE
    old_data JSONB;
    new_data JSONB;
BEGIN
    -- Captura dados antigos (para UPDATE e DELETE)
    IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        old_data = jsonb_build_object(
            'id', OLD.id,
            'player_api_id', OLD.player_api_id,
            'player_name', OLD.player_name,
            'player_fifa_api_id', OLD.player_fifa_api_id,
            'birthday', OLD.birthday,
            'height', OLD.height,
            'weight', OLD.weight
        );
    END IF;
    
    -- Captura dados novos (para INSERT e UPDATE)
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        new_data = jsonb_build_object(
            'id', NEW.id,
            'player_api_id', NEW.player_api_id,
            'player_name', NEW.player_name,
            'player_fifa_api_id', NEW.player_fifa_api_id,
            'birthday', NEW.birthday,
            'height', NEW.height,
            'weight', NEW.weight
        );
    END IF;
    
    -- Insere o log de auditoria
    INSERT INTO campeonato.player_audit_log (
        player_id,
        player_name,
        operation_type,
        old_values,
        new_values,
        additional_info
    ) VALUES (
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.id
            ELSE NEW.id
        END,
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.player_name
            ELSE NEW.player_name
        END,
        TG_OP,
        old_data,
        new_data,
        CASE 
            WHEN TG_OP = 'UPDATE' THEN 
                'Campos alterados: ' || 
                CASE WHEN OLD.player_name IS DISTINCT FROM NEW.player_name THEN 'player_name, ' ELSE '' END ||
                CASE WHEN OLD.birthday IS DISTINCT FROM NEW.birthday THEN 'birthday, ' ELSE '' END ||
                CASE WHEN OLD.height IS DISTINCT FROM NEW.height THEN 'height, ' ELSE '' END ||
                CASE WHEN OLD.weight IS DISTINCT FROM NEW.weight THEN 'weight, ' ELSE '' END ||
                'player_api_id, player_fifa_api_id'
            ELSE NULL
        END
    );
    
    -- Retorna o registro apropriado
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Criar o trigger
DROP TRIGGER IF EXISTS trigger_auditoria_jogador_changes ON campeonato.player;

CREATE TRIGGER trigger_auditoria_jogador_changes
    AFTER INSERT OR UPDATE OR DELETE ON campeonato.player
    FOR EACH ROW
    EXECUTE FUNCTION campeonato.auditoria_jogador_changes();

-- Comentários
COMMENT ON TABLE campeonato.player_audit_log IS 
'Tabela de auditoria para registrar todas as mudanças na tabela player';

COMMENT ON FUNCTION campeonato.auditoria_jogador_changes() IS 
'Função do trigger para registrar auditoria de mudanças na tabela player';

COMMENT ON TRIGGER trigger_auditoria_jogador_changes ON campeonato.player IS 
'Trigger para registrar auditoria de mudanças na tabela player'; 