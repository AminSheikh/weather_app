import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../../providers/weather_provider.dart';

class WeatherDetails extends StatelessWidget {
  final String description;
  final String iconUrl;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final int minHumidity;
  final int maxHumidity;
  final int pressure;
  final int minPressure;
  final int maxPressure;
  final double windSpeed;
  final double minWindSpeed;
  final double maxWindSpeed;
  final bool isCurrent;
  final bool isLandscape;

  const WeatherDetails({
    super.key,
    required this.description,
    required this.iconUrl,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.minHumidity,
    required this.maxHumidity,
    required this.pressure,
    required this.minPressure,
    required this.maxPressure,
    required this.windSpeed,
    required this.minWindSpeed,
    required this.maxWindSpeed,
    this.isCurrent = false,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isLandscape ? 10 : 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            padding: EdgeInsets.all(isLandscape ? 20 : 25),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: isLandscape
                ? _buildLandscapeLayout(context)
                : _buildPortraitLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          description,
          style: TextStyle(
            fontSize: 20,
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
        const SizedBox(height: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              iconUrl,
              width: 130,
              height: 130,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.cloud,
                  size: 100,
                  color: Colors.white,
                );
              },
            ),
            Consumer<WeatherProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${temperature.round()}${provider.temperatureUnitSymbol}',
                      style: const TextStyle(
                        fontSize: 66,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${minTemp.round()} - ${maxTemp.round()}${provider.temperatureUnitSymbol}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildInfoRow(context),
        const SizedBox(height: 10),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Temperature and icon
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                description,
                style: TextStyle(
                  fontSize: 18,
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
              Image.network(
                iconUrl,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.cloud,
                    size: 80,
                    color: Colors.white,
                  );
                },
              ),
              Consumer<WeatherProvider>(
                builder: (context, provider, child) {
                  return Text(
                    '${temperature.round()}${provider.temperatureUnitSymbol}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Weather info items
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoItemWithRange(
                    'Humidity', '$humidity%', '$minHumidity% - $maxHumidity%'),
                const SizedBox(height: 6),
                _buildInfoItemWithRange('Pressure', '$pressure hPa',
                    '$minPressure - $maxPressure hPa'),
                const SizedBox(height: 6),
                _buildInfoItemWithRange('Wind', '${windSpeed.round()} km/h',
                    '${minWindSpeed.round()} - ${maxWindSpeed.round()} km/h'),
                const SizedBox(height: 8),
                _buildStatusBadge(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfoItemWithRange(
            'Humidity', '$humidity%', '$minHumidity% - $maxHumidity%'),
        const SizedBox(height: 8),
        _buildInfoItemWithRange(
            'Pressure', '$pressure hPa', '$minPressure - $maxPressure hPa'),
        const SizedBox(height: 8),
        _buildInfoItemWithRange('Wind', '${windSpeed.round()} km/h',
            '${minWindSpeed.round()} - ${maxWindSpeed.round()} km/h'),
      ],
    );
  }

  Widget _buildInfoItemWithRange(String label, String value, String range) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: const Offset(0.5, 0.5),
                  blurRadius: 2.0,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                range,
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final color = isCurrent
        ? Colors.blue.withValues(alpha: 0.7)
        : Colors.orange.withValues(alpha: 0.7);

    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ],
      ),
      child: Text(
        isCurrent ? 'Current Weather' : 'Forecast Weather',
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 2.0,
              color: Colors.black.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
