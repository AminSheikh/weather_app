class AppConstants {
  // Add your OpenWeatherMap API key here
  static const String apiKey = '9e318b8220efc089deea0668e1917100';

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
