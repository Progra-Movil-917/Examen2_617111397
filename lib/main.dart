import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:examen_2_617111397/firebase_options.dart';
import 'package:examen_2_617111397/pages/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);   
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
