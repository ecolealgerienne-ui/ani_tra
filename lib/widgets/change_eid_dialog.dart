// lib/widgets/change_eid_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animal.dart';
import '../models/eid_change.dart';
import '../providers/animal_provider.dart';

/// Dialog pour changer l'EID d'un animal
///
/// Utilisé quand une puce RFID est perdue, cassée ou défectueuse
class ChangeEidDialog extends StatefulWidget {
  final Animal animal;

  const ChangeEidDialog({
    super.key,
    required this.animal,
  });

  @override
  State<ChangeEidDialog> createState() => _ChangeEidDialogState();
}

class _ChangeEidDialogState extends State<ChangeEidDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newEidController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedReason = EidChangeReason.puceCassee;
  bool _isLoading = false;

  @override
  void dispose() {
    _newEidController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final animalProvider = context.read<AnimalProvider>();

      final success = animalProvider.changeAnimalEid(
        animalId: widget.animal.id,
        newEid: _newEidController.text.trim(),
        reason: _selectedReason,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ EID changé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erreur lors du changement d\'EID'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.qr_code, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Changer l\'EID'),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EID actuel
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EID actuel',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.animal.currentEid,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Nouvel EID
              TextFormField(
                controller: _newEidController,
                decoration: const InputDecoration(
                  labelText: 'Nouvel EID *',
                  hintText: 'Ex: 250001234567890',
                  prefixIcon: Icon(Icons.qr_code_scanner),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'EID obligatoire';
                  }
                  if (value.trim() == widget.animal.currentEid) {
                    return 'Le nouvel EID doit être différent';
                  }
                  if (value.length < 10) {
                    return 'EID trop court';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Raison
              const Text(
                'Raison du changement *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ...EidChangeReason.all.map((reason) {
                return RadioListTile<String>(
                  title: Text(EidChangeReason.getLabel(reason)),
                  value: reason,
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedReason = value;
                      });
                    }
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                );
              }),

              const SizedBox(height: 16),

              // Notes optionnelles
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optionnel)',
                  hintText: 'Ex: Puce trouvée cassée lors du scan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Changer l\'EID'),
        ),
      ],
    );
  }
}
