import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/weather_provider.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Loading weather data...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (provider.currentCity != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'for ${provider.currentCity}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}
