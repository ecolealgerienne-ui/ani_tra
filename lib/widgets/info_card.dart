// lib/widgets/info_card.dart
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.color,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: cardColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onDismiss;

  const AlertCard({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.color = Colors.blue,
    this.onDismiss,
  });

  factory AlertCard.warning({
    required String message,
    VoidCallback? onDismiss,
  }) {
    return AlertCard(
      message: message,
      icon: Icons.warning_amber,
      color: Colors.orange,
      onDismiss: onDismiss,
    );
  }

  factory AlertCard.error({
    required String message,
    VoidCallback? onDismiss,
  }) {
    return AlertCard(
      message: message,
      icon: Icons.error,
      color: Colors.red,
      onDismiss: onDismiss,
    );
  }

  factory AlertCard.success({
    required String message,
    VoidCallback? onDismiss,
  }) {
    return AlertCard(
      message: message,
      icon: Icons.check_circle,
      color: Colors.green,
      onDismiss: onDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.9),
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onDismiss,
              color: color,
            ),
        ],
      ),
    );
  }
}
