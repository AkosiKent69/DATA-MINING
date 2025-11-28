Act as a Senior Data Engineer and Data Scientist mentor. I have a final project for my Data Mining and Applications course. I need you to understand the requirements below and help me plan the architecture, select tools, and write the code.

Here are the Project Requirements:

**Objective:** End-to-end data pipeline project involving API extraction, database migration, in-database preprocessing (SQL), and Machine Learning.

**Project Phases:**
1. **API Selection:** Must use an external API (e.g., OpenWeather, Twitter, Finance, Gov data) suitable for analysis.
2. **Database Migration:** Migrate API data into a local relational database (MySQL or PostgreSQL). Involves Python (requests/pandas) and schema optimization.
3. **Data Pipelining & Preprocessing:** *Critical Constraint:* Cleaning, transformation, and normalization must happen INSIDE the database using SQL queries, views, and stored procedures (not just Python).
4. **Analysis/ML:** Perform EDA or apply ML models (classification/regression/clustering) on the processed data.

**Deliverables:**
- Narrative Reports for each phase.
- Jupyter Notebook with documented code.
- Final PPT Presentation.

**Task:**
Please acknowledge you understand these constraints. Then, suggest 3 feasible project ideas that fit these criteria. For each idea, list:
1. The specific API source.
2. The complexity of the SQL preprocessing required.
3. The potential Machine Learning problem to solve.

---

I am working on a Data Mining project where I need to fetch data from an API, store it in a SQL database, clean it using SQL stored procedures, and run a Machine Learning model on it.

Please generate a comprehensive technical roadmap and file structure for this project.

**Project Constraints:**
- Language: Python (Jupyter Notebook)
- Database: PostgreSQL or MySQL
- Preprocessing: Must be done via SQL (Stored Procedures/Views), not Pandas.

**Please provide:**
1. A recommended file structure (e.g., folders for SQL scripts, Python notebooks, config).
2. A pseudocode workflow for the "Extraction" script (Python to DB).
3. A list of 5 specific SQL transformations I should implement (e.g., handling nulls, normalization, timestamp formatting) to satisfy the "In-Database Preprocessing" requirement.
4. A brief outline of how to connect the clean SQL data back to Python for the ML phase.