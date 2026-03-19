import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/app_responsive/app_responsive.dart';
import 'package:amorra/core/utils/app_spacing/app_spacing.dart';
import 'package:amorra/core/utils/app_styles/app_text_styles.dart';
import 'package:amorra/core/utils/app_texts/app_texts.dart';
import 'package:amorra/core/config/routes.dart';
import 'package:url_launcher/url_launcher.dart';

/// Auth Footer Widget
/// Reusable footer for auth screens
/// Can display either:
/// - Signup Link (for signin screen)
/// - Terms & Privacy + Login Link (for signup screen)
class AuthFooter extends StatelessWidget {
  final AuthFooterType type;
  static final Uri _termsUrl = Uri.parse('https://amorraai.web.app/terms.html');
  static final Uri _privacyUrl = Uri.parse('https://amorraai.web.app/privacy.html');

  const AuthFooter({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AuthFooterType.signin:
        return _buildSigninFooter(context);
      case AuthFooterType.signup:
        return _buildSignupFooter(context);
    }
  }

  /// Build footer for signin screen (Signup Link)
  Widget _buildSigninFooter(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyText(
            context,
          ).copyWith(color: AppColors.grey),
          children: [
            TextSpan(text: AppTexts.dontHaveAccount),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: () => Get.offAllNamed(AppRoutes.signup),
                child: Text(
                  AppTexts.registerLink,
                  style: AppTextStyles.bodyText(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build footer for signup screen (Terms & Privacy + Login Link)
  Widget _buildSignupFooter(BuildContext context) {
    return Column(
      children: [
        // Terms & Privacy
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodyText(context).copyWith(
                color: AppColors.grey,
                fontSize: AppResponsive.scaleSize(context, 14),
              ),
              children: [
                TextSpan(text: AppTexts.termsPrefix),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () => _openExternalLink(_termsUrl),
                    child: Text(
                      AppTexts.termsLink,
                      style: AppTextStyles.bodyText(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppResponsive.scaleSize(context, 14),
                      ),
                    ),
                  ),
                ),
                TextSpan(
                  text: AppTexts.termsAnd,
                  style: AppTextStyles.bodyText(context).copyWith(
                    color: AppColors.grey,
                    fontSize: AppResponsive.scaleSize(context, 14),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () => _openExternalLink(_privacyUrl),
                    child: Text(
                      AppTexts.privacyLink,
                      style: AppTextStyles.bodyText(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppResponsive.scaleSize(context, 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.vertical(context, 0.02),

        // Login Link
        Center(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.grey),
              children: [
                TextSpan(text: AppTexts.alreadyHaveAccount),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () => Get.offAllNamed(AppRoutes.signin),
                    child: Text(
                      AppTexts.loginLink,
                      style: AppTextStyles.bodyText(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openExternalLink(Uri uri) async {
    final canOpen = await canLaunchUrl(uri);
    if (!canOpen) {
      Get.snackbar(
        'Link unavailable',
        'Could not open ${uri.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Auth Footer Type
enum AuthFooterType { signin, signup }
