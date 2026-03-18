import 'package:flutter/material.dart';
import 'package:amorra/core/utils/app_fonts/app_fonts.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';

/// Web Text Styles Utility
/// Desktop-optimized text styles for web admin dashboard
class WebTextStyles {
  /// Large heading (for page titles)
  static TextStyle largeHeading(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 2.0),
    fontFamily: AppFonts.primaryFont,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    letterSpacing: -0.5,
  );

  /// Medium heading (for section titles)
  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 1.5),
    fontFamily: AppFonts.primaryFont,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    letterSpacing: -0.3,
  );

  /// Small heading (for subsection titles)
  static TextStyle smallHeading(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 1.25),
    fontFamily: AppFonts.primaryFont,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  /// Body text (default text)
  static TextStyle bodyText(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 1.0),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    height: 1.5, // Better line height for desktop readability
  );

  /// Small body text
  static TextStyle smallBodyText(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.875),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    height: 1.4,
  );

  /// Hint text (for placeholders)
  static TextStyle hintText(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 1.0),
    fontFamily: AppFonts.secondaryFont,
    color: Theme.of(context).hintColor,
    height: 1.5,
  );

  /// Button text
  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 1.0),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  /// Table header text
  static TextStyle tableHeader(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.875),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    letterSpacing: 0.3,
  );

  /// Table cell text
  static TextStyle tableCell(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.875),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    height: 1.4,
  );

  /// Label text (for form labels)
  static TextStyle label(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.875),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    letterSpacing: 0.2,
  );

  /// Caption text (for small notes, timestamps)
  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.75),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).hintColor,
    height: 1.3,
  );

  /// Badge text (for status badges)
  static TextStyle badge(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.75),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Link text
  static TextStyle link(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 1.0),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.primary,
    decoration: TextDecoration.underline,
    decorationColor: Theme.of(context).colorScheme.primary,
  );

  /// Error text
  static TextStyle error(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.875),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.normal,
    color: Colors.red,
    height: 1.4,
  );

  /// Success text
  static TextStyle success(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.875),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.normal,
    color: Colors.green,
    height: 1.4,
  );

  /// Warning text
  static TextStyle warning(BuildContext context) => TextStyle(
    fontSize: WebResponsive.fontSize(context, factor: 0.875),
    fontFamily: AppFonts.secondaryFont,
    fontWeight: FontWeight.normal,
    color: Colors.orange,
    height: 1.4,
  );
}
