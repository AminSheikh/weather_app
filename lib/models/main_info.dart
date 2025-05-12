class MainInfo {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? seaLevel;
  final int? grndLevel;
  final int? humidity;
  final double? tempKf;

  MainInfo({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  factory MainInfo.fromJson(Map<String, dynamic> json) {
    return MainInfo(
      temp: json['temp'] != null ? json['temp'].toDouble() : null,
      feelsLike:
          json['feels_like'] != null ? json['feels_like'].toDouble() : null,
      tempMin: json['temp_min'] != null ? json['temp_min'].toDouble() : null,
      tempMax: json['temp_max'] != null ? json['temp_max'].toDouble() : null,
      pressure: json['pressure'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
      humidity: json['humidity'],
      tempKf: json['temp_kf'] != null ? json['temp_kf'].toDouble() : null,
    );
  }
}
