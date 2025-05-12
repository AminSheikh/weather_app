# Weather Forecast App

<img src="screenshots/app_screenshot.png" alt="Weather App Screenshot" width="300">

<video width="300" controls>
  <source src="demo/app_demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## App Demo

You can include a video demo in several ways:

1. Using a GIF (most compatible):
   ```
   ![App Demo](demo/app_demo.gif)
   ```

2. Using HTML video tag:
   ```html
   <video width="320" height="240" controls>
     <source src="demo/app_demo.mp4" type="video/mp4">
     Your browser does not support the video tag.
   </video>
   ```

3. Link to YouTube:
   ```
   [![App Demo](https://img.youtube.com/vi/YOUTUBE_VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=YOUTUBE_VIDEO_ID)
   ```

## Features

- **Current Weather Data**: Get up-to-date information about the current weather conditions including temperature, humidity, wind speed, and pressure
- **5-Day Forecast**: Plan ahead with detailed forecasts for the next five days
- **City Search**: Look up weather information for any city around the world
- **Beautiful UI**: Dynamic backgrounds that change based on weather conditions
- **Day/Night Mode**: Automatic theme switching based on time of day or manual override
- **Temperature Units**: Toggle between Celsius and Fahrenheit with a single tap

## Requirements

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher
- OpenWeatherMap API key

## Getting Started

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Create a `.env` file in the root directory with the following content:
   ```
   OPENWEATHERMAP_API_KEY=your_api_key_here
   ```
4. Run the app using `flutter run`

## Technical Implementation

This app follows a structured architecture that separates concerns and makes the codebase maintainable:

### Directory Structure

```
lib/
├── main.dart
├── models/       # Data models
├── providers/    # State management
├── screens/      # UI components
├── services/     # API and business logic
└── utils/        # Utilities and constants
```

### Key Components

- **Models**: Clean, type-safe representation of API responses
- **Provider Pattern**: Efficient state management using the Provider package
- **OpenWeatherMap API**: Real-time data from a reliable weather service
- **Responsive UI**: Adapts perfectly to different screen sizes and orientations
- **Environment Variables**: Secure storage of API keys using .env file

### Weather Data Processing

The app handles two types of data from OpenWeatherMap API:
1. **Current Weather Data**: Provides real-time weather information for the selected city
2. **5-Day/3-Hour Forecast Data**: Contains forecast predictions at 3-hour intervals for the next 5 days

#### Daily Forecast Conversion

The raw forecast data comes as a series of 3-hour interval predictions. To create a more user-friendly daily forecast:

1. The `DailyForecast.groupByDay` static method groups forecast items by their date:
   - Each forecast's timestamp (`dtTxt`) is parsed to extract the date
   - Forecasts are grouped into a map with dates as keys
   - The map is converted to a list of `DailyForecast` objects sorted by date

2. For each day's forecast, the app calculates:
   - The day's min/max temperature from all intervals
   - Min/max humidity, pressure, and wind speed
   - A representative "day forecast" (using the forecast closest to noon)

3. The `WeatherProvider` further processes this data:
   - Merges the current weather data into today's forecast for accuracy
   - Ensures today's forecast appears first in the list
   - Handles edge cases like missing data for the current day

#### Current Weather Display

The app shows comprehensive current weather information:
- **Temperature**: Displayed in Celsius or Fahrenheit (user-toggleable)
- **Weather condition**: Text description and corresponding icon
- **Humidity**: Current humidity percentage 
- **Pressure**: Atmospheric pressure in hPa
- **Wind Speed**: Current wind speed

When viewing today's forecast, the app prioritizes showing the latest current weather information rather than forecasted data for better accuracy.

## Design Choices

I wanted to create a visually appealing app that feels natural to use. The weather backgrounds change dynamically based on current conditions, giving users immediate visual cues about the weather. The UI elements are purposefully minimal to keep focus on the important information.

For the code architecture, I chose the Provider pattern for state management as it offers a good balance between simplicity and power. The separation between UI components and business logic makes the app easier to test and maintain.

## Acknowledgements

This project uses the OpenWeatherMap API for weather data and weather icons. Background images are designed to create an immersive weather experience.
