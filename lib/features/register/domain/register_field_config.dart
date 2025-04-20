import 'package:flutter/services.dart';

sealed class RegisterFieldConfig {
  final String label;
  final String fieldKey;
  final String? Function(String value)? validator;

  RegisterFieldConfig({
    required this.label,
    required this.fieldKey,
    this.validator,
  });
}

class RadioField {
  final String label;
  final String value;

  RadioField({required this.label, required this.value});
}

class RadioFieldConfig extends RegisterFieldConfig {
  final List<RadioField> fields;

  RadioFieldConfig({
    required super.fieldKey,
    required super.label,
    required this.fields,
    super.validator,
  });
}

class TextFieldConfig extends RegisterFieldConfig {
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldConfig({
    required super.label,
    required super.fieldKey,
    super.validator,
    this.obscureText = false,
    this.inputAction,
    this.keyboardType,
    this.inputFormatters,
  });
}
