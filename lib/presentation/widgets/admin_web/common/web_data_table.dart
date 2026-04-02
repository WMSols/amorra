import 'package:flutter/material.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';

/// Web Data Table Widget
/// Desktop-optimized data table for admin dashboard
class WebDataTable<T> extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool sortColumnEnabled;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueChanged<int>? onSelectAll;
  final bool showCheckboxColumn;
  final double? headingRowHeight;
  final double? dataRowHeight;

  const WebDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnEnabled = true,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.showCheckboxColumn = false,
    this.headingRowHeight,
    this.dataRowHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          WebResponsive.radius(context, factor: 1.0),
        ),
        border: Border.all(color: AppColors.lightGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          WebResponsive.radius(context, factor: 1.0),
        ),
        child: DataTable(
          columns: columns,
          rows: rows,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          headingRowHeight:
              headingRowHeight ?? (WebResponsive.isDesktop(context) ? 56 : 48),
          dataRowHeight:
              dataRowHeight ?? (WebResponsive.isDesktop(context) ? 64 : 56),
          columnSpacing: WebResponsive.isDesktop(context) ? 56 : 24,
          headingRowColor: WidgetStateProperty.all(
            AppColors.lightGrey.withValues(alpha: 0.3),
          ),
          dataRowColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.lightGrey.withValues(alpha: 0.2);
            }
            return null;
          }),
          decoration: const BoxDecoration(),
          headingTextStyle: WebTextStyles.tableHeader(context),
          dataTextStyle: WebTextStyles.tableCell(context),
          checkboxHorizontalMargin: WebResponsive.isDesktop(context) ? 12 : 8,
        ),
      ),
    );
  }
}
