import 'forecast_item.dart';
import 'city.dart';

class ForecastResponse {
  final String cod;
  final int? message;
  final int? cnt;
  final List<ForecastItem>? list;
  final City? city;

  ForecastResponse({
    required this.cod,
    this.message,
    this.cnt,
    this.list,
    this.city,
  });

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    return ForecastResponse(
      cod: json['cod'],
      message: json['message'],
      cnt: json['cnt'],
      list: json['list'] != null
          ? (json['list'] as List)
              .map((item) => ForecastItem.fromJson(item))
              .toList()
          : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
    );
  }
}
