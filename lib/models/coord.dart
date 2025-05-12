class Coord {
  final double? lat;
  final double? lon;

  Coord({this.lat, this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat'] != null ? json['lat'].toDouble() : null,
      lon: json['lon'] != null ? json['lon'].toDouble() : null,
    );
  }
}
