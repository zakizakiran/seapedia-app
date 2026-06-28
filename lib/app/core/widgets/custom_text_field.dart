import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum TextFieldType { text, email, password, number, textarea }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextFieldType type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.type = TextFieldType.text,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines,
    this.maxLength,
    this.margin,
    this.contentPadding,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(widget.label!, style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),
          ],
          TextFormField(
            controller: _controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            obscureText: widget.type == TextFieldType.password
                ? _isObscure
                : false,
            keyboardType: _getKeyboardType(),
            textInputAction:
                widget.textInputAction ?? _getDefaultTextInputAction(),
            maxLines: _getMaxLines(),
            maxLength: widget.maxLength,
            inputFormatters: _getInputFormatters(),
            style: AppTextStyles.input,
            decoration: _buildInputDecoration(),
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.textarea:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getDefaultTextInputAction() {
    switch (widget.type) {
      case TextFieldType.textarea:
        return TextInputAction.newline;
      case TextFieldType.password:
        return TextInputAction.done;
      default:
        return TextInputAction.next;
    }
  }

  int? _getMaxLines() {
    if (widget.maxLines != null) return widget.maxLines;
    switch (widget.type) {
      case TextFieldType.password:
        return 1;
      case TextFieldType.textarea:
        return 4;
      default:
        return 1;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case TextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.inputHint,
      errorStyle: AppTextStyles.error,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      contentPadding:
          widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _buildBorder(AppColors.grey300),
      enabledBorder: _buildBorder(AppColors.grey300),
      focusedBorder: _buildBorder(AppColors.primary),
      errorBorder: _buildBorder(AppColors.error),
      focusedErrorBorder: _buildBorder(AppColors.error),
      disabledBorder: _buildBorder(AppColors.grey200),
      filled: true,
      fillColor: widget.enabled ? AppColors.white : AppColors.grey100,
      counterText: '', // Hide character counter
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.type == TextFieldType.password) {
      return IconButton(
        onPressed: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
        icon: Icon(
          _isObscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.grey500,
        ),
      );
    }
    return widget.suffixIcon;
  }
}
