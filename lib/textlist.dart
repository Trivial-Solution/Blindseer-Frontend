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

  @override
  void initState() {
    super.initState();
    // Listen to Firestore stream
    FirebaseFirestore.instance.collection('texts').snapshots().listen((snapshot) {
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
                return ListTile(
                  title: Text(data['descr']),
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
