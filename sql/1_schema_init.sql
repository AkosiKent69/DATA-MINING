-- sql/1_schema_init.sql

-- Drop tables if they exist to allow for easy re-initialization during development
DROP TABLE IF EXISTS clean_cards;
DROP TABLE IF EXISTS raw_cards;

-- Table to store raw Clash Royale card data directly from the API
CREATE TABLE raw_cards (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    maxLevel INT,
    elixirCost INT,
    rarity VARCHAR(50),
    arena VARCHAR(255),
    description TEXT,
    icon_medium VARCHAR(500), -- URL for the medium icon
    -- Add a timestamp for when the data was extracted
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store cleaned and preprocessed Clash Royale card data
CREATE TABLE clean_cards (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    elixir_cost INT,          -- Cleaned elixir cost
    max_level INT,            -- Cleaned max level
    rarity_cleaned VARCHAR(50), -- Normalized rarity
    arena_cleaned VARCHAR(255), -- Normalized arena
    description_cleaned TEXT, -- Cleaned description
    icon_medium VARCHAR(500), -- Retain icon URL
    is_legendary BOOLEAN DEFAULT FALSE, -- Derived feature
    is_champion BOOLEAN DEFAULT FALSE,  -- Derived feature
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp for when this row was last cleaned/updated
);

-- You might want to add indexes for performance on frequently queried columns
CREATE INDEX idx_raw_cards_rarity ON raw_cards (rarity);
CREATE INDEX idx_clean_cards_rarity ON clean_cards (rarity_cleaned);
CREATE INDEX idx_clean_cards_elixir_cost ON clean_cards (elixir_cost);
