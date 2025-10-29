// lib/widgets/status_badge.dart
import 'package:flutter/material.dart';
import '../models/animal.dart';

class StatusBadge extends StatelessWidget {
  final AnimalStatus status;
  final bool showLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case AnimalStatus.alive:
        color = Colors.green;
        label = 'Vivant';
        icon = Icons.check_circle;
        break;
      case AnimalStatus.sold:
        color = Colors.blue;
        label = 'Vendu';
        icon = Icons.sell;
        break;
      case AnimalStatus.dead:
        color = Colors.grey;
        label = 'Mort';
        icon = Icons.cancel;
        break;
    }

    if (!showLabel) {
      return Icon(icon, color: color, size: 20);
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

class SexBadge extends StatelessWidget {
  final AnimalSex sex;

  const SexBadge({super.key, required this.sex});

  @override
  Widget build(BuildContext context) {
    final isFemale = sex == AnimalSex.female;

    return CircleAvatar(
      radius: 16,
      backgroundColor: isFemale ? Colors.pink.shade100 : Colors.blue.shade100,
      child: Icon(
        isFemale ? Icons.female : Icons.male,
        color: isFemale ? Colors.pink : Colors.blue,
        size: 20,
      ),
    );
  }
}
