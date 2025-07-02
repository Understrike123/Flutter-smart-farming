import 'package:flutter/material.dart';
import '../../widgets/shared/status_chip.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const StatusChip(
          label: 'Sistem Online',
          color: Color(0xFF5E8C61),
          icon: Icons.check_circle,
        ),
        const SizedBox(width: 10),
        StatusChip(
          label: 'Irigasi: Nonaktif',
          color: Colors.grey.shade600,
          icon: Icons.water_drop_outlined,
        ),
      ],
    );
  }
}
