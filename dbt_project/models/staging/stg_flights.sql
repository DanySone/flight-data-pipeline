select
    icao24,
    trim(callsign) as flight_number,
    origin_country,
    timestamp_seconds(time_position) as last_seen_at,
    velocity * 3.6 as speed_kmh, -- Conversion de m/s en km/h
    latitude,
    longitude
from {{ source('raw_aviation', 'realtime_states') }}
where longitude is not null