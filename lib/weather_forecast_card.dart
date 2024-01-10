import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const WeatherForecastCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: Colors.lightBlueAccent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 90,
              child: Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(
                    icon,
                    size: 35,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    temperature,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
