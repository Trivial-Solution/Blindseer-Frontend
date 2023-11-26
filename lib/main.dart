import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './textlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Waiting for Firebase App...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase App Done!");
  runApp(BlindseerApp());
}

class BlindseerApp extends StatelessWidget {
  const BlindseerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blindseer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TextListPage(),
    );
  }
}
