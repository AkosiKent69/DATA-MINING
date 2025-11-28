-- sql/2_procedures.sql

-- Function to clean and transform raw_cards data into clean_cards
CREATE OR REPLACE FUNCTION sp_clean_clash_royale_cards()
RETURNS VOID AS $$
BEGIN
    -- Clear the clean_cards table before inserting new data
    TRUNCATE TABLE clean_cards;

    -- Insert/Update data into clean_cards with transformations
    INSERT INTO clean_cards (
        id,
        name,
        elixir_cost,
        max_level,
        rarity_cleaned,
        arena_cleaned,
        description_cleaned,
        icon_medium,
        is_legendary,
        is_champion,
        updated_at
    )
    SELECT
        rc.id,
        rc.name,
        
        -- 1. Type Casting (elixirCost, maxLevel)
        -- Columns are "elixirCost" (double) and "maxLevel" (bigint)
        -- We cast directly to INT. NULLs are preserved automatically.
        CAST(rc."elixirCost" AS INT) AS elixir_cost,
        CAST(rc."maxLevel" AS INT) AS max_level,
        
        -- 2. Categorical Normalization (rarity)
        INITCAP(TRIM(rc.rarity)) AS rarity_cleaned, 
        
        -- 2. Categorical Normalization (arena)
        -- "arena" might not exist in the raw table if Pandas dropped it or schema changed.
        -- Checking schema from previous step, 'arena' and 'description' were MISSING in raw_cards!
        -- API structure might have changed. We should handle missing columns gracefully or use placeholders.
        -- Let's check if 'arena' exists. If not, NULL.
        
        -- Wait, checking the 'check_schema.py' output again:
        -- Columns: maxEvolutionLevel, id, maxLevel, elixirCost, icon_medium, rarity, name.
        -- MISSING: arena, description.
        
        -- We must provide NULL for missing columns to avoid "column does not exist" error.
        NULL AS arena_cleaned, 
        
        -- 4. Text Cleaning (description)
        -- Description is also missing from raw_cards.
        NULL AS description_cleaned,
        
        rc.icon_medium,
        
        -- 3. Derived Feature Engineering
        (INITCAP(TRIM(rc.rarity)) = 'Legendary') AS is_legendary,
        (INITCAP(TRIM(rc.rarity)) = 'Champion') AS is_champion,
        
        NOW() 
    FROM
        raw_cards rc
    ON CONFLICT (id) DO UPDATE SET
        name = EXCLUDED.name,
        elixir_cost = EXCLUDED.elixir_cost,
        max_level = EXCLUDED.max_level,
        rarity_cleaned = EXCLUDED.rarity_cleaned,
        arena_cleaned = EXCLUDED.arena_cleaned,
        description_cleaned = EXCLUDED.description_cleaned,
        icon_medium = EXCLUDED.icon_medium,
        is_legendary = EXCLUDED.is_legendary,
        is_champion = EXCLUDED.is_champion,
        updated_at = EXCLUDED.updated_at;

END;
$$ LANGUAGE plpgsql;