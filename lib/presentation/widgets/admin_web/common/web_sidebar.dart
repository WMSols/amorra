import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';

/// Web Sidebar Widget
/// Desktop-optimized sidebar navigation for admin dashboard
class WebSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String? currentUserEmail;

  const WebSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WebResponsive.sidebarWidth(context),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: WebResponsive.isDesktop(context) ? 10.0 : 8.0,
              ),
              children: [
                _buildNavItem(
                  context,
                  icon: Iconsax.profile_2user,
                  label: WebTexts.navUsers,
                  index: 0,
                ),
                WebSpacing.small(context),
                _buildNavItem(
                  context,
                  icon: Iconsax.card_send,
                  label: WebTexts.navSubscriptions,
                  index: 1,
                ),
              ],
            ),
          ),

          // User Info Footer
          Container(
            padding: WebSpacing.all(context, factor: 0.75),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.3),
              border: Border(
                top: BorderSide(color: AppColors.lightGrey, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.profile_circle,
                      size: WebResponsive.iconSize(context, factor: 0.8),
                      color: AppColors.grey,
                    ),
                    WebSpacing.horizontalSpacing(context, 0.5),
                    Expanded(
                      child: Text(
                        currentUserEmail ?? 'Admin',
                        style: WebTextStyles.caption(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      hoverColor: AppColors.secondary.withValues(alpha: 0.1),
      child: Container(
        margin: WebSpacing.symmetric(context, h: 0.5, v: 0.25),
        padding: WebSpacing.symmetric(context, h: 0.75, v: 0.5),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(
            WebResponsive.radius(context, factor: 0.75),
          ),
          border: Border.all(color: AppColors.lightGrey, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.grey,
              size: WebResponsive.iconSize(context, factor: 0.9),
            ),
            WebSpacing.horizontalSpacing(context, 0.75),
            Expanded(
              child: Text(
                label,
                style: WebTextStyles.bodyText(context).copyWith(
                  fontWeight: FontWeight.normal,
                  color: isSelected ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
