import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import './textlist.dart';
import 'services/tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Waiting for Firebase App...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase App Done!");
  runApp(BlindseerApp());
}

class BlindseerApp extends StatefulWidget {
  const BlindseerApp({Key? key}) : super(key: key);

  @override
  State<BlindseerApp> createState() => _BlindseerAppState();
}

class _BlindseerAppState extends State<BlindseerApp> {
  double speakingSpeed = 50;
  String voice = 'Aria';

  // Create a TTS object
  final TTS tts = TTS();

  void dropDownCallBack(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        voice = selectedValue;
      });
    }
  }

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

        body: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(25),
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Talking Speed',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  alignment: Alignment.bottomCenter,
                  child: SliderTheme(
                    data: const SliderThemeData(
                      thumbColor: Colors.white,
                      trackHeight: 10,
                    ),
                    child: Slider(
                      value: speakingSpeed,
                      max: 100,
                      divisions: 10,
                      label: speakingSpeed.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          speakingSpeed = value;
                        });
                      },
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 150,
              child: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(25),
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Voice',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: DropdownButton(
                    items: const [
                      DropdownMenuItem(value: "Aria", child: Text("Aria")),
                      DropdownMenuItem(value: "Test", child: Text("Test")),
                    ],
                    value: voice,
                    onChanged: dropDownCallBack,
                  ),
                ),
              ]),
            ), //container or expanded
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
