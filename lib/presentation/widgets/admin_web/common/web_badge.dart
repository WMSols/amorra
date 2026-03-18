import 'package:flutter/material.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';

/// Web Badge Widget
/// Desktop-optimized status badge
class WebBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? backgroundColor;

  const WebBadge({
    super.key,
    required this.text,
    required this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WebResponsive.isDesktop(context) ? 10 : 8,
        vertical: WebResponsive.isDesktop(context) ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(
          WebResponsive.radius(context, factor: 0.5),
        ),
        border: Border.all(color: color.withValues(alpha:0.3), width: 1),
      ),
      child: Text(
        text.toUpperCase(),
        style: WebTextStyles.badge(context).copyWith(
          color: color,
          fontSize: WebResponsive.fontSize(context, factor: 0.7),
        ),
      ),
    );
  }
}
