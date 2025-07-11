#!/usr/bin/with-contenv bashio

# Print the dotnet version to ensure it's installed correctly
echo "Dotnet version:"
dotnet --info

# Run the gamesdonequickcalendarfactory executable
cd /opt/gdq_calendar_factory

# Read desired log level from config (default: Information)
LOG_LEVEL=$(bashio::config 'log_level' || echo "Information")

# Patch log levels in appsettings.json
jq --arg lvl "$LOG_LEVEL" '
  .Logging.LogLevel.GamesDoneQuickCalendarFactory = $lvl |
  .Logging.LogLevel.Default = $lvl
' appsettings.json > appsettings.json.tmp && mv appsettings.json.tmp appsettings.json

echo "Log level set to: $LOG_LEVEL"
cat appsettings.json

# Run the gamesdonequickcalendarfactory executable forever
exec ./gamesdonequickcalendarfactory
