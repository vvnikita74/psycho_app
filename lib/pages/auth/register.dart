import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:psycho_app/config.dart';

import 'dart:convert';

sealed class RegisterFieldConfig {
  final String label;
  final String fieldKey;
  final bool Function(String value)? validate;

  RegisterFieldConfig({
    required this.label,
    required this.fieldKey,
    this.validate,
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
    this.obscureText = false,
    super.validate,
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
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Zа-яА-ЯёЁ\s'-]")),
        LengthLimitingTextInputFormatter(30),
      ],
    ),
    TextFieldConfig(
      label: 'Сколько вам лет?',
      fieldKey: 'age',
      // regExp: RegExp(r"^(1[0-4][0-9]|150|[1-9][0-9]?)$"),
      keyboardType: TextInputType.number,
      inputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
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
    TextFieldConfig(
      label: 'Ваш электронный адрес',
      fieldKey: 'email',
      // regExp: RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"),
      keyboardType: TextInputType.emailAddress,
      inputAction: TextInputAction.next,
    ),
    TextFieldConfig(
      label: 'Введите пароль',
      fieldKey: 'password',
      // regExp: RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{8,30}$"),
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      keyboardType: TextInputType.text,
      obscureText: true,
      inputAction: TextInputAction.next,
    ),
  ];

  int currentFieldIndex = 0;
  final textController = TextEditingController();

  void _handleSubmit() {
    final formJson = jsonEncode(formValues);
    debugPrint('Form data: $formJson');
  }

  void _nextField([String? _]) {
    // final currentField = formFields[currentFieldIndex];
    // final currentValue = formValues[currentField.fieldKey];

    // if (currentField.regExp?.hasMatch(currentValue ?? '') ?? false) {
    //   return;
    // }

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

  void _handleChange(String? value) {
    formValues[formFields[currentFieldIndex].fieldKey] = value ?? '';
  }

  void _prevField() {
    if (currentFieldIndex != 0) {
      setState(() {
        currentFieldIndex--;
        textController.text =
            formValues[formFields[currentFieldIndex].fieldKey] ?? '';
      });
    }
  }

  Widget _buildField(
    RegisterFieldConfig config, {
    required TextEditingController controller,
    required void Function(String? value) onSubmitted,
    required void Function(String? value) onChange,
    required String currentValue,
  }) {
    return switch (config) {
      TextFieldConfig() => RegisterTextField(
        label: config.label,
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChange,
        inputAction: config.inputAction,
        keyboardType: config.keyboardType,
        inputFormatters: config.inputFormatters,
        obscureText: config.obscureText,
      ),
      RadioFieldConfig() => RegisterRadioField(
        initialValue: currentValue,
        label: config.label,
        fields: config.fields,
        onChanged: onChange,
      ),
    };
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
        child: Padding(
          padding: Config.contentPadding,
          child: Stack(
            children: [
              _buildField(
                currentField,
                controller: textController,
                onSubmitted: _nextField,
                onChange: _handleChange,
                currentValue: formValues[currentField.fieldKey] ?? '',
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
  final String label;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final TextInputType? keyboardType;

  const RegisterTextField({
    required this.label,
    super.key,
    this.inputAction = TextInputAction.done,
    this.obscureText = false,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
  });

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
            onChanged: onChanged,
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
