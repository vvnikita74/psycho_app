import 'package:flutter/material.dart';
import 'package:psycho_app/config.dart';

import '../../domain/register_field_config.dart';

class RegisterRadioField extends StatefulWidget {
  final String initialValue;
  final String label;
  final List<RadioField> fields;
  final void Function(String?) onChanged;

  const RegisterRadioField({
    required this.initialValue,
    required this.label,
    required this.fields,
    required this.onChanged,
    super.key,
  });

  @override
  State<RegisterRadioField> createState() => _RegisterRadioFieldState();
}

class _RegisterRadioFieldState extends State<RegisterRadioField> {
  String _radioValue = '';

  void onChanged(String? value) {
    setState(() {
      _radioValue = value ?? '';
    });

    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    _radioValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Config.basePadding),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium,
          ),
        ),
        ...widget.fields.map((field) {
          return RadioListTile(
            title: Text(field.label, style: textTheme.labelMedium),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Config.basePadding,
            ),
            dense: true,
            overlayColor: const WidgetStatePropertyAll<Color>(
              Config.accentColor,
            ),
            activeColor: Config.accentColor,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            fillColor: const WidgetStatePropertyAll<Color>(Config.accentColor),
            value: field.value,
            groupValue: _radioValue,
            onChanged: onChanged,
          );
        }),
      ],
    );
  }
}
