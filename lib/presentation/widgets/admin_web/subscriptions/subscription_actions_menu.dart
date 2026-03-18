import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/data/models/subscription_model.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/constants/app_constants.dart';

/// Subscription Actions Menu Widget
/// Popup menu for subscription actions
class SubscriptionActionsMenu extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onViewDetails;
  final VoidCallback onCancel;
  final VoidCallback onReactivate;

  const SubscriptionActionsMenu({
    super.key,
    required this.subscription,
    required this.onViewDetails,
    required this.onCancel,
    required this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Iconsax.more,
        size: WebResponsive.iconSize(context, factor: 0.8),
        color: AppColors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: onViewDetails,
          child: Row(
            children: [
              Icon(
                Iconsax.eye,
                size: WebResponsive.iconSize(context, factor: 0.7),
                color: AppColors.grey,
              ),
              WebSpacing.horizontalSpacing(context, 0.5),
              Text(WebTexts.subscriptionsViewDetails),
            ],
          ),
        ),
        if (subscription.status == AppConstants.subscriptionStatusActive)
          PopupMenuItem(
            onTap: onCancel,
            child: Row(
              children: [
                Icon(
                  Iconsax.close_circle,
                  size: WebResponsive.iconSize(context, factor: 0.7),
                  color: AppColors.error,
                ),
                WebSpacing.horizontalSpacing(context, 0.5),
                Text(
                  WebTexts.subscriptionsCancel,
                  style: WebTextStyles.bodyText(
                    context,
                  ).copyWith(color: AppColors.error),
                ),
              ],
            ),
          ),
        if (subscription.status == AppConstants.subscriptionStatusCancelled)
          PopupMenuItem(
            onTap: onReactivate,
            child: Row(
              children: [
                Icon(
                  Iconsax.refresh,
                  size: WebResponsive.iconSize(context, factor: 0.7),
                  color: AppColors.success,
                ),
                WebSpacing.horizontalSpacing(context, 0.5),
                Text(
                  WebTexts.subscriptionsReactivate,
                  style: WebTextStyles.bodyText(
                    context,
                  ).copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
