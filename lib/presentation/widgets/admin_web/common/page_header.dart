import 'package:flutter/material.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_search_bar.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_card.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';

/// Page Header Widget
/// Reusable header section with title, search bar, and optional filter chips
class PageHeader extends StatelessWidget {
  final String title;
  final String searchHint;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final Widget? filterChips;

  const PageHeader({
    super.key,
    required this.title,
    required this.searchHint,
    this.searchController,
    this.onSearchChanged,
    this.filterChips,
  });

  @override
  Widget build(BuildContext context) {
    return WebCard(
      padding: WebSpacing.all(context, factor: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: WebTextStyles.heading(context)),
          WebSpacing.medium(context),
          // Search Bar
          WebSearchBar(
            controller: searchController,
            hintText: searchHint,
            onChanged: onSearchChanged,
          ),
          if (filterChips != null) ...[
            WebSpacing.medium(context),
            // Filter Chips
            filterChips!,
          ],
        ],
      ),
    );
  }
}
