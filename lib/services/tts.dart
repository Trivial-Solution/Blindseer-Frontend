import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class TTS {
  late final ServiceAccountCredentials credentials;
  late final AccessCredentials accessCredentials;
  late String accessToken;
  final Uri url = Uri.parse('https://texttospeech.googleapis.com/v1/text:synthesize');

  TTS() {
    apiInit(); // Ensures initialization
  }

  Future<void> apiInit() async {
    String jsonString = await rootBundle.loadString('skilled-mission-405818-0b879b4080fd.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);
    credentials = ServiceAccountCredentials.fromJson(jsonData);

    accessCredentials = await obtainAccessCredentialsViaServiceAccount(
        credentials, ['https://www.googleapis.com/auth/cloud-platform'],
        http.Client());

    accessToken = accessCredentials.accessToken.data;
  }

  Future<void> playBase64EncodedAudio(String base64Audio) async {
    Uint8List bytes = base64.decode(base64Audio);
    AudioPlayer player = AudioPlayer();

    try {
      await player.setAudioSource(
          AudioSource.uri(Uri.dataFromBytes(bytes, mimeType: 'audio/mpeg')));
      player.play(); // Play the audio
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> performTextToSpeech(var text) async {
    var request = {
      'input': {'text': text},
      'voice': {
        'languageCode': 'en-GB',
        'ssmlGender': 'MALE',
        'name': 'en-GB-Studio-B'
      },
      'audioConfig': {'audioEncoding': 'MP3'},
    };

    var headers = {
      'Authorization': 'Bearer $accessToken', // Use accessToken directly
      'Content-Type': 'application/json',
    };

    var response = await http.post(url, headers: headers, body: json.encode(request));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var audioContent = jsonResponse['audioContent'];

      await playBase64EncodedAudio(audioContent); // Play audio from base64 data
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }
}

