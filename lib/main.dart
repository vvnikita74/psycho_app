import 'package:flutter/material.dart';
import 'package:psycho_app/pages/loading.dart';

import 'config.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Psycho',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: Config.backgroundColor,
        textTheme: TextTheme(
          headlineMedium: Config.headlineStyle,
          headlineSmall: Config.headlineStyle,
          labelMedium: Config.labelStyle,
        ),
        listTileTheme: ListTileThemeData(horizontalTitleGap: 8),
      ),
      home: LoadingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
