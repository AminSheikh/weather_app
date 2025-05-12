import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Get API key from environment file
  static String get apiKey => dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';

  // Units for temperature
  static const String metric = 'metric'; // Celsius
  static const String imperial = 'imperial'; // Fahrenheit

  // Default city
  static const String defaultCity = 'Berlin';

  // Image assets
  static const String cloudyBackground = 'assets/images/cloudy.jpg';
  static const String sunnyBackground = 'assets/images/sunny.jpg';
  static const String rainyBackground = 'assets/images/rainy.jpg';
  static const String snowyBackground = 'assets/images/snowy.jpg';

  // German cities for suggestions
  static const List<String> popularCities = [
    "Berlin",
    "Hamburg",
    "Munich",
    "Cologne",
    "Frankfurt",
    "Stuttgart",
    "Düsseldorf",
    "Leipzig",
    "Dortmund",
    "Essen",
    "Bremen",
    "Dresden",
    "Hannover",
    "Nuremberg",
    "Duisburg",
    "Bochum",
    "Wuppertal",
    "Bielefeld",
    "Bonn",
    "Münster",
    "Karlsruhe",
    "Mannheim",
    "Augsburg",
    "Wiesbaden",
    "Mönchengladbach",
    "Gelsenkirchen",
    "Aachen",
    "Braunschweig",
    "Kiel",
    "Chemnitz",
    "Halle",
    "Freiburg",
    "Krefeld",
    "Mainz",
    "Lübeck",
    "Erfurt",
    "Rostock",
    "Kassel",
    "Hagen",
    "Potsdam",
  ];
}
