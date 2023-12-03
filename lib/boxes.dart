import 'package:flutter/material.dart';
import 'services/tts.dart';

class Boxes extends StatefulWidget {
  const Boxes({super.key});

  @override
  State<Boxes> createState() => _BoxesState();
}

class _BoxesState extends State<Boxes> {
  double speakingSpeed = 50;
  String voice = 'Aria';
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
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 18, 81, 163),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Talking Speed',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PlayfairDisplay",
                    fontStyle: FontStyle.italic,
                    fontSize: 25,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.bottomCenter,
                child: SliderTheme(
                  data: const SliderThemeData(
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 110,
              width: 220,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 18, 81, 163),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Voice',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "PlayfairDisplay",
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    DropdownButton(
                      dropdownColor: Colors.black,
                      items: const [
                        DropdownMenuItem(
                            value: "Aria",
                            child: Text(
                              "ARIA",
                              style: TextStyle(color: Colors.white),
                            )),
                        DropdownMenuItem(
                            value: "Test",
                            child: Text(
                              "BEN",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                      value: voice,
                      onChanged: dropDownCallBack,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: 100,
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 18, 81, 163),
                child: const Text(
                  'Speak',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PlayfairDisplay",
                    fontStyle: FontStyle.italic,
                    fontSize: 25,
                  ),
                ),
                onPressed: () async {
                  await tts.performTextToSpeech("Hello there, my name is " +
                      (voice == "Test" ? "Ben" : voice) +
                      " and I am your virtual assistant.");
                },
              ),
            ),
          ],
        ), //container or expanded
      ],
    );
  }
}
