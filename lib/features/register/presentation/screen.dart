import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psycho_app/config.dart';
import 'dart:convert';

import './widgets/index.dart';
import '../domain/register_field_config.dart';

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
      validator: (value) {
        if (value.isEmpty) return 'Пожалуйста, введите имя';
        if (value.length < 2) return 'Имя слишком короткое';
        return null;
      },
    ),
    TextFieldConfig(
      label: 'Сколько вам лет?',
      fieldKey: 'age',
      keyboardType: TextInputType.number,
      inputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      validator: (value) {
        final age = int.tryParse(value) ?? 0;

        if (age == 0) return 'Пожалуйста, введите возраст';
        if (age < 10) return 'Минимальный возраст - 10 лет';
        if (age > 150) return 'Пожалуйста, введите реальный возраст';
        return null;
      },
    ),
    RadioFieldConfig(
      label: 'Кто вы?',
      fieldKey: 'sex',
      fields: [
        RadioField(label: "Мужчина", value: "male"),
        RadioField(label: "Женщина", value: "female"),
        RadioField(label: "Другое", value: "other"),
      ],
      validator: (value) {
        if (value.isEmpty) return 'Пожалуйста, выберите вариант';
        return null;
      },
    ),
    TextFieldConfig(
      label: 'Ваш электронный адрес',
      fieldKey: 'email',
      keyboardType: TextInputType.emailAddress,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) return 'Пожалуйста, введите email';
        if (!RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        ).hasMatch(value)) {
          return 'Введите корректный email';
        }
        return null;
      },
    ),
    TextFieldConfig(
      label: 'Введите пароль',
      fieldKey: 'password',
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      keyboardType: TextInputType.text,
      obscureText: true,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) return 'Пожалуйста, введите пароль';
        if (value.length < 8) return 'Пароль должен быть не менее 8 символов';
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
          return 'Пароль должен содержать буквы и цифры';
        }
        return null;
      },
    ),
  ];

  int currentFieldIndex = 0;
  final textController = TextEditingController();

  void _handleSubmit() {
    final formJson = jsonEncode(formValues);
    debugPrint('Form data: $formJson');
  }

  void _nextField([String? _]) {
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
              Padding(
                padding: const EdgeInsets.only(
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
