import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          headlineMedium: GoogleFonts.rubik(
            color: Colors.white,
            height: 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: Scaffold(body: SafeArea(child: const LoadingPage())),
      debugShowCheckedModeBanner: false,
    );
  }
}
