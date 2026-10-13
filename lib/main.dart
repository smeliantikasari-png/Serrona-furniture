import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'main_ar_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const SerronaFurnitureApp());
}

class SerronaFurnitureApp extends StatelessWidget {
  const SerronaFurnitureApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serrona Furniture AR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0047AB),
        scaffoldBackgroundColor: const Color(0xFF007BFF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(), 
        '/home_ar': (context) => const MainArScreen(),
      },
    );
  }
}
