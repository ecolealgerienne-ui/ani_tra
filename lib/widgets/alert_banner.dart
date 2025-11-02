// lib/widgets/alert_banner.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Bannière d'alerte pour les urgences
///
/// Affiche une bannière rouge en haut de l'écran d'accueil pour signaler :
/// - Animaux avec délai d'attente critique (< 3 jours)
/// - Animaux nécessitant une attention immédiate
///
/// Design : Fond rouge avec icône d'alerte et texte blanc
class AlertBanner extends StatelessWidget {
  final int criticalCount;
  final VoidCallback onTap;

  const AlertBanner({
    super.key,
    required this.criticalCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (criticalCount == 0) {
      return const SizedBox.shrink(); // N'affiche rien si pas d'alerte
    }

    return Material(
      color: Colors.red.shade700,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icône d'alerte
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Texte d'alerte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      criticalCount == 1
                          ? '⚠️ 1 animal en délai d\'attente critique'
                          : '⚠️ $criticalCount animaux en délai d\'attente critique',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Traitement à surveiller (< ${AppConstants.withdrawalCriticalThreshold} jours)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Flèche pour indiquer que c'est cliquable
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
