import requests
from google.cloud import bigquery
import pandas as pd
import time

# Configuration BigQuery
client = bigquery.Client.from_service_account_json('credentials.json')
TABLE_ID = "ton-projet.raw_aviation.realtime_states"

def fetch_opensky_data():
    # API OpenSky (Public)
    url = "https://opensky-network.org/api/states/all"
    response = requests.get(url)
    data = response.json()
    
    # Colonnes typiques de l'API OpenSky
    columns = [
        "icao24", "callsign", "origin_country", "time_position", 
        "last_contact", "longitude", "latitude", "baro_altitude", 
        "on_ground", "velocity", "true_track", "vertical_rate", 
        "sensors", "geo_altitude", "squawk", "spi", "position_source"
    ]
    
    df = pd.DataFrame(data['states'], columns=columns)
    df['ingested_at'] = pd.Timestamp.now() # Pour le suivi dans BigQuery
    return df

def load_to_bigquery(df):
    job_config = bigquery.LoadJobConfig(write_disposition="WRITE_APPEND")
    job = client.load_table_from_dataframe(df, TABLE_ID, job_config=job_config)
    job.result()
    print(f"✅ {len(df)} vols chargés dans BigQuery.")

if __name__ == "__main__":
    flights_df = fetch_opensky_data()
    load_to_bigquery(flights_df)