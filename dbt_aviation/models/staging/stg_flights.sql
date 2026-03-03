{{ config(
    materialized='table',
    full_refresh=true
) }}

with source as (
    select * from {{ source('raw_aviation', 'realtime_states') }}
),

renamed as (
    select
        icao24,
        trim(callsign) as flight_id,
        origin_country,
        -- Conversion du timestamp Unix en format lisible
        timestamp_seconds(cast(time_position as int64)) as position_updated_at,
        longitude,
        latitude,
        -- Conversion de la vitesse (m/s) en km/h
        round(velocity * 3.6, 2) as speed_kmh,
        baro_altitude as altitude_meters,
        on_ground,
        ingested_at
    from source
    -- On filtre les données sans position GPS
    where longitude is not null 
      and latitude is not null
      and velocity > 0 
      and velocity < 1100
      and ingested_at >= timestamp_sub(current_timestamp(), interval 2 hour)
)

select * from renamed