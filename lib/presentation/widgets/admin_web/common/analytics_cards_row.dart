import 'package:flutter/material.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_analytics_card.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';

/// Analytics Cards Row Widget
/// Reusable row of analytics cards
class AnalyticsCardsRow extends StatelessWidget {
  final List<AnalyticsCardItem> cards;

  const AnalyticsCardsRow({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i < cards.length - 1) WebSpacing.horizontalSpacing(context, 1.0),
        ],
      ],
    );
  }
}

/// Analytics Card Item Model
class AnalyticsCardItem extends WebAnalyticsCard {
  const AnalyticsCardItem({super.key, 
    required super.label,
    required super.value,
    required super.color,
    super.icon,
  });
}
