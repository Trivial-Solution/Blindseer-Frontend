import 'package:flutter/material.dart';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:audioplayers/audioplayers.dart';

/*
const List<String> voices = <String>[
  'Jenny',
  'Guy',
  'Aria',
  'Davis',
  'Amber',
  'Andrew',
  'Brian'
];
*/

void main() {
  /*
  AzureTts.init(
      subscriptionKey: "YOUR SUBSCRIPTION KEY",
      region: "YOUR REGION",
      withLogs: true); // enable logs
  */
  //getVoices();

  runApp(const MyApp());
}

/*
void getVoices() async {
  // Get available voices
  final voicesResponse = await AzureTts.getAvailableVoices();

  //Pick a Neural voice
  final voice = voicesResponse.voices
      .where((element) => element.locale.startsWith("en-"))
      .toList(growable: false).first;
}

void readText(){

}
*/

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double speakingSpeed = 50;
  String voice = 'Aria';

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
          ],
        ),

        // For testing the speaking functionality
        floatingActionButton: FloatingActionButton(
          child: const Text('Speak'),
          onPressed: () {},
        ),
      ),
    );
  }
}
