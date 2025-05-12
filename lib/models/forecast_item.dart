import 'main_info.dart';
import 'weather_info.dart';
import 'clouds.dart';
import 'wind.dart';
import 'rain.dart';
import 'sys.dart';

class ForecastItem {
  final int dt;
  final MainInfo? main;
  final List<WeatherInfo>? weather;
  final Clouds? clouds;
  final Wind? wind;
  final int? visibility;
  final double? pop;
  final Rain? rain;
  final Sys? sys;
  final String? dtTxt;

  ForecastItem({
    required this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.rain,
    this.sys,
    this.dtTxt,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'],
      main: json['main'] != null ? MainInfo.fromJson(json['main']) : null,
      weather: json['weather'] != null
          ? (json['weather'] as List)
              .map((item) => WeatherInfo.fromJson(item))
              .toList()
          : null,
      clouds: json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
      wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
      visibility: json['visibility'],
      pop: json['pop'] != null ? json['pop'].toDouble() : null,
      rain: json.containsKey('rain') ? Rain.fromJson(json['rain']) : null,
      sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
      dtTxt: json['dt_txt'],
    );
  }
}
