// lib/widgets/change_eid_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animal.dart';
import '../models/eid_change.dart';
import '../providers/animal_provider.dart';
import '../i18n/app_localizations.dart';
import '../i18n/app_strings.dart';
import '../utils/constants.dart';

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
      //final animalProvider = context.read<AnimalProvider>();

      final success = await context.read<AnimalProvider>().changeAnimalEid(
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
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.eidChangedSuccess)),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.eidChangedError)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '❌ ${AppLocalizations.of(context).translate(AppStrings.error)}: ${e.toString()}'),
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
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.qr_code, color: Theme.of(context).primaryColor),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Text(l10n.translate(AppStrings.changeEidTitle)),
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
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSmall),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate(AppStrings.currentEid),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),
                    Text(
                      widget.animal.displayName,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSectionTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newEidController,
                decoration: InputDecoration(
                  labelText: l10n.translate(AppStrings.newEidLabel),
                  hintText: l10n.translate(AppStrings.newEidHint),
                  prefixIcon: const Icon(Icons.qr_code_scanner),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.translate(AppStrings.eidRequired);
                  }
                  if (value.trim() == widget.animal.currentEid) {
                    return l10n.translate(AppStrings.eidMustBeDifferent);
                  }
                  if (value.length < 10) {
                    return l10n.translate(AppStrings.eidTooShort);
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                l10n.translate(AppStrings.changeReason),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppConstants.spacingExtraSmall),
              RadioGroup<String>(
                groupValue: _selectedReason,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedReason = value;
                    });
                  }
                },
                child: Column(
                  children: EidChangeReason.all.map((reason) {
                    return RadioListTile<String>(
                      title: Text(EidChangeReason.getLabel(reason, context)),
                      value: reason,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: l10n.translate(AppStrings.optionalNotes),
                  hintText: l10n.translate(AppStrings.notesHintEid),
                  border: const OutlineInputBorder(),
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
          child: Text(l10n.translate(AppStrings.cancel)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: AppConstants.loaderSizeSmall,
                  height: AppConstants.loaderSizeSmall,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.translate(AppStrings.changeEidTitle)),
        ),
      ],
    );
  }
}
