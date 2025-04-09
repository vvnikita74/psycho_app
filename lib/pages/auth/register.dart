import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:psycho_app/config.dart';

import 'dart:convert';

enum FieldType { text, radio }

class RadioField {
  final String label;
  final String value;

  RadioField({required this.label, required this.value});
}

class RegisterFieldConfig {
  final String label;
  final String fieldKey;
  final FieldType fieldType;

  RegisterFieldConfig({
    required this.fieldType,
    required this.label,
    required this.fieldKey,
  });
}

class RadioFieldConfig extends RegisterFieldConfig {
  final List<RadioField> fields;

  RadioFieldConfig({
    super.fieldType = FieldType.radio,
    required super.fieldKey,
    required super.label,
    required this.fields,
  });
}

class TextFieldConfig extends RegisterFieldConfig {
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldConfig({
    super.fieldType = FieldType.text,
    required super.label,
    required super.fieldKey,
    this.obscureText,
    this.inputAction,
    this.keyboardType,
    this.inputFormatters,
  });
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Map<String, String> formValues = {};
  final List<RegisterFieldConfig> formFields = [
    TextFieldConfig(
      label: 'Как к вам обращаться?',
      fieldKey: 'name',
      inputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я]')),
      ],
    ),
    TextFieldConfig(
      label: 'Сколько вам лет?',
      fieldKey: 'age',
      keyboardType: TextInputType.number,
      inputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    ),
    RadioFieldConfig(
      label: 'Кто вы?',
      fieldKey: 'sex',
      fields: [
        RadioField(label: "Мужчина", value: "male"),
        RadioField(label: "Женщина", value: "female"),
        RadioField(label: "Другое", value: "other"),
      ],
    ),
  ];

  int currentFieldIndex = 0;
  final textController = TextEditingController();

  void _handleSubmit() {
    final formJson = jsonEncode(formValues);
    debugPrint('Form data: $formJson');
  }

  void _nextField([String? value]) {
    formValues[formFields[currentFieldIndex].fieldKey] =
        value ?? textController.text;

    if (currentFieldIndex < formFields.length - 1) {
      setState(() {
        currentFieldIndex++;
        textController.text =
            formValues[formFields[currentFieldIndex].fieldKey] ?? '';
      });
    } else {
      _handleSubmit();
    }
  }

  void _prevField() {
    formValues[formFields[currentFieldIndex].fieldKey] = textController.text;

    if (currentFieldIndex != 0) {
      setState(() {
        textController.clear();
        currentFieldIndex--;
        textController.text =
            formValues[formFields[currentFieldIndex].fieldKey] ?? '';
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentField = formFields[currentFieldIndex];

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: Config.contentPadding,
          child: Stack(
            children: [
              RegisterTextField(
                label: currentField.label,
                inputAction: currentField.inputAction,
                onSubmitted: _nextField,
                controller: textController,
              ),
              if (currentFieldIndex > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: IconButton.filled(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Config.backgroundLightColor,
                      ),
                    ),
                    padding: const EdgeInsets.all(Config.basePadding / 2),
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: Config.buttonTextColor,
                    ),
                    onPressed: _prevField,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          alignment: FractionalOffset.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: Config.buttonStyle,
                  onPressed: _nextField,
                  child: Text('Продолжить', style: Config.buttonTextStyle),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: (Config.basePadding * 2),
                  top: Config.basePadding,
                ),
                child: Text(
                  'У меня есть аккаунт',
                  style: Config.buttonTextStyle.copyWith(
                    color: Config.headlineColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    super.key,
    required this.label,
    this.inputAction = TextInputAction.done,
    this.obscureText = false,
    this.controller,
    this.onSubmitted,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const inputUnderline = UnderlineInputBorder(
      borderSide: BorderSide(color: Config.headlineColor, width: 2.0),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium,
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.4,
          alignment: FractionalOffset.center,
          child: TextField(
            controller: controller,
            onSubmitted: onSubmitted,
            textInputAction: inputAction,
            inputFormatters: inputFormatters,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
            keyboardType: keyboardType,
            obscureText: obscureText,
            cursorColor: Config.headlineColor,
            decoration: InputDecoration(
              enabledBorder: inputUnderline,
              focusedBorder: inputUnderline,
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterRadioField extends StatelessWidget {
  const RegisterRadioField({
    super.key,
    required this.fields,
    required this.groupValue,
    required this.onChanged,
  });

  final List<RadioField> fields;
  final String groupValue;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          fields.map((field) {
            return RadioListTile(
              title: Text(field.label),
              value: field.value,
              groupValue: groupValue,
              onChanged: onChanged,
            );
          }).toList(),
    );
  }
}
