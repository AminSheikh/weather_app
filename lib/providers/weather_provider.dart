import 'package:flutter/material.dart';
import '../models/forecast_response.dart';
import '../models/forecast_item.dart';
import '../models/daily_forecast.dart';
import '../models/current_weather_response.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

enum TemperatureUnit { celsius, fahrenheit }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  ForecastResponse? _forecastResponse;
  CurrentWeatherResponse? _currentWeatherResponse;
  List<DailyForecast> _dailyForecasts = [];
  bool _isLoading = false;
  String _error = '';
  String? _currentCity = AppConstants.defaultCity;
  DailyForecast? _selectedDay;
  bool _isToday = false;
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;

  // Getters
  ForecastResponse? get forecastResponse => _forecastResponse;
  CurrentWeatherResponse? get currentWeatherResponse => _currentWeatherResponse;
  List<ForecastItem> get forecastItems => _forecastResponse?.list ?? [];
  List<DailyForecast> get dailyForecasts => _dailyForecasts;
  bool get isLoading => _isLoading;
  String get error => _error;
  String? get currentCity => _currentCity;
  DailyForecast? get selectedDay => _selectedDay;
  bool get isToday => _isToday;
  TemperatureUnit get temperatureUnit => _temperatureUnit;

  // Get current weather icon code
  String get currentWeatherIcon {
    return _currentWeatherResponse?.weather?.first.icon ?? '01d';
  }

  // Get selected day weather icon code
  String get selectedDayWeatherIcon {
    return _selectedDay?.dayForecast.weather?.first.icon ?? '01d';
  }

  // Get icon URL for any given icon code
  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // Temperature conversion methods
  int celsiusToFahrenheit(int celsius) {
    return ((celsius * 9 / 5) + 32).round();
  }

  // Toggle temperature unit
  void toggleTemperatureUnit() {
    _temperatureUnit = _temperatureUnit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    notifyListeners();
  }

  // Load 5-day forecast and current weather by city name
  Future<void> fetchForecastByCity({String? city}) async {
    _setLoading(true);
    _error = '';

    try {
      _currentCity = city;

      // Fetch both forecast and current weather
      final forecastFuture =
          _weatherService.getFiveDayForecast(city ?? "Berlin");
      final currentWeatherFuture =
          _weatherService.getCurrentWeather(city ?? "Berlin");

      // Wait for both to complete
      final results = await Future.wait([forecastFuture, currentWeatherFuture]);

      _forecastResponse = results[0] as ForecastResponse;
      _currentWeatherResponse = results[1] as CurrentWeatherResponse;

      _processForecastData();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load weather data: $e');
    }
  }

  // Process forecast data to group by day
  void _processForecastData() {
    if (_forecastResponse != null) {
      _dailyForecasts = DailyForecast.groupByDay(_forecastResponse?.list ?? []);

      // Check if today is in the list
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final hasTodayForecast = _dailyForecasts.any((day) => day.date == today);

      // If we have current weather, always incorporate it with today's forecasts
      if (_currentWeatherResponse != null) {
        // Create a synthetic forecast item for current weather
        final currentWeather = ForecastItem(
          dt: _currentWeatherResponse!.dt ??
              DateTime.now().millisecondsSinceEpoch ~/ 1000,
          main: _currentWeatherResponse!.main,
          weather: _currentWeatherResponse!.weather,
          wind: _currentWeatherResponse!.wind,
          dtTxt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        );

        if (hasTodayForecast) {
          // Find today's forecast and add current weather to it
          final todayForecast =
              _dailyForecasts.firstWhere((day) => day.date == today);
          final todayForecasts = [...todayForecast.forecasts, currentWeather];

          // Replace with updated DailyForecast that includes current weather
          final updatedTodayForecast = DailyForecast(today, todayForecasts);
          final index = _dailyForecasts.indexWhere((day) => day.date == today);
          _dailyForecasts[index] = updatedTodayForecast;
        } else {
          // No forecasts for today yet, create a new entry
          _dailyForecasts.insert(0, DailyForecast(today, [currentWeather]));
        }
      } else if (!hasTodayForecast) {
        // No current weather and no forecasts for today
        // Create empty placeholder to avoid errors
        _dailyForecasts.insert(0, DailyForecast(today, []));
      }

      // Sort to ensure today is first if it exists
      _dailyForecasts.sort((a, b) {
        // Always put today first
        if (a.date == today) return -1;
        if (b.date == today) return 1;
        // Otherwise sort by date
        return a.date.compareTo(b.date);
      });

      // Remove any empty days (could happen if we created a placeholder)
      _dailyForecasts.removeWhere((day) => day.forecasts.isEmpty);

      // Select first day by default and check if it's today
      if (_dailyForecasts.isNotEmpty) {
        _selectedDay = _dailyForecasts.first;
        _checkIfSelectedDayIsToday();
      }
    }

    notifyListeners();
  }

  // Check if the selected day is today
  void _checkIfSelectedDayIsToday() {
    if (_selectedDay != null) {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _isToday = _selectedDay!.date == today;
    } else {
      _isToday = false;
    }
  }

  // Select a specific day
  void selectDay(DailyForecast day) {
    _selectedDay = day;
    _checkIfSelectedDayIsToday();
    notifyListeners();
  }

  // Get current temperature for today from current weather API
  int get currentTemperature {
    final tempCelsius = _currentWeatherResponse?.main?.temp?.round() ?? 0;
    return _temperatureUnit == TemperatureUnit.celsius
        ? tempCelsius
        : celsiusToFahrenheit(tempCelsius);
  }

  // Get current weather description for today from current weather API
  String get currentWeatherDescription {
    return _currentWeatherResponse?.weather?.first.description ?? '';
  }

  // Get current humidity for today from current weather API
  int get currentHumidity {
    return _currentWeatherResponse?.main?.humidity ?? 0;
  }

  // Get current pressure for today from current weather API
  int get currentPressure {
    return _currentWeatherResponse?.main?.pressure ?? 0;
  }

  // Get current wind speed for today from current weather API
  int get currentWindSpeed {
    return _currentWeatherResponse?.wind?.speed?.round() ?? 0;
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  // Get temperature unit symbol
  String get temperatureUnitSymbol =>
      _temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';
}
