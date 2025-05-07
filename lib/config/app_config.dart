import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  // Default server configuration
  static const String _defaultServerIP = '192.168.1.133:8888';
  static String _serverIP = _defaultServerIP;

  // Audio recording configuration
  static const int audioBitRate = 128000;
  static const int audioSampleRate = 44100;
  
  // Get the server base URL with API path
  static String get apiBaseUrl => 'http://$_serverIP/api';
  
  // Get the current server IP
  static String getServerIP() {
    return _serverIP;
  }
  
  // Set the server IP
  static void setServerIP(String ip) {
    _serverIP = ip;
  }
  
  // Load saved settings from SharedPreferences
  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _serverIP = prefs.getString('server_ip') ?? _defaultServerIP;
  }
}
