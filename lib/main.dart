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
  final TTS tts = TTS();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Blindseer Demo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
        ),

        body: const Column(
          children: [
            Boxes(),
            SizedBox(
              height: 300,
              child: Card(
                child: TextListPage(),
              ),
            ),
          ],
        ),

        // For testing the speaking functionality
        floatingActionButton: FloatingActionButton(
          child: const Text('Speak'),
          onPressed: () async {
            await tts.performTextToSpeech("Go win at league");
          },
        ),
      ),
    );
  }
}
