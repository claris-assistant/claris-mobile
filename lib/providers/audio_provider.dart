import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioProvider extends ChangeNotifier {
  final Record _recorder = Record();
  bool _isRecording = false;
  String _audioFilePath = '';

  bool get isRecording => _isRecording;
  String get audioFilePath => _audioFilePath;

  Future<bool> checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startRecording() async {
    if (!await checkPermission()) {
      throw Exception('Microphone permission not granted');
    }

    try {
      final tempDir = await getTemporaryDirectory();
      _audioFilePath = '${tempDir.path}/${const Uuid().v4()}.m4a';

      // Configure the recording session
      await _recorder.start(
        path: _audioFilePath,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );

      _isRecording = true;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to start recording: $e');
    }
  }

  Future<String> stopRecording() async {
    if (!_isRecording) {
      return '';
    }

    try {
      await _recorder.stop();
      _isRecording = false;
      notifyListeners();
      return _audioFilePath;
    } catch (e) {
      throw Exception('Failed to stop recording: $e');
    }
  }

  Future<void> deleteRecording() async {
    if (_audioFilePath.isNotEmpty) {
      final file = File(_audioFilePath);
      if (await file.exists()) {
        await file.delete();
      }
      _audioFilePath = '';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}