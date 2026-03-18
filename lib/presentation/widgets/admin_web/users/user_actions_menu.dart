import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/data/models/user_model.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';

/// User Actions Menu Widget
/// Popup menu for user actions
class UserActionsMenu extends StatelessWidget {
  final UserModel user;
  final VoidCallback onViewDetails;
  final VoidCallback onBlockUnblock;

  const UserActionsMenu({
    super.key,
    required this.user,
    required this.onViewDetails,
    required this.onBlockUnblock,
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
              Text(WebTexts.usersViewDetails),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: onBlockUnblock,
          child: Row(
            children: [
              Icon(
                user.isBlocked ? Iconsax.unlock : Iconsax.lock,
                size: WebResponsive.iconSize(context, factor: 0.7),
                color: AppColors.grey,
              ),
              WebSpacing.horizontalSpacing(context, 0.5),
              Text(
                user.isBlocked ? WebTexts.usersUnblock : WebTexts.usersBlock,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
