import 'package:flutter/material.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_filter_chip.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';

/// Filter Chips Row Widget
/// Reusable row of filter chips
class FilterChipsRow extends StatelessWidget {
  final List<FilterChipItem> chips;

  const FilterChipsRow({super.key, required this.chips});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: WebResponsive.isDesktop(context) ? 12 : 8,
      runSpacing: WebResponsive.isDesktop(context) ? 12 : 8,
      children: chips.map((chip) {
        return WebFilterChip(
          label: chip.label,
          isSelected: chip.isSelected,
          onTap: chip.onTap,
        );
      }).toList(),
    );
  }
}

/// Filter Chip Item Model
class FilterChipItem {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
}
