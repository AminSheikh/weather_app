class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int clouds;
  final String cityName;
  final DateTime dateTime;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.clouds,
    required this.cityName,
    required this.dateTime,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['weather'][0]['id'],
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDeg: json['wind']['deg'],
      clouds: json['clouds']['all'],
      cityName: json['name'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  ForecastDay({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['temp']['max'].toDouble(),
      tempMin: json['temp']['min'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      humidity: json['humidity'],
      windSpeed: json['speed'].toDouble(),
    );
  }
}
