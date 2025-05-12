import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherIcon extends StatelessWidget {
  final String iconUrl;
  final double size;

  const WeatherIcon({
    super.key,
    required this.iconUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: iconUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholder: (context, url) => SizedBox(
        width: size * 0.5,
        height: size * 0.5,
        child: const CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.cloud,
        size: size * 0.8,
        color: Colors.white,
      ),
    );
  }
}
