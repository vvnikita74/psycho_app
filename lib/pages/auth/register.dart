import 'package:flutter/material.dart';
import 'package:psycho_app/config.dart';

import 'dart:convert';

// TODO: Вынести в отдельный файл или вообще убрать
enum FieldType { text, radio }

class FormFieldConfig {
  final String label;
  final String fieldKey;
  final FieldType fieldType;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;

  FormFieldConfig({
    required this.label,
    required this.fieldKey,
    this.obscureText,
    this.inputAction,
    this.keyboardType,
    this.fieldType = FieldType.text,
  });
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Map<String, String> formValues = {};
  final List<FormFieldConfig> formFields = [
    FormFieldConfig(
      label: 'Как к вам обращаться?',
      fieldKey: 'name',
      inputAction: TextInputAction.next,
    ),
    FormFieldConfig(
      label: 'Сколько вам лет?',
      fieldKey: 'age',
      inputAction: TextInputAction.next,
    ),
    FormFieldConfig(
      label: 'Кто вы?',
      fieldKey: 'sex',
      inputAction: TextInputAction.done,
    ),
  ];

  int currentFieldIndex = 0;
  final textController = TextEditingController();

  void _handleSubmit() {
    final formJson = jsonEncode(formValues);
    debugPrint('Form data: $formJson');
  }

  void _nextField() {
    formValues[formFields[currentFieldIndex].fieldKey] = textController.text;

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
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: Config.contentPadding,
          child: Stack(
            children: [
              RegisterTextField(
                label: formFields[currentFieldIndex].label,
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
                  top: 12,
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
    this.controller,
    this.obscureText = false,
    this.inputAction = TextInputAction.done,
    this.keyboardType,
  });

  final TextInputAction inputAction;
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
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
            textInputAction: inputAction,
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
