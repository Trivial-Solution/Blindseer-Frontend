import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/tts.dart'; // Import the TTS class

class TextListPage extends StatefulWidget {
  const TextListPage({super.key});

  @override
  State<TextListPage> createState() => _TextListPageState();
}

class _TextListPageState extends State<TextListPage> {
  final TTS tts = TTS(); // Create an instance of TTS
  String lastSpokenText = ''; // To keep track of the last spoken text
  bool _isTTSInitialized = false;

  Future<void> initializeTTS() async {
    try {
      await tts.initialize();
      setState(() {
        _isTTSInitialized = true;
      });
    } catch (e) {
      // Handle TTS initialization error
    } // Wait for TTS to initialize before using it
  }

  @override
  void initState() {
    super.initState();
    initializeTTS();
    // Listen to Firestore stream
    FirebaseFirestore.instance
        .collection('texts')
        .snapshots()
        .listen((snapshot) {
      // Get the latest text
      var latestText = snapshot.docs.last.data()['descr'];
      // Check if the latest text is different from the last spoken text
      if (latestText != lastSpokenText) {
        _speak(latestText);
        lastSpokenText = latestText; // Update the last spoken text
      }
    });
  }

  void _speak(String text) async {
    await tts.performTextToSpeech(text); // Use the performTextToSpeech method
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('texts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: [
                    Divider(
                      height: 20,
                      thickness: 2,
                      color: Color.fromARGB(255, 18, 81, 163),
                    ),
                    ListTile(
                      leading: Text(
                        document.reference.id.substring(0, 10) +
                            "\n" +
                            document.reference.id
                                .substring(11, 16)
                                .replaceAll("-", ":"),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      title: Text(
                        data['descr'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              })
              .toList()
              .reversed
              .toList(),
        );
      },
    );
  }
}
