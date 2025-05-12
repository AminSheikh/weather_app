import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import 'widgets/city_search_dialog.dart';
import 'widgets/weather_details.dart';
import 'widgets/loading_view.dart';
import 'widgets/error_view.dart';
import 'widgets/day_selector.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadForecast();
    });
  }

  Future<void> _loadForecast() async {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    await provider.fetchForecastByCity(city: provider.currentCity);
  }

  void _showCitySearchDialog() {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => CitySearchDialog(
        onCitySelected: (city) {
          if (city != provider.currentCity) {
            provider.fetchForecastByCity(city: city);
          }
        },
        currentCity: provider.currentCity ?? '',
      ),
    );
  }

  void _toggleTemperatureUnit() {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    provider.toggleTemperatureUnit();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/weather_backgrounds/clear_weather.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: GestureDetector(
                onTap: _showCitySearchDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        provider.currentCity ?? 'Select City',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: _toggleTemperatureUnit,
                  child: Text(
                    provider.temperatureUnit == TemperatureUnit.celsius
                        ? 'C° → F°'
                        : 'F° → C°',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: isLandscape
                ? null // Don't show bottom nav in landscape
                : provider.dailyForecasts.isNotEmpty
                    ? Container(
                        height: 100 + MediaQuery.of(context).padding.bottom,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: _buildDaySelector(provider, false),
                        ),
                      )
                    : null,
            body: _buildBody(provider, isLandscape),
          ),
        );
      },
    );
  }

  Widget _buildDaySelector(WeatherProvider provider, bool isLandscape) {
    return DaySelector(
      days: provider.dailyForecasts,
      onDaySelected: (index) {
        provider.selectDay(provider.dailyForecasts[index]);
      },
      selectedIndex: provider.dailyForecasts.indexWhere(
        (day) => day.date == provider.selectedDay?.date,
      ),
      isLandscape: isLandscape,
      iconUrls: provider.dailyForecasts
          .map((day) => provider.getIconUrl(day.weatherIcon))
          .toList(),
    );
  }

  Widget _buildBody(WeatherProvider provider, bool isLandscape) {
    if (provider.isLoading) {
      return const LoadingView();
    }

    if (provider.error.isNotEmpty) {
      return ErrorView(
        errorMessage: provider.error,
        onRetry: _loadForecast,
      );
    }

    if (provider.selectedDay == null) {
      return const Center(
        child: Text(
          'No forecast data available',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return RefreshIndicator(
      displacement: MediaQuery.of(context).padding.top + kToolbarHeight,
      onRefresh: _loadForecast,
      child: isLandscape
          ? _buildLandscapeLayout(provider)
          : _buildPortraitLayout(provider),
    );
  }

  Widget _buildPortraitLayout(WeatherProvider provider) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
          bottom: 80 + bottomPadding, // Account for bottom nav + safe area
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                provider.selectedDay!.friendlyDate,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildWeatherDetails(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(WeatherProvider provider) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenHeight - topPadding - kToolbarHeight,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding + kToolbarHeight + 10,
            bottom: 10 + bottomPadding,
            left: 10 + MediaQuery.of(context).padding.left,
            right: 10 + MediaQuery.of(context).padding.right,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Weather details
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        provider.selectedDay?.friendlyDate ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1),
                              blurRadius: 3.0,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildWeatherDetails(provider),
                  ],
                ),
              ),

              // Right side: Day selector
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  child: Container(
                    height: screenHeight * 0.8,
                    margin: const EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: provider.dailyForecasts.isNotEmpty
                        ? _buildDaySelector(provider, true)
                        : const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetails(WeatherProvider provider) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (provider.isToday) {
      // Get the actual forecast data for today
      final currentDay = provider.dailyForecasts.firstWhere(
        (day) => day.date == DateFormat('yyyy-MM-dd').format(DateTime.now()),
        orElse: () => provider.selectedDay!,
      );

      final tempUnit = provider.temperatureUnit;

      // Use current weather for display temperature and description
      final currentTemp = provider.currentTemperature.toDouble();

      // But use min/max from all forecasts for today for ranges
      final minTempC = currentDay.minTemp;
      final maxTempC = currentDay.maxTemp;

      // Convert if in Fahrenheit
      final minTemp = tempUnit == TemperatureUnit.celsius
          ? minTempC
          : provider.celsiusToFahrenheit(minTempC.round()).toDouble();
      final maxTemp = tempUnit == TemperatureUnit.celsius
          ? maxTempC
          : provider.celsiusToFahrenheit(maxTempC.round()).toDouble();

      return WeatherDetails(
        description: provider.currentWeatherDescription,
        iconUrl: provider.getIconUrl(provider.currentWeatherIcon),
        temperature: currentTemp,
        minTemp: minTemp,
        maxTemp: maxTemp,
        humidity: provider.currentHumidity,
        minHumidity: currentDay.minHumidity,
        maxHumidity: currentDay.maxHumidity,
        pressure: provider.currentPressure,
        minPressure: currentDay.minPressure,
        maxPressure: currentDay.maxPressure,
        windSpeed: provider.currentWindSpeed.toDouble(),
        minWindSpeed: currentDay.minWindSpeed,
        maxWindSpeed: currentDay.maxWindSpeed,
        isCurrent: true,
        isLandscape: isLandscape,
      );
    } else {
      final selectedDay = provider.selectedDay!;
      final tempUnit = provider.temperatureUnit;

      // Get temperature values
      final tempC = selectedDay.temperature.toDouble();
      final minTempC = selectedDay.minTemp;
      final maxTempC = selectedDay.maxTemp;

      // Convert if in Fahrenheit
      final temp = tempUnit == TemperatureUnit.celsius
          ? tempC
          : provider.celsiusToFahrenheit(tempC.round()).toDouble();
      final minTemp = tempUnit == TemperatureUnit.celsius
          ? minTempC
          : provider.celsiusToFahrenheit(minTempC.round()).toDouble();
      final maxTemp = tempUnit == TemperatureUnit.celsius
          ? maxTempC
          : provider.celsiusToFahrenheit(maxTempC.round()).toDouble();

      return WeatherDetails(
        description: selectedDay.weatherDescription,
        iconUrl: provider.getIconUrl(selectedDay.weatherIcon),
        temperature: temp,
        minTemp: minTemp,
        maxTemp: maxTemp,
        humidity: selectedDay.humidity,
        minHumidity: selectedDay.minHumidity,
        maxHumidity: selectedDay.maxHumidity,
        pressure: selectedDay.pressure,
        minPressure: selectedDay.minPressure,
        maxPressure: selectedDay.maxPressure,
        windSpeed: selectedDay.windSpeed.toDouble(),
        minWindSpeed: selectedDay.minWindSpeed,
        maxWindSpeed: selectedDay.maxWindSpeed,
        isCurrent: false,
        isLandscape: isLandscape,
      );
    }
  }
}
