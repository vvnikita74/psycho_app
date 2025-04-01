import 'package:flutter/material.dart';
import 'auth/register.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Хорошего\nнастроения',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
