import 'package:flutter/material.dart';
import '../../widgets/shared/action_card.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionCard(
            icon: Icons.water_drop,
            label: 'Mulai Irigasi\nManual',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ActionCard(
            icon: Icons.bar_chart,
            label: 'Lihat Riwayat\nIrigasi',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
