-- sql/3_views.sql

-- View for ML-ready Clash Royale card data
-- This view selects from the clean_cards table and can perform
-- final feature engineering suitable for machine learning models.

CREATE OR REPLACE VIEW v_ml_ready_cards AS
SELECT
    id,
    name,
    elixir_cost,
    max_level,
    rarity_cleaned AS rarity, -- Rename for consistency if needed by ML framework
    arena_cleaned AS arena,   -- Rename for consistency if needed by ML framework
    description_cleaned AS description,
    icon_medium,
    is_legendary,
    is_champion,
    
    -- Example of One-Hot Encoding like features directly in SQL for ML
    -- You can expand this based on the specific ML model requirements
    CASE WHEN rarity_cleaned = 'Common' THEN 1 ELSE 0 END AS rarity_is_common,
    CASE WHEN rarity_cleaned = 'Rare' THEN 1 ELSE 0 END AS rarity_is_rare,
    CASE WHEN rarity_cleaned = 'Epic' THEN 1 ELSE 0 END AS rarity_is_epic,
    CASE WHEN rarity_cleaned = 'Legendary' THEN 1 ELSE 0 END AS rarity_is_legendary_flag, -- distinct from is_legendary boolean
    CASE WHEN rarity_cleaned = 'Champion' THEN 1 ELSE 0 END AS rarity_is_champion_flag,  -- distinct from is_champion boolean

    -- Example: Binning Elixir Cost (creating a categorical feature from numerical)
    CASE
        WHEN elixir_cost <= 2 THEN 'low_elixir'
        WHEN elixir_cost <= 4 THEN 'medium_elixir'
        ELSE 'high_elixir'
    END AS elixir_tier,
    
    -- You can add more complex features here, e.g., if you had historical data,
    -- calculate win rates of cards, or synergies.
    
    updated_at
FROM
    clean_cards;
