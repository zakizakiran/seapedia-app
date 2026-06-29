import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? textConfirm;
  final String? textCancel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final bool showCloseButton;
  final bool showCancelButton;
  
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.textConfirm = 'Yes, Confirm',
    this.textCancel = 'No, cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.showCloseButton = true,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.grey100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            if (showCloseButton) const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.heading5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DefaultTextStyle(
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              child: content,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (showCancelButton) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (onCancel != null) {
                          onCancel!();
                        } else {
                          Get.back();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.grey300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        textCancel ?? 'Cancel',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (onConfirm != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onConfirm!();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor ?? AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        textConfirm ?? 'Confirm',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
