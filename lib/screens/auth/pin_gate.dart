import 'package:flutter/material.dart';
import '../../i18n/app_localizations.dart';
import '../../widgets/info_card.dart';
import '../../widgets/custom_button.dart';
import '../../data/mock_auth.dart';

class PinGate extends StatefulWidget {
  final Widget onUnlocked;
  const PinGate({super.key, required this.onUnlocked});

  @override
  State<PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<PinGate> {
  final _ctrl = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await MockAuth.verifyPin(_ctrl.text);
    setState(() {
      _busy = false;
    });
    if (ok) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.onUnlocked),
      );
    } else {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _error = l10n.translate('auth_pin_invalid');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    final mockStateText = l10n.translate('auth_mock_enabled');
    final mockHint = l10n
        .translate('auth_mock_hint_with_default')
        .replaceFirst('{pin}', MockAuth.defaultPin);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('auth_sandbox_title'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                InfoCard(
                  title: mockStateText,
                  subtitle: mockHint,
                  icon: Icons.lock,
                  color: scheme.primaryContainer,
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _ctrl,
                  decoration: InputDecoration(
                    labelText: l10n.translate('auth_pin_label'),
                    hintText: l10n.translate('auth_pin_hint'),
                    errorText: _error,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: _busy
                      ? l10n.translate('auth_verifying')
                      : l10n.translate('auth_unlock'),
                  icon: Icons.login,
                  isLoading: _busy,
                  onPressed: _busy ? null : _submit,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translate('auth_no_impact_note'),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.outline),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
