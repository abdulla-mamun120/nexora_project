import 'package:flutter_tts/flutter_tts.dart';
import '../app_language.dart';

// Reads text aloud (used for notices)
class TtsService {
  static final FlutterTts _tts = FlutterTts();

  // Stops any current speech, then reads the new text
  static Future<void> speak(String text) async {
    await _tts.setLanguage(AppLanguage.isBangla ? 'bn-BD' : 'en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}