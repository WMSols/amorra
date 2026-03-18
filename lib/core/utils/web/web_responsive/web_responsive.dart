import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Web Responsive Utility
/// Desktop-optimized responsive utilities for web admin dashboard
class WebResponsive {
  // Desktop breakpoints
  static const double desktopBreakpoint = 1024;
  static const double largeDesktopBreakpoint = 1440;
  static const double extraLargeDesktopBreakpoint = 1920;

  // Mobile breakpoint (for responsive design)
  static const double mobileBreakpoint = 768;

  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if desktop size (>= 1024px)
  static bool isDesktop(BuildContext context) =>
      screenWidth(context) >= desktopBreakpoint;

  /// Check if large desktop (>= 1440px)
  static bool isLargeDesktop(BuildContext context) =>
      screenWidth(context) >= largeDesktopBreakpoint;

  /// Check if extra large desktop (>= 1920px)
  static bool isExtraLargeDesktop(BuildContext context) =>
      screenWidth(context) >= extraLargeDesktopBreakpoint;

  /// Check if mobile/tablet (< 1024px)
  static bool isMobile(BuildContext context) =>
      screenWidth(context) < desktopBreakpoint;

  /// Check if tablet (768px - 1024px)
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if small mobile (< 768px)
  static bool isSmallMobile(BuildContext context) =>
      screenWidth(context) < mobileBreakpoint;

  /// Scale size for desktop (larger base for better readability)
  static double scaleSize(BuildContext context, double baseSize) {
    if (isExtraLargeDesktop(context)) {
      return baseSize * 1.2; // 20% larger on XL screens
    } else if (isLargeDesktop(context)) {
      return baseSize * 1.1; // 10% larger on large screens
    } else if (isDesktop(context)) {
      return baseSize; // Base size for desktop
    } else if (isTablet(context)) {
      return baseSize * 0.9; // Slightly smaller on tablet
    } else {
      return baseSize * 0.8; // Smaller on mobile
    }
  }

  /// Get desktop-optimized font size
  static double fontSize(BuildContext context, {double factor = 1.0}) {
    final baseSize = isDesktop(context) ? 16.0 : 14.0;
    return scaleSize(context, baseSize * factor);
  }

  /// Get desktop-optimized icon size
  static double iconSize(BuildContext context, {double factor = 1.0}) {
    final baseSize = isDesktop(context) ? 24.0 : 20.0;
    return scaleSize(context, baseSize * factor);
  }

  /// Get desktop-optimized border radius
  static double radius(BuildContext context, {double factor = 1.0}) {
    final baseRadius = isDesktop(context) ? 12.0 : 8.0;
    return baseRadius * factor;
  }

  /// Get sidebar width based on screen size
  static double sidebarWidth(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 280;
    } else if (isLargeDesktop(context)) {
      return 260;
    } else if (isDesktop(context)) {
      return 240;
    } else {
      return 200; // Mobile/tablet
    }
  }

  /// Get content area max width
  static double contentMaxWidth(BuildContext context) {
    if (isExtraLargeDesktop(context)) {
      return 1600;
    } else if (isLargeDesktop(context)) {
      return 1400;
    } else if (isDesktop(context)) {
      return 1200;
    } else {
      return double.infinity; // Full width on mobile
    }
  }

  /// Get table column width based on screen size
  static double tableColumnWidth(BuildContext context, {double factor = 1.0}) {
    final baseWidth = isDesktop(context) ? 150.0 : 120.0;
    return baseWidth * factor;
  }

  /// Get card padding based on screen size
  static EdgeInsets cardPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(24);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  /// Get section spacing based on screen size
  static double sectionSpacing(BuildContext context) {
    if (isDesktop(context)) {
      return 32;
    } else if (isTablet(context)) {
      return 24;
    } else {
      return 16;
    }
  }
}
