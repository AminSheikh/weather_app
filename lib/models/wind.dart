class Wind {
  final double? speed;
  final int? deg;
  final double? gust;

  Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'] != null ? json['speed'].toDouble() : null,
      deg: json['deg'],
      gust: json.containsKey('gust') ? json['gust'].toDouble() : null,
    );
  }
}
