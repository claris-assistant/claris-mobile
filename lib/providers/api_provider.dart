import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8888/api';
  String _lastResponse = '';
  bool _isLoading = false;

  ApiProvider() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  String get lastResponse => _lastResponse;
  bool get isLoading => _isLoading;

  Future<String> transcribeAudio(File audioFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFile.path,
          filename: 'recording.m4a',
        ),
      });

      final response = await _dio.post(
        '/transcribe',
        data: formData,
      );

      if (response.statusCode == 200) {
        _lastResponse = response.data['text'] ?? '';
        return _lastResponse;
      } else {
        throw Exception('Failed to transcribe audio: ${response.statusCode}');
      }
    } catch (e) {
      _lastResponse = 'Error: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> processCommand(String command) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post(
        '/command',
        data: {'command': command},
      );

      if (response.statusCode == 200) {
        _lastResponse = response.data['response'] ?? '';
        return _lastResponse;
      } else {
        throw Exception('Failed to process command: ${response.statusCode}');
      }
    } catch (e) {
      _lastResponse = 'Error: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}