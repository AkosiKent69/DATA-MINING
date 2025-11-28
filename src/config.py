# src/config.py

# --- Clash Royale API Configuration ---
# Token extracted from your previous work. 
# IF EXPIRED: Log in to https://developer.clashroyale.com/ and create a new key for your IP address.
API_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6Ijc5M2RmMTlhLWJmMGMtNGE0Yi04ZjhkLWIyZTAzNzE2ZTkxZCIsImlhdCI6MTc2NDMzMTAyNSwic3ViIjoiZGV2ZWxvcGVyL2NiM2NlMjQxLTRhNGQtODhlOS1mMzhjLTBhMDQwNTRkMzZlZCIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIxNDMuNDQuMTkzLjE5NyJdLCJ0eXBlIjoiY2xpZW50In1dfQ.bQgwfnHjsrNtIfRMGGZUewsthp4m4WY1G0O43ZWCZRSD5bCVqIWRXwoS4qHMRRrUAyP3NlNUw-KAMBPyAiYNNg"

API_URL = "https://api.clashroyale.com/v1/cards"

# --- Database Configuration ---
# We will use these variables to connect to your DB later.
# Once you install PostgreSQL, you can leave these as defaults or update 'PASSWORD'.
DB_USER = "postgres"
DB_PASSWORD = "12345"  # <--- You will set this when you install PostgreSQL
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "clashroyale_db"

# Connection String helper
def get_db_connection_string():
    # Constructs the connection string for SQLAlchemy
    # Format: postgresql+psycopg2://user:password@host:port/dbname
    return f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
