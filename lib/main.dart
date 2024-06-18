import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:examen_2_617111397/firebase_options.dart';
import 'package:examen_2_617111397/pages/login.dart';
import 'package:examen_2_617111397/pages/create_user.dart';
import 'package:examen_2_617111397/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);   
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
