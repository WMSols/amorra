import 'package:flutter/material.dart';
import 'package:amorra/data/models/subscription_model.dart';
import 'package:amorra/presentation/widgets/admin_web/common/detail_dialog.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';

/// Subscription Detail Dialog Widget
/// Dialog for displaying subscription details
class SubscriptionDetailDialog extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionDetailDialog({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return DetailDialog(
      title: WebTexts.subscriptionDetailsTitle,
      rows: [
        DetailRow(
          label: WebTexts.subscriptionDetailsId,
          value: Text(subscription.id, style: WebTextStyles.bodyText(context)),
        ),
        DetailRow(
          label: WebTexts.subscriptionDetailsUserId,
          value: Text(
            subscription.userId,
            style: WebTextStyles.bodyText(context),
          ),
        ),
        DetailRow(
          label: WebTexts.subscriptionDetailsStatus,
          value: Text(
            subscription.status,
            style: WebTextStyles.bodyText(context),
          ),
        ),
        DetailRow(
          label: WebTexts.subscriptionDetailsPlanName,
          value: Text(
            subscription.planName ?? WebTexts.subscriptionDetailsNA,
            style: WebTextStyles.bodyText(context),
          ),
        ),
        if (subscription.price != null)
          DetailRow(
            label: WebTexts.subscriptionDetailsPrice,
            value: Text(
              '\$${subscription.price!.toStringAsFixed(2)}',
              style: WebTextStyles.bodyText(context),
            ),
          ),
        if (subscription.startDate != null)
          DetailRow(
            label: WebTexts.subscriptionDetailsStartDate,
            value: Text(
              _formatDate(subscription.startDate!),
              style: WebTextStyles.bodyText(context),
            ),
          ),
        if (subscription.endDate != null)
          DetailRow(
            label: WebTexts.subscriptionDetailsEndDate,
            value: Text(
              _formatDate(subscription.endDate!),
              style: WebTextStyles.bodyText(context),
            ),
          ),
        if (subscription.cancelledAt != null)
          DetailRow(
            label: WebTexts.subscriptionDetailsCancelledAt,
            value: Text(
              _formatDate(subscription.cancelledAt!),
              style: WebTextStyles.bodyText(context),
            ),
          ),
        if (subscription.stripeSubscriptionId != null)
          DetailRow(
            label: WebTexts.subscriptionDetailsStripeSubscriptionId,
            value: Text(
              subscription.stripeSubscriptionId!,
              style: WebTextStyles.bodyText(context),
            ),
          ),
        if (subscription.stripeCustomerId != null)
          DetailRow(
            label: WebTexts.subscriptionDetailsStripeCustomerId,
            value: Text(
              subscription.stripeCustomerId!,
              style: WebTextStyles.bodyText(context),
            ),
          ),
        DetailRow(
          label: WebTexts.subscriptionDetailsCreated,
          value: Text(
            _formatDate(subscription.createdAt),
            style: WebTextStyles.bodyText(context),
          ),
        ),
        if (subscription.updatedAt != null)
          DetailRow(
            label: WebTexts.subscriptionDetailsUpdated,
            value: Text(
              _formatDate(subscription.updatedAt!),
              style: WebTextStyles.bodyText(context),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
