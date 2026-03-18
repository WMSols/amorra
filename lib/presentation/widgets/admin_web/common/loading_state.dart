import 'package:flutter/material.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';

/// Loading State Widget
/// Reusable loading indicator
class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}
