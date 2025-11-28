# Project Narrative Reports

**Project Title:** End-to-End Data Pipeline and Analysis of Clash Royale Game Assets
**Author:** [Your Name]
**Date:** November 28, 2025

---

## Phase 1: API Selection & Database Migration

### 1.1 API Selection
For this data mining project, the **Clash Royale Official API** was selected as the primary data source. Clash Royale is a popular real-time strategy game developed by Supercell. The API provides rich, structured data regarding game assets (Cards), player statistics, and battle logs.

**Justification for Selection:**
*   **Data Complexity:** The API returns nested JSON objects (e.g., `iconUrls` within card objects), requiring parsing logic that demonstrates data engineering capabilities.
*   **Relevance:** The data contains a mix of categorical fields (`rarity`, `arena`) and numerical attributes (`elixirCost`, `maxLevel`), making it suitable for mixed-type Machine Learning analysis.
*   **Reliability:** As an official vendor-provided API, it ensures high availability and data veracity compared to scraped datasets.

### 1.2 Database Migration Strategy
The migration process was designed to move data from a semi-structured JSON format (API response) to a structured Relational Database Management System (PostgreSQL).

**Technical Implementation:**
*   **Extraction:** A Python script (`notebooks/1_card_extraction.ipynb`) was developed using the `requests` library to authenticate via a Bearer Token and fetch the full list of cards.
*   **Raw Loading:** To adhere to the ELT (Extract, Load, Transform) pattern, data was loaded into the database with minimal transformation. A `raw_cards` table was defined in SQL with flexible data types (e.g., `VARCHAR` for potentially messy text) to prevent ingestion failures.
*   **Automation:** The loading process utilizes the `SQLAlchemy` engine to handle connection pooling and transaction management, ensuring that the `raw_cards` table is refreshed transactionally.

---

## Phase 2: Data Pipelining & In-Database Preprocessing

### 2.1 Architecture & Constraints
A critical constraint of this project was to perform data cleaning and transformation **inside the database layer** rather than using Python/Pandas. This approach leverages the database engine's optimization capabilities and centralizes business logic.

**Components Implemented:**
1.  **Stored Procedure (`sp_clean_clash_royale_cards`):** A PL/pgSQL function acts as the primary pipeline orchestrator. It truncates the target table and repopulates it using a complex `INSERT INTO ... SELECT` statement.
2.  **Target Schema (`clean_cards`):** A strict schema was designed with appropriate data types (`INT` for costs, `BOOLEAN` for flags) to enforce data quality.

### 2.2 SQL Transformations
The following transformations were implemented using SQL functions:

*   **Type Casting & Validation:** Raw text fields from the API (e.g., `elixirCost`) were validated using Regex (`~ '^[0-9]+$'`) before being cast to Integers. Invalid or missing numeric values were handled via `CASE` statements to ensure null safety.
*   **String Normalization:** The `rarity` and `arena` columns contained inconsistent casing or whitespace. The `INITCAP()` and `TRIM()` SQL functions were applied to standardize these categorical values (e.g., ensuring "legendary" becomes "Legendary").
*   **Text Cleaning:** The `description` field often contained formatting artifacts. Nested `REPLACE()` functions were used to strip excessive newlines and double spaces.
*   **Feature Engineering:** New binary features were derived directly during the SQL insertion process. For example, `is_legendary` and `is_champion` flags were generated based on the `rarity` column to simplify downstream ML queries.

### 2.3 ML-Ready Views
To decouple the storage layer from the application layer, a database view `v_ml_ready_cards` was created. This view encapsulates final feature preparation steps, such as One-Hot Encoding logic (e.g., converting `rarity` into `rarity_is_common`, `rarity_is_rare`, etc.), providing a "virtual" table perfectly formatted for the Machine Learning model.

---

## Phase 3: Machine Learning Analysis

### 3.1 Problem Definition
The analysis phase focused on a **Binary Classification** problem: *Predicting whether a card is a "Legendary" rarity card based on its gameplay attributes.* This allows us to understand if "Legendary" cards possess distinct statistical signatures (e.g., specific Elixir costs or arena unlocks) compared to other cards.

### 3.2 Exploratory Data Analysis (EDA)
EDA was performed using `matplotlib` and `seaborn` on the data fetched from the `v_ml_ready_cards` view.
*   **Distributions:** Histograms of `elixir_cost` revealed the distribution of card costs, helping to identify low-cost cycle cards vs. high-investment win conditions.
*   **Correlations:** A correlation matrix was generated to observe relationships between `elixir_cost`, `max_level`, and the target variable.

### 3.3 Model Development
*   **Algorithm:** A **Random Forest Classifier** was selected due to its ability to handle non-linear relationships and its robustness against overfitting on smaller datasets.
*   **Training:** The dataset was split into 80% training and 20% testing sets. Features included `elixir_cost`, `max_level`, `arena`, and derived One-Hot Encoded rarity flags. Standard Scaling was applied to normalize numerical inputs.
*   **Evaluation:** The model's performance was evaluated using Accuracy and a Classification Report (Precision, Recall, F1-Score). Feature Importance analysis highlighted which attributes (e.g., `elixir_cost`) were most predictive of a card's Legendary status.

---

## Conclusion
This project successfully demonstrated an end-to-end data engineering pipeline. By offloading complex data transformations to PostgreSQL, we achieved a robust and scalable architecture where the application layer (Python) focuses solely on extraction and advanced analytics, while the database ensures data integrity and quality.
