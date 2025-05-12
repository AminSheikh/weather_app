#!/bin/bash

# Create the day and night folders in the assets/weather_backgrounds directory
mkdir -p assets/weather_backgrounds/day
mkdir -p assets/weather_backgrounds/night

echo "Folder structure created successfully!"
echo ""
echo "Please move your existing weather background images to:"
echo "assets/weather_backgrounds/day/"
echo ""
echo "And add night versions of the images to:"
echo "assets/weather_backgrounds/night/"
echo ""
echo "Required background images for each folder:"
echo "- clear_sky_weather.png"
echo "- few_clouds_weather.png"
echo "- scattered_clouds_weather.png" 
echo "- broken_clouds_weather.png"
echo "- shower_rain_weather.png"
echo "- rain_weather.png"
echo "- thunderstorm_weather.png"
echo "- snow_weather.png"
echo "- mist_weather.png"
echo ""
echo "After adding the images, run 'flutter pub get' to update assets." 