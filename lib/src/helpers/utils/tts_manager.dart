import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSManager {
  static final TTSManager _instance = TTSManager._internal();
  factory TTSManager() => _instance;
  TTSManager._internal();

  final FlutterTts flutterTts = FlutterTts();

  Future<void> init() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      
      // Crucial for iOS/Android to ensure audio plays even if silent mode is on or other apps are playing
      await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          ],
          IosTextToSpeechAudioMode.defaultMode
      );
      
      await flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> speak(String text) async {
    try {
      await flutterTts.stop();
      if (text.isNotEmpty) {
        // Ensure language is set before speaking every time, just in case
        await flutterTts.setLanguage("en-US"); 
        await flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  Future<void> stop() async {
    try {
      await flutterTts.stop();
    } catch (e) {
       debugPrint("TTS Stop Error: $e");
    }
  }
}
