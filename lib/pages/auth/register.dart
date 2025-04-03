import 'package:flutter/material.dart';
import 'package:psycho_app/config.dart';

const UnderlineInputBorder inputUnderline = UnderlineInputBorder(
  borderSide: BorderSide(color: Config.headlineColor, width: 2.0),
);

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Как к вам\nобращаться?',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                  cursorColor: Config.headlineColor,
                  decoration: InputDecoration(
                    enabledBorder: inputUnderline,
                    focusedBorder: inputUnderline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
