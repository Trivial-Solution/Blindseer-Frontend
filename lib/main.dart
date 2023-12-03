import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import './textlist.dart';
import 'services/tts.dart';
import 'boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    print("Waiting for Firebase App...");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print("Firebase App Done!");
  }
  runApp(BlindseerApp());
}

class BlindseerApp extends StatefulWidget {
  const BlindseerApp({Key? key}) : super(key: key);

  @override
  State<BlindseerApp> createState() => _BlindseerAppState();
}

class _BlindseerAppState extends State<BlindseerApp> {
  // Create a TTS object

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: const Text(
              '╔═══ Blindseer ═══╗',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "EagleLake",
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Color.fromARGB(255, 18, 81, 163),
              ],
            ),
          ),
          child: const Column(
            children: [
              SizedBox(
                height: 600,
                child: Card(
                  color: Colors.black45,
                  child: TextListPage(),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Boxes(),
            ],
          ),
        ),
      ),
    );
  }
}
