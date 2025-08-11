import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String iconPath;
  final Color iconColor;
  final double value;
  final String unit;
  final String label;
  final VoidCallback? onTap; // <-- TAMBAHKAN INI

  const SensorCard({
    super.key,
    required this.iconPath,
    required this.value,
    required this.unit,
    required this.label,
    this.iconColor = Colors.black,
    this.onTap, // <-- TAMBAHKAN INI
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Image.asset(
      iconPath,
      color: iconColor,
      width: 32,
      height: 32,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error, color: iconColor, size: 32);
      },
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        // <-- BUNGKUS DENGAN INKWELL
        onTap: onTap, // <-- GUNAKAN ONTAP DI SINI
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconPath.contains('plant.png')
                  ? Image.asset(iconPath, width: 48, height: 48)
                  : iconWidget,
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value $unit',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
