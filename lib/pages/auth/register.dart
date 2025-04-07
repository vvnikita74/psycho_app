import 'package:flutter/material.dart';
import 'package:psycho_app/config.dart';

// TODO: Вынести в отдельный файл или вообще убрать
enum FieldType { text, radio }

class FormFieldConfig {
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String fieldKey;
  final FieldType fieldType;

  FormFieldConfig({
    required this.label,
    required this.fieldKey,
    this.obscureText = false,
    this.fieldType = FieldType.text,
    this.keyboardType,
  });
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<FormFieldConfig> formFields = [
    FormFieldConfig(label: 'Как к вам обращаться?', fieldKey: 'name'),
    FormFieldConfig(label: 'Сколько вам лет?', fieldKey: 'age'),
    FormFieldConfig(label: 'Кто вы?', fieldKey: 'sex'),
  ];

  int currentFieldIndex = 0;
  final textController = TextEditingController();

  void _nextField() {
    if (currentFieldIndex < formFields.length) {
      setState(() {
        textController.clear();
        currentFieldIndex++;
      });
    }
  }

  void _prevField() {
    if (currentFieldIndex != 0) {
      setState(() {
        textController.clear();
        currentFieldIndex--;
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
              RegisterField(
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

class RegisterField extends StatelessWidget {
  const RegisterField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

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
