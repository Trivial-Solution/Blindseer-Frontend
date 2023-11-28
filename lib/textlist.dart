import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextListPage extends StatefulWidget {
  const TextListPage({super.key});

  @override
  State<TextListPage> createState() => _TextListPageState();
}

class _TextListPageState extends State<TextListPage> {
  FlutterTts flutterTts = FlutterTts(); // References FlutterTts

  void _speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); // 0.5 to 1.5 (deepness of voice)
    await flutterTts.speak("Hello this function works");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('texts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['descr']),
            );
          }).toList(),
        );
      },
    );
  }
}
