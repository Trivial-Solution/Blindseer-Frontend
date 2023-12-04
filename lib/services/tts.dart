import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'package:just_audio/just_audio.dart';

class TTS {
  late final ServiceAccountCredentials credentials;
  late final AccessCredentials accessCredentials;
  String voice = "en-GB-Studio-B";
  double speakingRate = 1.0;
  late String accessToken;
  final Uri url =
      Uri.parse('https://texttospeech.googleapis.com/v1/text:synthesize');
  final AudioPlayer player = AudioPlayer(); // Audio player instance

  bool isSpeaking = false; // Flag to check if currently speaking
  Queue<String> textQueue = Queue<String>(); // Queue for texts

  TTS();

  void setSettings(String voice, double speakingRate) {
    this.voice = voice;
    this.speakingRate = speakingRate;
    print("Voice updated to ${this.voice} with ${this.speakingRate}");
  }

  Future<void> apiInit() async {
    String jsonString = await rootBundle
        .loadString('assets/skilled-mission-405818-0b879b4080fd.json');

    Map<String, dynamic> jsonData = json.decode(jsonString);
    credentials = ServiceAccountCredentials.fromJson(jsonData);

    accessCredentials = await obtainAccessCredentialsViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/cloud-platform'],
        http.Client());

    accessToken = accessCredentials.accessToken.data;
  }

  Future<void> playBase64EncodedAudio(String base64Audio) async {
    Uint8List bytes = base64.decode(base64Audio);

    try {
      await player.setAudioSource(
          AudioSource.uri(Uri.dataFromBytes(bytes, mimeType: 'audio/mpeg')));
      await player.play(); // Play the audio
      isSpeaking = true;
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isSpeaking = false; // Update flag when audio playback is completed
          if (textQueue.isNotEmpty) {
            performTextToSpeech(textQueue.removeFirst()); // Speak next text
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error playing audio: $e");
      }
      isSpeaking = false; // Ensure flag is reset on error
      if (textQueue.isNotEmpty) {
        performTextToSpeech(textQueue.removeFirst()); // Speak next text
      }
    }
  }

  Future<void> performTextToSpeech(String text) async {
    if (isSpeaking) {
      textQueue.add(text); // Add text to queue if TTS is currently speaking
      return;
    }

    var request = {
      'input': {'text': text},
      'voice': {
        'languageCode': 'en-GB',
        'ssmlGender': (voice == "en-GB-Studio-B" ? 'MALE' : 'FEMALE'),
        'name': voice
      },
      'audioConfig': {
        'audioEncoding': 'MP3',
        'speakingRate': speakingRate,
      },
    };

    var headers = {
      'Authorization': 'Bearer $accessToken', // Use accessToken directly
      'Content-Type': 'application/json',
    };

    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var audioContent = jsonResponse['audioContent'];
      await playBase64EncodedAudio(audioContent);
    } else {
      if (kDebugMode) {
        print('Error with Text-to-Speech API: ${response.statusCode}');
      }
    }
  }

  Future<void> initialize() async {
    await apiInit();
    if (accessCredentials.accessToken.data != null) {
      accessToken = accessCredentials.accessToken.data;
    } else {
      // Handle the case where the accessToken couldn't be obtained
      throw Exception('Failed to initialize TTS service.');
    }
  }
}
