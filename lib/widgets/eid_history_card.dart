// lib/widgets/eid_history_card.dart

import 'package:flutter/material.dart';
import '../models/eid_change.dart';
import 'package:intl/intl.dart';
import '../i18n/app_localizations.dart';
import '../i18n/app_strings.dart';
import '../utils/constants.dart';

class EidHistoryCard extends StatelessWidget {
  final List<EidChange> history;

  const EidHistoryCard({
    super.key,
    required this.history,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey.shade400),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                l10n.translate(AppStrings.noEidChanges),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: Theme.of(context).primaryColor,
                  size: AppConstants.iconSizeRegular,
                ),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: Text(
                    l10n.translate(AppStrings.eidHistory),
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeSectionTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withValues(alpha: AppConstants.opacityLight),
                    borderRadius:
                        BorderRadius.circular(AppConstants.badgeBorderRadius),
                  ),
                  child: Text(
                    '${history.length}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeSmall,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            const Divider(),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            ...history.reversed
                .map((change) => _buildHistoryItem(context, change)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, EidChange change) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: AppConstants.timelineCircleSize,
                height: AppConstants.timelineCircleSize,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (history.last != change)
                Container(
                  width: AppConstants.timelineLineWidth,
                  height: AppConstants.timelineLineHeight,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingSmall),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    EidChangeReason.getLabel(change.reason, context),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeBody,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingExtraSmall),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.translate(AppStrings.oldEid),
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeTiny,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              change.oldEid,
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward,
                          size: AppConstants.iconSizeTiny),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.translate(AppStrings.newEid),
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeTiny,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              change.newEid,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                fontFamily: 'monospace',
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingExtraSmall),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: AppConstants.iconSizeTiny,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: AppConstants.spacingTiny),
                      Text(
                        _formatDate(change.changedAt),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeTiny,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (change.notes != null && change.notes!.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.spacingExtraSmall),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingExtraSmall),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusSmall),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.note,
                            size: AppConstants.iconSizeTiny,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              change.notes!,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeTiny,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
