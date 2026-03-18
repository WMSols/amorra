import 'package:flutter/material.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/utils/app_responsive/app_responsive.dart';
import 'package:amorra/core/utils/app_styles/app_text_styles.dart';
import 'package:amorra/core/utils/app_texts/app_texts.dart';

/// Chat Processing Messages Widget
/// Displays up to 5 eye-catching rotating messages while AI is responding
/// Uses same styling as ChatTimestampWidget
class ChatProcessingMessages extends StatefulWidget {
  const ChatProcessingMessages({super.key});

  @override
  State<ChatProcessingMessages> createState() => _ChatProcessingMessagesState();
}

class _ChatProcessingMessagesState extends State<ChatProcessingMessages> {
  // List of all processing messages
  static const List<String> chatProcessingMessages = [
    AppTexts.chatProcessingThinking,
    AppTexts.chatProcessingCrafting,
    AppTexts.chatProcessingAlmostThere,
    AppTexts.chatProcessingProcessing,
    AppTexts.chatProcessingPreparing,
  ];

  // Use processing messages from AppTexts
  List<String> get _processingMessages => chatProcessingMessages;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  void _startRotation() {
    // Rotate through messages one at a time every 2.5 seconds
    // This gives enough time for the animation to complete smoothly
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _processingMessages.length;
        });
        _startRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate maximum width needed for consistent layout
    // This ensures all messages take the same space regardless of text length
    final textStyle = AppTextStyles.hintText(context).copyWith(
      color: AppColors.grey,
      fontSize: AppResponsive.scaleSize(context, 12),
    );

    // Find the longest message to set consistent width
    double maxWidth = 0;
    for (final message in _processingMessages) {
      final textPainter = TextPainter(
        text: TextSpan(text: message, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      if (textPainter.width > maxWidth) {
        maxWidth = textPainter.width;
      }
    }
    // Add some padding for smooth animation
    maxWidth += AppResponsive.screenWidth(context) * 0.1;

    return SizedBox(
      width: maxWidth,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Smooth fade transition
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

          // Smooth slide transition from left side
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(-0.3, 0), // Slide in from left
                end: Offset.zero, // End at left position
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          // Combine fade and slide for smooth transition
          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Align(
                alignment: Alignment.centerLeft, // Keep text left-aligned
                child: child,
              ),
            ),
          );
        },
        child: Text(
          _processingMessages[_currentIndex],
          key: ValueKey<int>(_currentIndex),
          style: textStyle,
          textAlign: TextAlign.left, // Ensure left alignment
        ),
      ),
    );
  }
}
