import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (!notification.isRead) _buildNewTag(),
                        Flexible(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat(
                        'd MMMM yyyy, HH:mm WIB',
                        'id_ID',
                      ).format(notification.timestamp),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color color;
    switch (notification.type) {
      case NotificationType.warning:
        iconData = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case NotificationType.info:
        iconData = Icons.info_outline_rounded;
        color = Colors.blue;
        break;
      case NotificationType.success:
        iconData = Icons.check_circle_outline_rounded;
        color = Colors.green;
        break;
      case NotificationType.danger:
        iconData = Icons.error_outline_outlined;
        color = Colors.red;
        break;
    }
    return Icon(iconData, color: color, size: 32);
  }

  Widget _buildNewTag() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'BARU',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
