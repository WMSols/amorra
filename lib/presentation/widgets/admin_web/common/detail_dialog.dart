import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amorra/presentation/widgets/admin_web/common/web_button.dart';
import 'package:amorra/core/utils/web/web_responsive/web_responsive.dart';
import 'package:amorra/core/utils/web/web_spacing/web_spacing.dart';
import 'package:amorra/core/utils/web/web_text_styles/web_text_styles.dart';
import 'package:amorra/core/utils/web/web_texts/web_texts.dart';

/// Detail Dialog Widget
/// Reusable dialog for displaying details
class DetailDialog extends StatelessWidget {
  final String title;
  final List<DetailRow> rows;
  final String? closeButtonText;
  final VoidCallback? onClose;

  const DetailDialog({
    super.key,
    required this.title,
    required this.rows,
    this.closeButtonText,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: WebResponsive.isDesktop(context) ? 600 : double.infinity,
        padding: WebSpacing.all(context, factor: 2.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: WebTextStyles.heading(context)),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.close_circle),
                    onPressed: () {
                      if (onClose != null) {
                        onClose!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
              WebSpacing.large(context),
              ...rows.map((row) => _buildDetailRow(context, row)),
              WebSpacing.large(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WebButton(
                    text: closeButtonText ?? WebTexts.userDetailsClose,
                    onPressed: () {
                      if (onClose != null) {
                        onClose!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    isOutlined: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, DetailRow row) {
    return Padding(
      padding: WebSpacing.symmetric(context, v: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: WebResponsive.isDesktop(context) ? 180 : 120,
            child: Text('${row.label}:', style: WebTextStyles.label(context)),
          ),
          Expanded(child: row.value),
        ],
      ),
    );
  }
}

/// Detail Row Model
class DetailRow {
  final String label;
  final Widget value;

  const DetailRow({required this.label, required this.value});
}
