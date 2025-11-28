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
        -- 1. Type Casting and Data Validation (elixirCost, maxLevel)
        -- Ensure elixirCost and maxLevel are valid integers. Default to NULL if not.
        CASE
            WHEN rc.elixirCost IS NOT NULL AND rc.elixirCost ~ '^[0-9]+$' THEN CAST(rc.elixirCost AS INT)
            ELSE NULL
        END AS elixir_cost,
        CASE
            WHEN rc.maxLevel IS NOT NULL AND rc.maxLevel ~ '^[0-9]+$' THEN CAST(rc.maxLevel AS INT)
            ELSE NULL
        END AS max_level,
        
        -- 2. Categorical Normalization (rarity)
        INITCAP(TRIM(rc.rarity)) AS rarity_cleaned, -- Capitalize first letter, remove whitespace
        
        -- 2. Categorical Normalization (arena)
        TRIM(rc.arena) AS arena_cleaned, -- Remove whitespace
        
        -- 4. Text Cleaning (description)
        -- Remove multiple spaces, newlines, and trim
        TRIM(REPLACE(REPLACE(rc.description, '  ', ' '), E'
', ' ')) AS description_cleaned,
        
        rc.icon_medium,
        
        -- 3. Derived Feature Engineering (is_legendary, is_champion)
        (INITCAP(TRIM(rc.rarity)) = 'Legendary') AS is_legendary,
        (INITCAP(TRIM(rc.rarity)) = 'Champion') AS is_champion,
        
        NOW() -- Set updated_at timestamp
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

    -- NOTE: PostgreSQL doesn't have a direct equivalent to MySQL's stored procedures 
    -- for IF-ELSE or complex loops unless they are within a PL/pgSQL function.
    -- For more advanced transformations like imputing NULLs based on other data
    -- (e.g., average elixirCost for a rarity), you'd expand this function using
    -- PL/pgSQL blocks or CTEs.
    
    -- Example for NULL handling (if you wanted to impute elixir_cost based on average)
    -- This would typically be a separate UPDATE statement after initial insert
    -- UPDATE clean_cards
    -- SET elixir_cost = (SELECT AVG(elixir_cost) FROM clean_cards WHERE rarity_cleaned = clean_cards.rarity_cleaned)
    -- WHERE elixir_cost IS NULL;

END;
$$ LANGUAGE plpgsql;
