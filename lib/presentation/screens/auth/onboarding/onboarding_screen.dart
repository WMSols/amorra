import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/app_images/app_images.dart';
import 'package:amorra/core/utils/app_lotties/app_lotties.dart';
import 'package:amorra/core/utils/app_responsive/app_responsive.dart';
import 'package:amorra/core/utils/app_spacing/app_spacing.dart';
import 'package:amorra/core/utils/app_texts/app_texts.dart';
import 'package:amorra/presentation/controllers/auth/onboarding/onboarding_controller.dart';
import 'package:amorra/presentation/widgets/common/app_dots_indicator.dart';
import 'package:amorra/presentation/widgets/common/app_large_button.dart';
import 'package:amorra/presentation/widgets/common/app_text_button.dart';
import 'package:amorra/presentation/widgets/common/app_lottie_message.dart';
import 'package:amorra/presentation/widgets/auth/onboarding/onboarding_page_widget.dart';

/// Onboarding Screen
/// Displays 3 onboarding screens with swipe functionality
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Step Indicator (Steps 3-5 of 5) - Full width, equally split
                // Combined steps: Age Verification (1), Profile Setup (2), Onboarding (3-5)
                Obx(
                  () => AppDotsIndicator(
                    totalPages: 5,
                    currentPage: 2 + controller.currentPage.value,
                    // Step 3-5 (Onboarding Pages) - after Age Verification (0) and Profile Setup (1)
                    fullWidth: true,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.secondary,
                  ),
                ),

                // Skip Button Area
                SizedBox(
                  height: AppResponsive.screenHeight(context) * 0.08,
                  child: Obx(
                    () =>
                        controller.currentPage.value < controller.totalPages - 1
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: AppSpacing.symmetric(
                                context,
                                h: 0.04,
                                v: 0.02,
                              ),
                              child: AppTextButton(
                                text: AppTexts.skip,
                                onPressed: controller.skipOnboarding,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                // PageView for onboarding pages
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    children: [
                      // Screen 1
                      OnboardingPageWidget(
                        imagePath: AppImages.onboarding1,
                        title: AppTexts.onboarding1Title,
                        subtitle: AppTexts.onboarding1Subtitle,
                      ),

                      // Screen 2
                      OnboardingPageWidget(
                        imagePath: AppImages.onboarding2,
                        title: AppTexts.onboarding2Title,
                        subtitle: AppTexts.onboarding2Subtitle,
                      ),

                      // Screen 3
                      OnboardingPageWidget(
                        imagePath: AppImages.onboarding3,
                        title: AppTexts.onboarding3Title,
                        subtitle: AppTexts.onboarding3Subtitle,
                      ),
                    ],
                  ),
                ),

                // Button Section (no bottom dots indicator)
                Padding(
                  padding: AppSpacing.symmetric(context, h: 0.04, v: 0.03),
                  child: Obx(
                    () => AppLargeButton(
                      text: controller.isLastPage
                          ? AppTexts.getStarted
                          : AppTexts.next,
                      onPressed: controller.nextPage,
                    ),
                  ),
                ),
              ],
            ),
            // Completion Animation Overlay
            Obx(
              () => controller.showCompletionAnimation.value
                  ? AppLottieMessage(
                      lottiePath: AppLotties.completed,
                      message: AppTexts.onboardingLottieAnimationMessage,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
