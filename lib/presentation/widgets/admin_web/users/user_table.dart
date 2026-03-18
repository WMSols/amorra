import 'package:flutter/material.dart';
import 'package:amorra/data/models/user_model.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_data_table.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_badge.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_card.dart';
import 'package:amorra/presentation/widgets/admin_web/users/user_actions_menu.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';
import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/core/constants/app_constants.dart';

/// User Table Widget
/// Desktop-optimized data table for users
class UserTable extends StatelessWidget {
  final List<UserModel> users;
  final Function(UserModel) onViewDetails;
  final Function(UserModel) onBlockUnblock;

  const UserTable({
    super.key,
    required this.users,
    required this.onViewDetails,
    required this.onBlockUnblock,
  });

  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text(
          WebTexts.tableHeaderName,
          style: WebTextStyles.tableHeader(context),
        ),
      ),
      DataColumn(
        label: Text(
          WebTexts.tableHeaderEmail,
          style: WebTextStyles.tableHeader(context),
        ),
      ),
      DataColumn(
        label: Text(
          WebTexts.tableHeaderStatus,
          style: WebTextStyles.tableHeader(context),
        ),
      ),
      DataColumn(
        label: Text(
          WebTexts.tableHeaderCreated,
          style: WebTextStyles.tableHeader(context),
        ),
      ),
      DataColumn(
        label: Text(
          WebTexts.tableHeaderActions,
          style: WebTextStyles.tableHeader(context),
        ),
      ),
    ];
  }

  List<DataRow> _buildRows(BuildContext context) {
    return users.map((user) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                CircleAvatar(
                  radius: WebResponsive.isDesktop(context) ? 20 : 16,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: WebTextStyles.bodyText(context).copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                WebSpacing.horizontalSpacing(context, 0.75),
                Expanded(
                  child: Text(
                    user.name,
                    style: WebTextStyles.tableCell(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          DataCell(
            Text(
              user.email ?? '-',
              style: WebTextStyles.tableCell(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Wrap(
              spacing: 8,
              children: [
                WebBadge(
                  text: user.subscriptionStatus,
                  color: _getStatusColor(user.subscriptionStatus),
                ),
                if (user.isBlocked)
                  WebBadge(
                    text: WebTexts.statusBlocked,
                    color: AppColors.error,
                  ),
              ],
            ),
          ),
          DataCell(
            Text(
              _formatDate(user.createdAt),
              style: WebTextStyles.tableCell(context),
            ),
          ),
          DataCell(
            UserActionsMenu(
              user: user,
              onViewDetails: () => onViewDetails(user),
              onBlockUnblock: () => onBlockUnblock(user),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final columns = _buildColumns(context);
    final rows = _buildRows(context);

    return WebCard(
      padding: EdgeInsets.zero,
      child: WebResponsive.isDesktop(context)
          ? WebDataTable(columns: columns, rows: rows)
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: WebDataTable(columns: columns, rows: rows),
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.subscriptionStatusActive:
        return AppColors.success;
      case AppConstants.subscriptionStatusCancelled:
        return Colors.orange;
      case AppConstants.subscriptionStatusExpired:
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
