import 'package:flutter/material.dart';

class Boxes extends StatefulWidget {
  const Boxes({super.key});

  @override
  State<Boxes> createState() => _BoxesState();
}

class _BoxesState extends State<Boxes> {
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
    return Column(
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
    );
  }
}