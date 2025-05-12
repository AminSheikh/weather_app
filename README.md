# Weather App

A Flutter weather application that displays current and forecasted weather conditions with dynamic background images based on weather conditions and time of day.

## Weather Background Images

This application uses different background images based on weather conditions and time of day (day/night). Please organize the images in the following folder structure:

```
assets/
└── weather_backgrounds/
    ├── day/
    │   ├── clear_sky_weather.png
    │   ├── few_clouds_weather.png
    │   ├── scattered_clouds_weather.png
    │   ├── broken_clouds_weather.png
    │   ├── shower_rain_weather.png
    │   ├── rain_weather.png
    │   ├── thunderstorm_weather.png
    │   ├── snow_weather.png
    │   └── mist_weather.png
    └── night/
        ├── clear_sky_weather.png
        ├── few_clouds_weather.png
        ├── scattered_clouds_weather.png
        ├── broken_clouds_weather.png
        ├── shower_rain_weather.png
        ├── rain_weather.png
        ├── thunderstorm_weather.png
        ├── snow_weather.png
        └── mist_weather.png
```

### Weather Conditions

1. `clear_sky_weather.png` - For clear sky conditions
2. `few_clouds_weather.png` - For few clouds conditions
3. `scattered_clouds_weather.png` - For scattered clouds conditions
4. `broken_clouds_weather.png` - For broken or overcast clouds conditions
5. `shower_rain_weather.png` - For shower rain or drizzle conditions
6. `rain_weather.png` - For rain conditions
7. `thunderstorm_weather.png` - For thunderstorm conditions
8. `snow_weather.png` - For snow conditions
9. `mist_weather.png` - For mist, fog, or haze conditions

## Day/Night Detection

The app automatically detects whether it's day or night based on the current time:
- Day: 6:00 AM to 5:59 PM
- Night: 6:00 PM to 5:59 AM

## How It Works

The application dynamically changes the background image based on:
1. The current weather condition retrieved from the OpenWeatherMap API
2. The time of day (day or night)

## Installation

1. Clone the repository
2. Create the folder structure and add the required weather background images
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application
