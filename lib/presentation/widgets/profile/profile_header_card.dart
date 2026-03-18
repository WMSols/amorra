import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/core/utils/app_responsive/app_responsive.dart';
import 'package:amorra/core/utils/app_spacing/app_spacing.dart';
import 'package:amorra/core/utils/app_gradient/app_gradient.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/presentation/widgets/common/app_image_avatar.dart';
import 'package:amorra/presentation/widgets/common/app_icon_button.dart';
import 'package:amorra/presentation/widgets/common/app_dots_indicator.dart';
import 'package:amorra/presentation/controllers/profile/profile_controller.dart';
import 'profile_name_display.dart';
import 'profile_name_edit_field.dart';

/// Profile Header Card Widget
/// Displays gradient card with avatar/profile image (swipeable) and editable name
class ProfileHeaderCard extends GetView<ProfileController> {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userName = controller.userName;
      final userAge = controller.userAge;
      final profileImageUrl = controller.profileImageUrl;
      final isEditingName = controller.isEditingName.value;
      final isUploadingImage = controller.isUploadingImage.value;
      final currentImageIndex = controller.currentImageIndex.value;
      final hasProfileImage = controller.hasProfileImage;

      final avatarSize =
          AppResponsive.screenWidth(context) * (isEditingName ? 0.25 : 0.35);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: AppSpacing.symmetric(
          context,
          h: 0.04,
          v: isEditingName ? 0.02 : 0.01,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, factor: 2),
          ),
        ).withAppGradient(),
        child: Column(
          children: [
            // Page Indicator (only show if both avatar and profile image exist)
            if (hasProfileImage && !isEditingName)
              AppDotsIndicator(
                key: const ValueKey('dots_indicator'),
                totalPages: 2,
                currentPage: currentImageIndex,
                activeColor: AppColors.white,
                inactiveColor: AppColors.white.withValues(alpha: 0.5),
              ),

            AppSpacing.vertical(context, 0.02),

            // Swipeable Avatar/Profile Image Container
            Stack(
              alignment: Alignment.center,
              children: [
                // Swipeable PageView for Avatar and Profile Image
                SizedBox(
                  width: avatarSize,
                  height: avatarSize,
                  child: controller.pageController != null
                      ? PageView.builder(
                          key: ValueKey(
                            hasProfileImage ? 'hasImage' : 'noImage',
                          ),
                          controller: controller.pageController!,
                          onPageChanged: controller.onPageChanged,
                          itemCount: hasProfileImage ? 2 : 1,
                          physics: hasProfileImage
                              ? const PageScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // If no profile image, always show avatar (index 0)
                            if (!hasProfileImage) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: avatarSize,
                                height: avatarSize,
                                child: AppImageAvatar(
                                  age: userAge,
                                  size: avatarSize,
                                ),
                              );
                            }
                            // Use index to determine which image to show (0 = avatar, 1 = profile)
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: avatarSize,
                              height: avatarSize,
                              child: AppImageAvatar(
                                age: userAge,
                                size: avatarSize,
                                profileImageUrl: profileImageUrl,
                                showProfileImage: index == 1,
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                ),

                // Action Buttons Overlay (only show when not editing name)
                if (!isEditingName)
                  // Upload button - always show when not editing
                  Positioned(
                    bottom: 0,
                    right: AppResponsive.scaleSize(context, 20),
                    child: AppIconButton(
                      icon: Iconsax.camera,
                      onTap: controller.uploadProfileImage,
                      isLoading: isUploadingImage,
                      backgroundColor: AppColors.white,
                      iconColor: AppColors.black,
                    ),
                  ),

                // Delete Button (only show if profile image exists and not editing)
                if (hasProfileImage && !isEditingName)
                  Positioned(
                    key: const ValueKey('delete_button'),
                    bottom: AppResponsive.scaleSize(context, 30),
                    right: 0,
                    child: AppIconButton(
                      icon: Iconsax.trash,
                      onTap: controller.deleteProfileImage,
                      isLoading: isUploadingImage,
                      backgroundColor: AppColors.error,
                      iconColor: AppColors.white,
                    ),
                  ),
              ],
            ),
            AppSpacing.vertical(context, 0.01),

            // Name Display/Edit with animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ),
                        ),
                    child: child,
                  ),
                );
              },
              child: isEditingName
                  ? ProfileNameEditField(
                      key: const ValueKey('edit'),
                      nameController: controller.nameController,
                      onSave: controller.saveName,
                      onCancel: controller.cancelEditingName,
                    )
                  : ProfileNameDisplay(
                      key: const ValueKey('display'),
                      userName: userName,
                      onEditTap: controller.startEditingName,
                    ),
            ),
          ],
        ),
      );
    });
  }
}
