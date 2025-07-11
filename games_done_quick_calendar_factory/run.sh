#!/usr/bin/with-contenv bashio

# Print the dotnet version to ensure it's installed correctly
echo "Dotnet version:"
dotnet --info

# Run the gamesdonequickcalendarfactory executable
cd /opt/gdq_calendar_factory

echo "Starting gamesdonequickcalendarfactory with config:"
cat appsettings.json

# Run the gamesdonequickcalendarfactory executable forever
./gamesdonequickcalendarfactory

# Uh oh, it crashed!
echo "gamesdonequickcalendarfactory crashed with exit code $?."
