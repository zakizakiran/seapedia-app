import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ButtonType { primary, secondary, danger, outline }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.width,
    this.margin,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: _buildButtonChild(),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    final isDisabled = onPressed == null || isLoading;

    final (height, padding, borderRadius) = _getButtonDimensions();

    final (defaultBackgroundColor, defaultForegroundColor, borderColor) = _getButtonColors(
      isDisabled,
    );

    final finalBackgroundColor = backgroundColor ?? defaultBackgroundColor;
    final finalForegroundColor = textColor ?? defaultForegroundColor;

    return ElevatedButton.styleFrom(
      backgroundColor: finalBackgroundColor,
      foregroundColor: finalForegroundColor,
      disabledBackgroundColor: backgroundColor ?? AppColors.grey200,
      disabledForegroundColor: textColor ?? AppColors.grey400,
      minimumSize: Size(64, height),
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: (this.borderColor ?? borderColor) != null
            ? BorderSide(color: (this.borderColor ?? borderColor)!, width: 1.5)
            : BorderSide.none,
      ),
      elevation: type == ButtonType.primary ? 2 : 0,
      shadowColor: type == ButtonType.primary
          ? AppColors.primary.withValues(alpha: 0.3)
          : null,
    );
  }

  (double, EdgeInsetsGeometry, double) _getButtonDimensions() {
    switch (size) {
      case ButtonSize.small:
        return (
          36.0,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          8.0,
        );
      case ButtonSize.medium:
        return (
          48.0,
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          12.0,
        );
      case ButtonSize.large:
        return (
          56.0,
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          14.0,
        );
    }
  }

  (Color?, Color?, Color?) _getButtonColors(bool isDisabled) {
    if (isDisabled) {
      return (AppColors.grey200, AppColors.grey400, null);
    }

    switch (type) {
      case ButtonType.primary:
        return (AppColors.primary, AppColors.white, null);
      case ButtonType.secondary:
        return (AppColors.secondary, AppColors.white, null);
      case ButtonType.danger:
        return (AppColors.error, AppColors.white, null);
      case ButtonType.outline:
        return (AppColors.white, AppColors.primary, AppColors.primary);
    }
  }

  Widget _buildButtonChild() {
    final textStyle = _getTextStyle();

    if (isLoading) {
      return SizedBox(
        height: _getLoaderSize(),
        width: _getLoaderSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? (type == ButtonType.outline ? AppColors.primary : AppColors.white),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  TextStyle _getTextStyle() {
    final baseStyle = switch (size) {
      ButtonSize.small => AppTextStyles.buttonSmall,
      ButtonSize.medium => AppTextStyles.buttonMedium,
      ButtonSize.large => AppTextStyles.buttonLarge,
    };

    final color = textColor ?? switch (type) {
      ButtonType.primary => AppColors.white,
      ButtonType.secondary => AppColors.white,
      ButtonType.danger => AppColors.white,
      ButtonType.outline => AppColors.primary,
    };

    return baseStyle.copyWith(color: color);
  }

  double _getLoaderSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 24.0;
    }
  }
}
