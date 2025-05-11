import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _currentWeather;
  List<ForecastDay>? _forecast;
  List<Weather>? _hourlyForecast;
  bool _isLoading = false;
  String _error = '';
  String _currentCity = AppConstants.defaultCity;

  // Getters
  Weather? get currentWeather => _currentWeather;
  List<ForecastDay>? get forecast => _forecast;
  List<Weather>? get hourlyForecast => _hourlyForecast;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get currentCity => _currentCity;

  // Load weather by city name
  Future<void> fetchWeatherByCity(String city) async {
    _setLoading(true);
    _error = '';

    try {
      _currentCity = city;
      _currentWeather = await _weatherService.getCurrentWeatherByCity(city);
      await fetchForecast(city);
      await fetchHourlyForecast(city);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load weather data: $e');
    }
  }

  // Load weather by user's current location
  Future<void> fetchWeatherByLocation() async {
    _setLoading(true);
    _error = '';

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setError('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setError('Location permission permanently denied');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch weather data
      _currentWeather = await _weatherService.getCurrentWeatherByLocation(
          position.latitude, position.longitude);

      // Update current city
      _currentCity = _currentWeather!.cityName;

      // Fetch forecast data
      await fetchForecastByLocation(position.latitude, position.longitude);

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load weather data: $e');
    }
  }

  // Load forecast data
  Future<void> fetchForecast(String city) async {
    try {
      _forecast = await _weatherService.getForecastByCity(city);
    } catch (e) {
      _setError('Failed to load forecast data: $e');
    }
  }

  // Load forecast by location
  Future<void> fetchForecastByLocation(double lat, double lon) async {
    try {
      _forecast = await _weatherService.getForecastByLocation(lat, lon);
    } catch (e) {
      _setError('Failed to load forecast data: $e');
    }
  }

  // Load hourly forecast
  Future<void> fetchHourlyForecast(String city) async {
    try {
      _hourlyForecast = await _weatherService.getHourlyForecast(city);
    } catch (e) {
      _setError('Failed to load hourly forecast: $e');
    }
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
}
