import 'package:flutter/material.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';

/// Empty State Widget
/// Reusable empty state display with icon and message
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final double? iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize ?? WebResponsive.iconSize(context, factor: 3.0),
            color: AppColors.grey,
          ),
          WebSpacing.medium(context),
          Text(
            message,
            style: WebTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
