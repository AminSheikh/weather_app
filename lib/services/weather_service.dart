import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/constants.dart';

class WeatherService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // You will need to add your API key from OpenWeatherMap
  final String apiKey = AppConstants.apiKey;

  // Get current weather by city name
  Future<Weather> getCurrentWeatherByCity(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  // Get current weather by coordinates
  Future<Weather> getCurrentWeatherByLocation(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  // Get 5-day forecast by city name
  Future<List<ForecastDay>> getForecastByCity(String city) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/forecast/daily?q=$city&cnt=5&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<ForecastDay> forecast = [];

      for (var item in data['list']) {
        forecast.add(ForecastDay.fromJson(item));
      }

      return forecast;
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
  }

  // Get 5-day forecast by coordinates
  Future<List<ForecastDay>> getForecastByLocation(
      double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/forecast/daily?lat=$lat&lon=$lon&cnt=5&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<ForecastDay> forecast = [];

      for (var item in data['list']) {
        forecast.add(ForecastDay.fromJson(item));
      }

      return forecast;
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
  }

  // Alternative endpoint for 5-day forecast with 3-hour steps
  Future<List<Weather>> getHourlyForecast(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Weather> forecast = [];

      for (var item in data['list']) {
        // Add city name to each forecast item since it's not included in each list item
        item['name'] = data['city']['name'];
        forecast.add(Weather.fromJson(item));
      }

      return forecast;
    } else {
      throw Exception(
          'Failed to load hourly forecast data: ${response.statusCode}');
    }
  }

  // Get One Call API data (current + daily forecast + hourly)
  Future<Map<String, dynamic>> getOneCallData(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/onecall?lat=$lat&lon=$lon&exclude=minutely,alerts&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load one call data: ${response.statusCode}');
    }
  }
}
