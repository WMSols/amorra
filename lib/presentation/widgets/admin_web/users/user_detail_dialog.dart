import 'package:flutter/material.dart';
import 'package:amorra/data/models/user_model.dart';
import 'package:amorra/presentation/widgets/admin_web/common/detail_dialog.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';

/// User Detail Dialog Widget
/// Dialog for displaying user details
class UserDetailDialog extends StatelessWidget {
  final UserModel user;

  const UserDetailDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DetailDialog(
      title: '${WebTexts.userDetailsTitle}: ${user.name}',
      rows: [
        DetailRow(
          label: WebTexts.userDetailsName,
          value: Text(user.name, style: WebTextStyles.bodyText(context)),
        ),
        if (user.email != null)
          DetailRow(
            label: WebTexts.userDetailsEmail,
            value: Text(user.email!, style: WebTextStyles.bodyText(context)),
          ),
        if (user.age != null)
          DetailRow(
            label: WebTexts.userDetailsAge,
            value: Text(
              user.age.toString(),
              style: WebTextStyles.bodyText(context),
            ),
          ),
        DetailRow(
          label: WebTexts.userDetailsUserId,
          value: Text(user.id, style: WebTextStyles.bodyText(context)),
        ),
        DetailRow(
          label: WebTexts.userDetailsCreated,
          value: Text(
            _formatDate(user.createdAt),
            style: WebTextStyles.bodyText(context),
          ),
        ),
        if (user.updatedAt != null)
          DetailRow(
            label: WebTexts.userDetailsUpdated,
            value: Text(
              _formatDate(user.updatedAt!),
              style: WebTextStyles.bodyText(context),
            ),
          ),
        DetailRow(
          label: WebTexts.userDetailsSubscriptionStatus,
          value: Text(
            user.subscriptionStatus,
            style: WebTextStyles.bodyText(context),
          ),
        ),
        DetailRow(
          label: WebTexts.userDetailsIsSubscribed,
          value: Text(
            user.isSubscribed.toString(),
            style: WebTextStyles.bodyText(context),
          ),
        ),
        DetailRow(
          label: WebTexts.userDetailsAgeVerified,
          value: Text(
            user.isAgeVerified.toString(),
            style: WebTextStyles.bodyText(context),
          ),
        ),
        DetailRow(
          label: WebTexts.userDetailsOnboardingComplete,
          value: Text(
            user.isOnboardingCompleted.toString(),
            style: WebTextStyles.bodyText(context),
          ),
        ),
        DetailRow(
          label: WebTexts.userDetailsIsBlocked,
          value: Text(
            user.isBlocked.toString(),
            style: WebTextStyles.bodyText(context),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
