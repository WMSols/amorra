import 'package:flutter/material.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';

/// Web Spacing Utility
/// Desktop-optimized spacing utilities for web admin dashboard
class WebSpacing {
  /// All sides padding with desktop-optimized values
  static EdgeInsets all(BuildContext context, {double factor = 1.0}) {
    final basePadding = WebResponsive.isDesktop(context) ? 24.0 : 16.0;
    return EdgeInsets.all(basePadding * factor);
  }

  /// Symmetric padding (horizontal and vertical)
  static EdgeInsets symmetric(
    BuildContext context, {
    double h = 1.0,
    double v = 1.0,
  }) {
    final baseHPadding = WebResponsive.isDesktop(context) ? 24.0 : 16.0;
    final baseVPadding = WebResponsive.isDesktop(context) ? 20.0 : 16.0;
    return EdgeInsets.symmetric(
      horizontal: baseHPadding * h,
      vertical: baseVPadding * v,
    );
  }

  /// Horizontal padding only
  static EdgeInsets horizontal(BuildContext context, {double factor = 1.0}) {
    final basePadding = WebResponsive.isDesktop(context) ? 24.0 : 16.0;
    return EdgeInsets.symmetric(horizontal: basePadding * factor);
  }

  /// Vertical padding only
  static EdgeInsets vertical(BuildContext context, {double factor = 1.0}) {
    final basePadding = WebResponsive.isDesktop(context) ? 20.0 : 16.0;
    return EdgeInsets.symmetric(vertical: basePadding * factor);
  }

  /// Vertical spacing (SizedBox height)
  static SizedBox verticalSpacing(BuildContext context, double factor) {
    final baseSpacing = WebResponsive.isDesktop(context) ? 20.0 : 16.0;
    return SizedBox(height: baseSpacing * factor);
  }

  /// Horizontal spacing (SizedBox width)
  static SizedBox horizontalSpacing(BuildContext context, double factor) {
    final baseSpacing = WebResponsive.isDesktop(context) ? 20.0 : 16.0;
    return SizedBox(width: baseSpacing * factor);
  }

  /// Card padding (optimized for cards)
  static EdgeInsets card(BuildContext context) {
    return WebResponsive.cardPadding(context);
  }

  /// Section spacing (between major sections)
  static SizedBox section(BuildContext context) {
    return SizedBox(height: WebResponsive.sectionSpacing(context));
  }

  /// Small spacing (between related items)
  static SizedBox small(BuildContext context) {
    final spacing = WebResponsive.isDesktop(context) ? 6.0 : 4.0;
    return SizedBox(height: spacing);
  }

  /// Medium spacing (between groups)
  static SizedBox medium(BuildContext context) {
    final spacing = WebResponsive.isDesktop(context) ? 12.0 : 8.0;
    return SizedBox(height: spacing);
  }

  /// Large spacing (between major sections)
  static SizedBox large(BuildContext context) {
    final spacing = WebResponsive.isDesktop(context) ? 28.0 : 20.0;
    return SizedBox(height: spacing);
  }

  /// Extra large spacing (between pages/screens)
  static SizedBox extraLarge(BuildContext context) {
    final spacing = WebResponsive.isDesktop(context) ? 40.0 : 22.0;
    return SizedBox(height: spacing);
  }

  /// Table cell padding
  static EdgeInsets tableCell(BuildContext context) {
    if (WebResponsive.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    } else {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    }
  }

  /// Button padding
  static EdgeInsets button(BuildContext context) {
    if (WebResponsive.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  /// Input field padding
  static EdgeInsets inputField(BuildContext context) {
    if (WebResponsive.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    } else {
      return const EdgeInsets.symmetric(horizontal: 14, vertical: 12);
    }
  }
}
