import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/app_responsive/app_responsive.dart';
import 'package:amorra/core/utils/app_styles/app_text_styles.dart';
import 'package:amorra/presentation/widgets/common/app_icon_button.dart';

/// Profile Name Display Widget
/// Displays user name with edit button
class ProfileNameDisplay extends StatelessWidget {
  final String userName;
  final VoidCallback onEditTap;

  const ProfileNameDisplay({
    super.key,
    required this.userName,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            userName,
            style: AppTextStyles.headline(context).copyWith(
              color: AppColors.white,
              fontSize: AppResponsive.scaleSize(context, 24),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppIconButton(
          icon: Iconsax.edit_2,
          onTap: onEditTap,
          backgroundColor: Colors.transparent,
          iconColor: AppColors.white,
        ),
      ],
    );
  }
}
