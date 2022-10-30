import 'package:chat_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(

          Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xff000000),
            displayColor: const Color(0xff000000),

          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}


