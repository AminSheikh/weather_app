import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/daily_forecast.dart';
import '../../../providers/weather_provider.dart';

class DayItem extends StatelessWidget {
  final DailyForecast day;
  final bool isSelected;
  final VoidCallback onTap;
  final String iconUrl;
  final bool isHorizontal;

  const DayItem({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
    required this.iconUrl,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    // Landscape layout (horizontal day item)
    if (isHorizontal) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 0.7,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day.dateShort,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 15.0,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CachedNetworkImage(
                  imageUrl: iconUrl,
                  width: 28,
                  height: 28,
                  placeholder: (context, url) => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.cloud,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Consumer<WeatherProvider>(
                builder: (context, provider, child) {
                  final minTemp =
                      provider.temperatureUnit == TemperatureUnit.celsius
                          ? day.minTemp.round()
                          : provider.celsiusToFahrenheit(day.minTemp.round());

                  final maxTemp =
                      provider.temperatureUnit == TemperatureUnit.celsius
                          ? day.maxTemp.round()
                          : provider.celsiusToFahrenheit(day.maxTemp.round());

                  return Text(
                    '$minTemp°/$maxTemp°',
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Colors.white,
                      fontSize: 13,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 15.0,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    // Portrait layout (vertical day item)
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: 85,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 0.7,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day.dateShort,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
                fontSize: 14,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 15.0,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
            CachedNetworkImage(
              imageUrl: iconUrl,
              width: 40,
              height: 30,
              placeholder: (context, url) => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.cloud,
                size: 24,
                color: Colors.white,
              ),
            ),
            Consumer<WeatherProvider>(
              builder: (context, provider, child) {
                final minTemp =
                    provider.temperatureUnit == TemperatureUnit.celsius
                        ? day.minTemp.round()
                        : provider.celsiusToFahrenheit(day.minTemp.round());

                final maxTemp =
                    provider.temperatureUnit == TemperatureUnit.celsius
                        ? day.maxTemp.round()
                        : provider.celsiusToFahrenheit(day.maxTemp.round());

                return Text(
                  '$minTemp°/$maxTemp°',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: Colors.white,
                    fontSize: 13,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 15.0,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
