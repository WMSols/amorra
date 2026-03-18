import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/app_images/app_images.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';

/// Web Snackbar Type Enum
enum WebSnackbarType { error, success, info, warning }

/// Web Snackbar Widget
/// Desktop-optimized snackbar for admin dashboard
class WebSnackbar extends StatelessWidget {
  final String title;
  final String subtitle;
  final WebSnackbarType type;
  final VoidCallback? onClose;

  const WebSnackbar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
    this.onClose,
  });

  /// Get border color based on type
  Color get _borderColor {
    switch (type) {
      case WebSnackbarType.error:
        return AppColors.error;
      case WebSnackbarType.success:
        return AppColors.success;
      case WebSnackbarType.info:
        return AppColors.information;
      case WebSnackbarType.warning:
        return AppColors.warning;
    }
  }

  /// Get cross icon color based on type
  Color get _iconColor {
    switch (type) {
      case WebSnackbarType.error:
        return AppColors.error;
      case WebSnackbarType.success:
        return AppColors.success;
      case WebSnackbarType.info:
        return AppColors.information;
      case WebSnackbarType.warning:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: WebSpacing.all(context, factor: 1.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          WebResponsive.radius(context, factor: 1.0),
        ),
        border: Border.all(color: _borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha:0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // App Logo
          Image.asset(
            AppImages.splashLogo,
            width: WebResponsive.iconSize(context, factor: 1.5),
            height: WebResponsive.iconSize(context, factor: 1.5),
            fit: BoxFit.contain,
          ),
          WebSpacing.horizontalSpacing(context, 0.75),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: WebTextStyles.bodyText(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                WebSpacing.small(context),
                Text(
                  subtitle,
                  style: WebTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),

          // Cross Icon
          IconButton(
            icon: Icon(
              Iconsax.close_circle,
              color: _iconColor,
              size: WebResponsive.iconSize(context, factor: 0.9),
            ),
            onPressed: onClose ?? () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  static void showError({
    required String title,
    required String subtitle,
    Duration? duration,
    BuildContext? context,
  }) {
    final ctx = context ?? Get.context;
    if (ctx == null) return;

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: WebSnackbar(
        title: title,
        subtitle: subtitle,
        type: WebSnackbarType.error,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(
        horizontal: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenWidth(ctx) * 0.02
            : WebResponsive.screenWidth(ctx) * 0.04,
        vertical: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenHeight(ctx) * 0.01
            : WebResponsive.screenHeight(ctx) * 0.02,
      ),
      padding: EdgeInsets.zero,
      overlayBlur: 0, // Disable blur effect
      barBlur: 0, // Disable bar blur
    );
  }

  /// Show success snackbar
  static void showSuccess({
    required String title,
    required String subtitle,
    Duration? duration,
    BuildContext? context,
  }) {
    final ctx = context ?? Get.context;
    if (ctx == null) return;

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: WebSnackbar(
        title: title,
        subtitle: subtitle,
        type: WebSnackbarType.success,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(
        horizontal: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenWidth(ctx) * 0.02
            : WebResponsive.screenWidth(ctx) * 0.04,
        vertical: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenHeight(ctx) * 0.01
            : WebResponsive.screenHeight(ctx) * 0.02,
      ),
      padding: EdgeInsets.zero,
      overlayBlur: 0, // Disable blur effect
      barBlur: 0, // Disable bar blur
    );
  }

  /// Show info snackbar
  static void showInfo({
    required String title,
    required String subtitle,
    Duration? duration,
    BuildContext? context,
  }) {
    final ctx = context ?? Get.context;
    if (ctx == null) return;

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: WebSnackbar(
        title: title,
        subtitle: subtitle,
        type: WebSnackbarType.info,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(
        horizontal: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenWidth(ctx) * 0.02
            : WebResponsive.screenWidth(ctx) * 0.04,
        vertical: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenHeight(ctx) * 0.01
            : WebResponsive.screenHeight(ctx) * 0.02,
      ),
      padding: EdgeInsets.zero,
      overlayBlur: 0, // Disable blur effect
      barBlur: 0, // Disable bar blur
    );
  }

  /// Show warning snackbar
  static void showWarning({
    required String title,
    required String subtitle,
    Duration? duration,
    BuildContext? context,
  }) {
    final ctx = context ?? Get.context;
    if (ctx == null) return;

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: WebSnackbar(
        title: title,
        subtitle: subtitle,
        type: WebSnackbarType.warning,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(
        horizontal: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenWidth(ctx) * 0.02
            : WebResponsive.screenWidth(ctx) * 0.04,
        vertical: WebResponsive.isDesktop(ctx)
            ? WebResponsive.screenHeight(ctx) * 0.01
            : WebResponsive.screenHeight(ctx) * 0.02,
      ),
      padding: EdgeInsets.zero,
      overlayBlur: 0, // Disable blur effect
      barBlur: 0, // Disable bar blur
    );
  }
}
