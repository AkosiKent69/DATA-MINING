# Clash Royale Data Mining Project

This project implements an end-to-end data pipeline for extracting Clash Royale card data, migrating it to a PostgreSQL database, performing in-database preprocessing using SQL, and finally applying Machine Learning analysis using Python.

## Project Phases & Structure

The project is structured into the following phases and corresponding files:

### Phase 1: API Extraction & Database Migration
*   **Objective:** Fetch Clash Royale card data from the official API and load it into a raw SQL table.
*   **Key Files:**
    *   `src/config.py`: Stores API token and database connection details.
    *   `notebooks/1_card_extraction.ipynb`: Python script to fetch data and load into `raw_cards` table.

### Phase 2: Data Pipelining & In-Database Preprocessing
*   **Objective:** Clean, transform, and normalize the raw data directly within the PostgreSQL database using SQL functions and views.
*   **Key Files:**
    *   `sql/1_schema_init.sql`: Defines the `raw_cards` and `clean_cards` table schemas.
    *   `sql/2_procedures.sql`: Contains the `sp_clean_clash_royale_cards()` SQL function for data cleaning.
    *   `sql/3_views.sql`: Defines the `v_ml_ready_cards` SQL view for ML-ready data.
    *   `notebooks/2_clean_and_verify.ipynb`: Executes the SQL cleaning function and verifies the transformed data.

### Phase 3: Analysis & Machine Learning
*   **Objective:** Load the cleaned, ML-ready data into Python, perform exploratory data analysis (EDA), and train a Machine Learning model.
*   **Key Files:**
    *   `notebooks/3_ml_card_analysis.ipynb`: Contains Python code for data loading, EDA, ML model training, and evaluation.

## Getting Started

### 1. Prerequisites

*   **Python 3.x**
*   **Jupyter Notebook**
*   **PostgreSQL Database:** A running PostgreSQL instance (version 10+) with a database named `clashroyale_db`.
    *   **Installation:** Follow official PostgreSQL installation guides for your OS.
    *   **User/Password:** Default credentials used in `src/config.py` are `user=postgres`, `password=12345`. Please ensure your PostgreSQL `postgres` user has this password set, or update `src/config.py` with your actual credentials.
    *   **pgAdmin 4:** (Optional) A GUI tool for managing your PostgreSQL database.
*   **Clash Royale API Key:**
    *   Obtain a free developer key from [Clash Royale Developer Portal](https://developer.clashroyale.com/).
    *   **Crucial:** Ensure your API key allows access from your current public IP address. Tokens often expire or are IP-bound. If you get a 403 error, generate a new key and update `src/config.py`.

### 2. Project Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/AkosiKent69/DATA-MINING.git
    cd DATA-MINING
    ```
2.  **Install Python dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
    (Note: `requirements.txt` is not yet created, but would contain: `pandas`, `sqlalchemy`, `requests`, `scikit-learn`, `matplotlib`, `seaborn`, `psycopg2-binary`)

3.  **Configure Database and API:**
    *   Edit `src/config.py` with your PostgreSQL database credentials and your Clash Royale API token.
    *   Ensure your PostgreSQL `clashroyale_db` database exists.

### 3. Running the Pipeline

Follow these steps sequentially to execute the entire data pipeline.

#### A. Initialize Database Schema

This step creates the `raw_cards` and `clean_cards` tables in your PostgreSQL database.

```bash
python src/db_init.py
# If db_init.py is not present, you can manually run the SQL files:
# psql -U postgres -d clashroyale_db -f sql/1_schema_init.sql
# psql -U postgres -d clashroyye_db -f sql/2_procedures.sql
# psql -U postgres -d clashroyale_db -f sql/3_views.sql
```
*(Note: `src/db_init.py` was a temporary script. You'll need to run the SQL files manually or adapt the Python script if you re-clone this repo.)*

#### B. Extract Data (Phase 1)

Open `notebooks/1_card_extraction.ipynb` in Jupyter and run all cells. This fetches data from the Clash Royale API and loads it into the `raw_cards` table.

#### C. Clean & Verify Data (Phase 2)

Open `notebooks/2_clean_and_verify.ipynb` in Jupyter and run all cells. This executes the `sp_clean_clash_royale_cards()` SQL function to populate `clean_cards` and verifies the transformations.

#### D. Machine Learning Analysis (Phase 3)

Open `notebooks/3_ml_card_analysis.ipynb` in Jupyter and run all cells. This notebook loads the cleaned data, performs EDA, trains, and evaluates a Machine Learning model.

## Folder Structure

```
final_project/
├── data/
│   ├── raw/                   # (Optional) Backups of raw API JSONs
│   └── processed/             # (Empty, data in DB)
│
├── sql/
│   ├── 1_schema_init.sql      # Create Tables (Raw & Clean layers)
│   ├── 2_procedures.sql       # Stored Procedures for cleaning/transforming
│   └── 3_views.sql            # Views for final ML-ready data
│
├── notebooks/
│   ├── 1_card_extraction.ipynb # API -> Raw SQL Table
│   ├── 2_clean_and_verify.ipynb# Execute & Verify SQL Cleaning
│   └── 3_ml_card_analysis.ipynb# Fetch Clean Data -> ML Model
│
├── src/
│   ├── config.py              # Database credentials & API Keys
│   └── (db_init.py was temporary)
│   └── (run_extraction.py was temporary)
│
├── .gitignore                 # (To be created)
├── requirements.txt           # (To be created)
└── README.md                  # Project documentation (this file)
```
