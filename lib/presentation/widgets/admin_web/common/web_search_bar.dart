import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';

/// Web Search Bar Widget
/// Desktop-optimized search bar for admin dashboard
class WebSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const WebSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onFilterTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: WebTextStyles.bodyText(context),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: WebTextStyles.hintText(context),
              border: InputBorder.none,
              contentPadding: WebSpacing.inputField(context),
              prefixIcon: Icon(
                Iconsax.search_normal,
                color: AppColors.grey,
                size: WebResponsive.iconSize(context, factor: 0.8),
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          Container(
            width: 1,
            height: WebResponsive.screenHeight(context) * 0.04,
            color: AppColors.lightGrey,
          ),
          IconButton(
            icon: Icon(
              Iconsax.filter,
              color: AppColors.grey,
              size: WebResponsive.iconSize(context, factor: 0.9),
            ),
            onPressed: onFilterTap,
            tooltip: WebTexts.actionFilter,
          ),
        ],
      ],
    );
  }
}
