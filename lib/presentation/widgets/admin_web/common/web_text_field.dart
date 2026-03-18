import 'package:flutter/material.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';

/// Web Text Field Widget
/// Desktop-optimized text field for admin dashboard
class WebTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool enabled;

  const WebTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: WebTextStyles.label(context)),
        WebSpacing.small(context),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          enabled: enabled,
          style: WebTextStyles.bodyText(context),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: WebTextStyles.hintText(context),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled
                ? AppColors.white
                : AppColors.lightGrey.withValues(alpha:0.3),
            contentPadding: WebSpacing.inputField(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                WebResponsive.radius(context, factor: 1.0),
              ),
              borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                WebResponsive.radius(context, factor: 1.0),
              ),
              borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                WebResponsive.radius(context, factor: 1.0),
              ),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                WebResponsive.radius(context, factor: 1.0),
              ),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                WebResponsive.radius(context, factor: 1.0),
              ),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                WebResponsive.radius(context, factor: 1.0),
              ),
              borderSide: BorderSide(
                color: AppColors.lightGrey.withValues(alpha:0.5),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
