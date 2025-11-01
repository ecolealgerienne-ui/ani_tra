// lib/widgets/animal_card.dart

import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/animal_extensions.dart';

/// Carte d'affichage d'un animal dans la liste
///
/// ÉTAPE 3 : Affiche maintenant le type et la race
/// Exemple : "🐑 Ovin - Mérinos"
class AnimalCard extends StatelessWidget {
  final Animal animal;
  final VoidCallback? onTap;

  const AnimalCard({
    super.key,
    required this.animal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sexColor = animal.sex == AnimalSex.male ? Colors.blue : Colors.pink;
    final sexIcon = animal.sex == AnimalSex.male ? Icons.male : Icons.female;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: sexColor.withOpacity(0.1),
                radius: 24,
                child: Icon(sexIcon, color: sexColor),
              ),
              const SizedBox(width: 12),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Numéro officiel ou EID
                    Text(
                      animal.officialNumber ?? animal.eid,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ÉTAPE 3 : Affichage du type et de la race
                    if (animal.hasSpecies)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          animal.fullDisplayFr, // "🐑 Ovin - Mérinos"
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // EID (si différent du numéro affiché)
                    if (animal.officialNumber != null)
                      Text(
                        animal.eid,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                    const SizedBox(height: 4),

                    // Statut et âge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(animal.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusLabel(animal.status),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          animal.ageFormatted,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flèche
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.alive:
        return Colors.green;
      case AnimalStatus.sold:
        return Colors.orange;
      case AnimalStatus.dead:
        return Colors.red;
      case AnimalStatus.slaughtered:
        return Colors.grey;
    }
  }

  String _getStatusLabel(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.alive:
        return 'Vivant';
      case AnimalStatus.sold:
        return 'Vendu';
      case AnimalStatus.dead:
        return 'Mort';
      case AnimalStatus.slaughtered:
        return 'Abattu';
    }
  }
}
