import 'dart:ui';
import 'package:flutter/material.dart';

class AddInfoCard extends StatelessWidget {
  final IconData icon;
  final String property;
  final String value;
  const AddInfoCard({
    super.key,
    required this.icon,
    required this.property,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 5,
      color: Colors.white10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 8,
            sigmaX: 8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 40,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  property,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
