import 'package:datathon/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfffbfbfb).withOpacity(0.98),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => const Color(0xFF4CA6A8)),
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.white),
          )),
          appBarTheme:
              const AppBarTheme(color: Colors.transparent, centerTitle: true),
          buttonTheme: const ButtonThemeData(buttonColor: Color(0xFF4CA6A8))),
      home: const SplashScreen(),
    );
  }
}
