class Coord {
  final double? lat;
  final double? lon;

  Coord({this.lat, this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat']?.toDouble(),
      lon: json['lon']?.toDouble(),
    );
  }
}
