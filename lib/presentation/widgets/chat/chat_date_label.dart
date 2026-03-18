import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/app_responsive/app_responsive.dart';
import 'package:amorra/core/utils/app_spacing/app_spacing.dart';
import 'package:amorra/core/utils/app_styles/app_text_styles.dart';

/// Chat Date Label Widget
/// Displays date label with optional dividers
class ChatDateLabel extends StatelessWidget {
  final DateTime date;
  final bool showDividers;

  const ChatDateLabel({
    super.key,
    required this.date,
    this.showDividers = false,
  });

  /// Check if date is today
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get date label
  String _getDateLabel() {
    if (_isToday(date)) {
      return 'Today';
    } else if (_isYesterday(date)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = Container(
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.001),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 1),
        ),
      ),
      child: Text(
        _getDateLabel(),
        style: AppTextStyles.bodyText(context).copyWith(
          color: AppColors.grey,
          fontSize: AppResponsive.scaleSize(context, 12),
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (!showDividers) {
      return dateLabel;
    }

    // With dividers (for message list)
    return Padding(
      padding: AppSpacing.symmetric(context, h: 0, v: 0.01),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.lightGrey, thickness: 1)),
          dateLabel,
          Expanded(
            child: Divider(
              color: AppColors.grey.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
