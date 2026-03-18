import 'package:flutter/material.dart';
import 'package:amorra/data/models/user_model.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_badge.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_card.dart';
import 'package:amorra/presentation/widgets/admin_web/users/user_actions_menu.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/constants/app_constants.dart';

/// User List Widget
/// Mobile-optimized list view for users
class UserList extends StatelessWidget {
  final List<UserModel> users;
  final Function(UserModel) onViewDetails;
  final Function(UserModel) onBlockUnblock;

  const UserList({
    super.key,
    required this.users,
    required this.onViewDetails,
    required this.onBlockUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: WebSpacing.all(context, factor: 0.5),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return WebCard(
          margin: EdgeInsets.only(bottom: WebSpacing.medium(context).height!),
          padding: WebSpacing.all(context, factor: 1.0),
          onTap: () => onViewDetails(user),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: WebResponsive.isDesktop(context) ? 24 : 20,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: WebTextStyles.bodyText(context).copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  WebSpacing.horizontalSpacing(context, 1.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: WebTextStyles.bodyText(
                            context,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (user.email != null)
                          Text(
                            user.email!,
                            style: WebTextStyles.caption(context),
                          ),
                      ],
                    ),
                  ),
                  UserActionsMenu(
                    user: user,
                    onViewDetails: () => onViewDetails(user),
                    onBlockUnblock: () => onBlockUnblock(user),
                  ),
                ],
              ),
              WebSpacing.medium(context),
              Wrap(
                spacing: 8,
                children: [
                  WebBadge(
                    text: user.subscriptionStatus,
                    color: _getStatusColor(user.subscriptionStatus),
                  ),
                  if (user.isBlocked)
                    WebBadge(
                      text: WebTexts.statusBlocked,
                      color: AppColors.error,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.subscriptionStatusActive:
        return AppColors.success;
      case AppConstants.subscriptionStatusCancelled:
        return Colors.orange;
      case AppConstants.subscriptionStatusExpired:
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }
}
