import 'forecast_item.dart';
import 'package:intl/intl.dart';

class DailyForecast {
  final String date;
  final List<ForecastItem> forecasts;

  DailyForecast(this.date, this.forecasts);

  ForecastItem get dayForecast {
    // Find forecast closest to noon
    return forecasts.reduce((a, b) {
      final aDateTime = DateTime.parse(a.dtTxt ?? '');
      final bDateTime = DateTime.parse(b.dtTxt ?? '');
      final aDiff = (aDateTime.hour - 12).abs();
      final bDiff = (bDateTime.hour - 12).abs();
      return aDiff < bDiff ? a : b;
    });
  }

  // Min and max temperature across all forecasts for the day
  double get maxTemp {
    final maxTempMax = forecasts
        .map((e) => e.main?.tempMax ?? 0.0)
        .reduce((a, b) => a > b ? a : b);

    final maxTemp = forecasts
        .map((e) => e.main?.temp ?? 0.0)
        .reduce((a, b) => a > b ? a : b);

    // Return the higher of the two
    return maxTempMax > maxTemp ? maxTempMax : maxTemp;
  }

  double get minTemp {
    final minTempMin = forecasts
        .map((e) => e.main?.tempMin ?? 0.0)
        .reduce((a, b) => a < b ? a : b);

    final minTemp = forecasts
        .map((e) => e.main?.temp ?? 0.0)
        .reduce((a, b) => a < b ? a : b);

    // Return the lower of the two
    return minTempMin < minTemp ? minTempMin : minTemp;
  }

  // Min and max wind speed across all forecasts for the day
  double get maxWindSpeed => forecasts
      .map((e) => e.wind?.speed ?? 0.0)
      .reduce((a, b) => a > b ? a : b);

  double get minWindSpeed => forecasts
      .map((e) => e.wind?.speed ?? 0.0)
      .reduce((a, b) => a < b ? a : b);

  // Min and max pressure across all forecasts for the day
  int get maxPressure => forecasts
      .map((e) => e.main?.pressure ?? 0)
      .reduce((a, b) => a > b ? a : b);

  int get minPressure => forecasts
      .map((e) => e.main?.pressure ?? 0)
      .reduce((a, b) => a < b ? a : b);

  // Min and max humidity across all forecasts for the day
  int get maxHumidity => forecasts
      .map((e) => e.main?.humidity ?? 0)
      .reduce((a, b) => a > b ? a : b);

  int get minHumidity => forecasts
      .map((e) => e.main?.humidity ?? 0)
      .reduce((a, b) => a < b ? a : b);

  // Get a more friendly date format (e.g., "Friday")
  String get friendlyDate {
    final dateTime = DateTime.parse(date);
    return DateFormat('EEEE').format(dateTime);
  }

  // Get shortened day name (e.g., "Fri")
  String get dateShort {
    final dateTime = DateTime.parse(date);
    return DateFormat('E').format(dateTime);
  }

  // Get weather description from day forecast
  String get weatherDescription {
    return dayForecast.weather?.first.description ?? '';
  }

  // Get weather icon code from day forecast
  String get weatherIcon {
    return dayForecast.weather?.first.icon ?? '01d';
  }

  // Get current temperature from day forecast
  int get temperature {
    return dayForecast.main?.temp?.round() ?? 0;
  }

  // Get humidity from day forecast (will be replaced with min/max in UI)
  int get humidity {
    return dayForecast.main?.humidity ?? 0;
  }

  // Get pressure from day forecast (will be replaced with min/max in UI)
  int get pressure {
    return dayForecast.main?.pressure ?? 0;
  }

  // Get wind speed from day forecast (will be replaced with min/max in UI)
  int get windSpeed {
    return dayForecast.wind?.speed?.round() ?? 0;
  }

  static List<DailyForecast> groupByDay(List<ForecastItem> forecasts) {
    final Map<String, List<ForecastItem>> grouped = {};

    for (var forecast in forecasts) {
      final dateTime = DateTime.parse(forecast.dtTxt ?? '');
      final date = DateFormat('yyyy-MM-dd').format(dateTime);

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(forecast);
    }

    return grouped.entries.map((e) => DailyForecast(e.key, e.value)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
