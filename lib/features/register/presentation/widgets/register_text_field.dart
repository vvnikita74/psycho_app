import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:psycho_app/config.dart';

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
