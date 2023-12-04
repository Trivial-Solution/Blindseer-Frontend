import 'package:flutter/material.dart';
import 'services/tts.dart';

class Boxes extends StatefulWidget {
  TTS tts;
  Boxes({super.key, required this.tts});

  @override
  State<Boxes> createState() => _BoxesState();
}

class _BoxesState extends State<Boxes> {
  double speakingSpeed = 50;
  String voice = "en-GB-Studio-B";
  double speakingRate = 1.0;

  void dropDownCallBack(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        voice = selectedValue;
      });
      updateTTS();
    }
  }

  void updateTTS() {
    widget.tts.setSettings(voice, speakingRate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 18, 81, 163),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(children: [
              Align(
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
                margin: EdgeInsets.all(5),
                alignment: Alignment.bottomCenter,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 10,
                  ),
                  child: Slider(
                    value: speakingSpeed,
                    max: 100,
                    divisions: 10,
                    label: speakingSpeed.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        speakingRate = value / 100 + 0.5;
                      });
                      updateTTS();
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
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 18, 81, 163),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
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
                      items: [
                        DropdownMenuItem(
                            value: "en-GB-Studio-B",
                            child: Text(
                              "PAUL",
                              style: TextStyle(color: Colors.white),
                            )),
                        DropdownMenuItem(
                            value: "en-GB-Neural2-C",
                            child: Text(
                              "DAISY",
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
                child: Text(
                  'Speak',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PlayfairDisplay",
                    fontStyle: FontStyle.italic,
                    fontSize: 25,
                  ),
                ),
                onPressed: () async {
                  await widget.tts.performTextToSpeech(
                    "Hello there, my name is " +
                        (voice == "Test"
                            ? "Daisy"
                            : (voice == "en-GB-Studio-B" ? "Paul" : voice)) +
                        " and I am your virtual assistant.",
                  );
                },
              ),
            ),
          ],
        ), //container or expanded
      ],
    );
  }
}
