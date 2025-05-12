import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forecast_response.dart';
import '../models/current_weather_response.dart';
import '../utils/constants.dart';

class WeatherService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // You will need to add your API key from OpenWeatherMap
  final String apiKey = AppConstants.apiKey;

  /// Gets 5-day weather forecast by city name
  Future<ForecastResponse> getFiveDayForecast(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return ForecastResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
  }

  /// Gets current weather by city name
  Future<CurrentWeatherResponse> getCurrentWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return CurrentWeatherResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load current weather: ${response.statusCode}');
    }
  }
}
