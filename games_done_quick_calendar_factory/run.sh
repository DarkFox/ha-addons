#!/usr/bin/with-contenv bashio
set -e

# Run the gamesdonequickcalendarfactory executable
cd /opt/gdq_calendar_factory

# Read addon configuration
GOOGLE_EMAIL=$(bashio::config 'googleServiceAccountEmailAddress' '')
GOOGLE_ID=$(bashio::config 'googleCalendarId' '')
GOOGLE_KEY=$(bashio::config 'googleServiceAccountPrivateKey' '')
LOG_LEVEL=$(bashio::config 'log_level' 'Information')
CACHE_DURATION=$(bashio::config 'cacheDuration' '0:01:00')

# Patch appsettings.json with the configuration
jq --arg email "$GOOGLE_EMAIL" \
   --arg id    "$GOOGLE_ID" \
   --arg key   "$GOOGLE_KEY" \
   --arg log   "$LOG_LEVEL" \
   --arg cache "$CACHE_DURATION" '
  if ($email != "") then .googleServiceAccountEmailAddress = $email else . end |
  if ($id    != "") then .googleCalendarId                = $id    else . end |
  if ($key   != "") then .googleServiceAccountPrivateKey   = $key   else . end |
  .Logging.LogLevel.GamesDoneQuickCalendarFactory = $log |
  .Logging.LogLevel.Default                       = $log |
  .cacheDuration = $cache
' appsettings.json > appsettings.json.tmp && mv appsettings.json.tmp appsettings.json

if [[ "$LOG_LEVEL" == "Trace" || "$LOG_LEVEL" == "Debug" ]]; then
    echo "Dotnet version:"
    dotnet --info

    echo "Starting GamesDoneQuickCalendarFactory with the following configuration:"
    if [[ -n "$GOOGLE_KEY" ]]; then
        # Mask the private key if it is configured
        jq '.googleServiceAccountPrivateKey = "***MASKED***"' appsettings.json
    else
        # No key configured. Print the configuration as is
        cat appsettings.json
    fi
else
    echo "Starting GamesDoneQuickCalendarFactory (log level: $LOG_LEVEL)"
fi

# Run the gamesdonequickcalendarfactory executable forever
exec ./gamesdonequickcalendarfactory
